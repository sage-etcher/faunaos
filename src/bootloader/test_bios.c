#include "test_bios.h"

#include "bios.h"
#include "io.h"
#include "mem.h"
#include "test.h"

#include "advantage.h"
#include "types.h"

#define REQUIRE(var) do {                                       \
        if (!(var)) {                                           \
            T_RETURN(T_SKIP, #var " failed previous test");     \
        }                                                       \
    } while (0)

#define RAND_SECDATA (uint8_t *)0x2000 /* temporary define */

static int s_blk_set_drive0    = T_FALSE;
static int s_blk_set_platter0  = T_FALSE;
static int s_blk_set_cylinder0 = T_FALSE;
static int s_blk_set_sector0   = T_FALSE;
static int s_blk_reset = T_FALSE;

static void map_ram(void);
static void map_vram(void);

DECLARE_RUN_ALL_TESTS();

void
test_bios(void)
{
    g_prepare_print_cb = map_vram;
    run_all_tests();
}

static void
map_ram(void)
{
    adv_mmu_slot0 = MMU_PAGE_RAM_3;
    adv_mmu_slot1 = MMU_PAGE_RAM_2;
}

static void
map_vram(void)
{
    adv_mmu_slot0 = MMU_PAGE_VRAM_0;
    adv_mmu_slot1 = MMU_PAGE_VRAM_1;
}

static uint8_t
test_blk_unset_drive(void)
{
    puts_raw("test_blk_unset_drive...  ");

    blk_reset();
    t_assert_eq(BLKERR_NULL_DEREF, blk_set_platter(0));
    t_assert_eq(BLKERR_NULL_DEREF, blk_set_cylinder(0));
    t_assert_eq(BLKERR_NULL_DEREF, blk_set_sector(0));
    t_assert_eq(BLKERR_NULL_DEREF, blk_read(0, NULL));
    t_assert_eq(BLKERR_NULL_DEREF, blk_write(0, NULL));

    T_RETURN(T_PASS, NULL);
}

static uint8_t
test_blk_set_drive(void)
{
    puts_raw("test_blk_set_drive...    ");

    blk_reset();
    t_assert_eq(BLKERR_OK, blk_set_drive(0));
    s_blk_set_drive0 = T_TRUE;

    t_assert_eq(BLKERR_OK, blk_set_drive(1));
    t_assert_eq(BLKERR_RANGE, blk_set_drive(2));
    t_assert_eq(BLKERR_RANGE, blk_set_drive(0xff));

    T_RETURN(T_PASS, NULL);
}

static uint8_t
test_blk_set_platter(void)
{
    puts_raw("test_blk_set_platter...  ");

    REQUIRE(s_blk_set_drive0);

    blk_reset();
    (void)blk_set_drive(0);
    t_assert_eq(BLKERR_OK, blk_set_platter(0));
    s_blk_set_platter0 = T_TRUE;

    t_assert_eq(BLKERR_OK, blk_set_platter(1));
    t_assert_eq(BLKERR_RANGE, blk_set_platter(2));
    t_assert_eq(BLKERR_RANGE, blk_set_platter(0xff));

    T_RETURN(T_PASS, NULL);
}

static uint8_t
test_blk_set_cylinder(void)
{
    puts_raw("test_blk_set_cylinder... ");

    REQUIRE(s_blk_set_drive0);

    blk_reset();
    (void)blk_set_drive(0);
    t_assert_eq(BLKERR_OK, blk_set_cylinder(0));
    s_blk_set_cylinder0 = T_TRUE;

    t_assert_eq(BLKERR_OK, blk_set_cylinder(1));
    t_assert_eq(BLKERR_OK, blk_set_cylinder(33));
    t_assert_eq(BLKERR_OK, blk_set_cylinder(34));
    t_assert_eq(BLKERR_RANGE, blk_set_cylinder(35));
    t_assert_eq(BLKERR_RANGE, blk_set_cylinder(0xff));

    T_RETURN(T_PASS, NULL);
}

static uint8_t
test_blk_set_sector(void)
{
    puts_raw("test_blk_set_sector...   ");

    REQUIRE(s_blk_set_drive0);

    blk_reset();
    (void)blk_set_drive(0);
    t_assert_eq(BLKERR_OK, blk_set_sector(0));
    s_blk_set_sector0 = T_TRUE;

    t_assert_eq(BLKERR_OK, blk_set_sector(1));
    t_assert_eq(BLKERR_OK, blk_set_sector(8));
    t_assert_eq(BLKERR_OK, blk_set_sector(9));
    t_assert_eq(BLKERR_RANGE, blk_set_sector(10));
    t_assert_eq(BLKERR_RANGE, blk_set_sector(0xff));

    T_RETURN(T_PASS, NULL);
}

static uint8_t
test_blk_reset(void)
{
    puts_raw("test_blk_reset...        ");

    REQUIRE(s_blk_set_drive0);
    REQUIRE(s_blk_set_platter0);
    REQUIRE(s_blk_set_cylinder0);
    REQUIRE(s_blk_set_sector0);

    blk_reset();
    (void)blk_set_drive(0);
    blk_reset();
    t_assert_eq(BLKERR_NULL_DEREF, blk_set_platter(0));
    t_assert_eq(BLKERR_NULL_DEREF, blk_set_cylinder(0));
    t_assert_eq(BLKERR_NULL_DEREF, blk_set_sector(0));
    s_blk_reset = T_TRUE;

    T_RETURN(T_PASS, NULL);
}
 
static uint8_t
test_blk_read(void)
{
    const size_t BUF_MAX = 16 * 512;
    uint8_t *buf = (void *)0x2000;

    puts_raw("test_blk_read...         ");

    REQUIRE(s_blk_set_drive0);
    REQUIRE(s_blk_set_platter0);
    REQUIRE(s_blk_set_cylinder0);
    REQUIRE(s_blk_set_sector0);
    REQUIRE(s_blk_reset);

    /* tasks:
     * test null handling
     * - D0 P0 C00 S0..1 null buffer
     * - D0 P0 C00 S0    zero block count
     * - D0 P0 C00 S0    zero block count and null buffer
     *
     * basic operation
     * - D0 P0 C33 S8..9 1block validate operation
     *
     * test track+side wrapping and precomp toggle
     * - D0 P0 C33 S8 .. D0 P1 C00 S4 = 16blocks sequentially
     * - D0 P1 C33 S8 .. D0 P0 C00 S4 = 16blocks sequentially
     */

    map_ram(); /* reset next test_log_result() operation or testlib print */

    /* # handle NULLs and EINVAL states */
    /* catch null buffer */
    blk_reset();
    (void)blk_set_drive(0);
    t_assert_eq(BLKERR_NULL_DEREF, blk_read(1, NULL));

    /* handle 0 seccnt */
    blk_reset();
    (void)blk_set_drive(0);
    t_assert_eq(BLKERR_OK, blk_read(0, buf));

    /* handle 0 seccnt + null buffer */
    blk_reset();
    (void)blk_set_drive(0);
    t_assert_eq(BLKERR_OK, blk_read(0, NULL));

    /* # basic operation */
    blk_reset();
    (void)blk_set_drive(0);
    (void)blk_set_platter(0);
    (void)blk_set_cylinder(33);
    (void)blk_set_sector(8);
    (void)memset(buf, 0x00, 1*512);
    t_assert_eq(BLKERR_OK, blk_read(1, buf));
    t_assert_mem_eq(buf, RAND_SECDATA, 1*512);

    /* # sequential read w/ stepping */
    /* top to bottom */
    blk_reset();
    (void)blk_set_drive(0);
    (void)blk_set_platter(0);
    (void)blk_set_cylinder(33);
    (void)blk_set_sector(8);
    (void)memset(buf, 0x00, 16*512);
    t_assert_eq(BLKERR_OK, blk_read(16, buf));
    t_assert_mem_eq(buf, RAND_SECDATA, 16*512);

    /* bottom to top */
    blk_reset();
    (void)blk_set_drive(0);
    (void)blk_set_platter(1);
    (void)blk_set_cylinder(33);
    (void)blk_set_sector(8);
    (void)memset(buf, 0x00, 16*512);
    t_assert_eq(BLKERR_OK, blk_read(16, buf));
    t_assert_mem_eq(buf, RAND_SECDATA, 16*512);

    T_RETURN(T_PASS, NULL);
}

static uint8_t
test_blk_write(void)
{
    puts_raw("test_blk_write...        ");
    T_RETURN(T_SKIP, "unimplimented");
}

static uint8_t
test_blk_write_protect(void)
{
    puts_raw("test_blk_write_protect...");
    T_RETURN(T_SKIP, "unimplimented");
}


DEFINE_RUN_ALL_TESTS(
    test_blk_unset_drive,
    test_blk_set_drive,
    test_blk_set_platter,
    test_blk_set_cylinder,
    test_blk_set_sector,
    test_blk_reset,
    test_blk_read,
    test_blk_write,
    test_blk_write_protect,
)

/* end of file */
