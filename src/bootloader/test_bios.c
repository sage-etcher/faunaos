#include "test_bios.h"

#include "bios.h"
#include "io.h"
#include "mem.h"
#include "test.h"

#include "types.h"

#define REQUIRE(var) do {                                       \
        if (!(var)) {                                           \
            T_RETURN(T_SKIP, #var " failed previous test");     \
        }                                                       \
    } while (0)

static int s_blk_set_drive0    = T_FALSE;
static int s_blk_set_platter0  = T_FALSE;
static int s_blk_set_cylinder0 = T_FALSE;
static int s_blk_set_sector0   = T_FALSE;
static int s_blk_reset = T_FALSE;

DECLARE_RUN_ALL_TESTS();

void
test_bios(void)
{
    run_all_tests();
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
    enum {
        BLOCK_CNT = 3,
        BUF_SIZE = 512 * BLOCK_CNT,
    };
    static uint8_t buf[BUF_SIZE];

    REQUIRE(s_blk_set_drive0);
    REQUIRE(s_blk_set_platter0);
    REQUIRE(s_blk_set_cylinder0);
    REQUIRE(s_blk_set_sector0);
    REQUIRE(s_blk_reset);

    blk_reset();
    t_assert_eq(BLKERR_NULL_DEREF, blk_read(1, &buf));

    /* A top 00:0 - A top 00:3 */
    (void)blk_set_drive(0);
    (void)blk_set_platter(0);
    (void)blk_set_cylinder(0);
    (void)blk_set_sector(0);
    (void)memset(&buf, 0x00, BUF_SIZE);
    t_assert_eq(BLKERR_OK, blk_read(BLOCK_CNT, &buf));
    t_assert_mem_eq(&buf, RAND_SECDATA, BUF_SIZE);

    t_assert_eq(BLKERR_NULL_DEREF, blk_read(1, NULL));
    t_assert_eq(BLKERR_OK, blk_read(0, NULL));
    t_assert_eq(BLKERR_OK, blk_read(0, &buf));

    /* A top 33:9 - A top 34:1 */
    (void)blk_set_cylinder(33);
    (void)blk_set_sector(9);
    (void)memset(&buf, 0x00, BUF_SIZE);
    t_assert_eq(BLKERR_OK, blk_read(BLOCK_CNT, &buf));
    t_assert_mem_eq(&buf, RAND_SECDATA, BUF_SIZE);

    /* A top 34:9 - A bottom 34:1 */
    (void)blk_set_sector(9);
    (void)memset(&buf, 0x00, BUF_SIZE);
    t_assert_eq(BLKERR_OK, blk_read(BLOCK_CNT, &buf));
    t_assert_mem_eq(&buf, RAND_SECDATA, BUF_SIZE);

    /* A top 33:9 - A top 34:1 */
    (void)blk_set_cylinder(33);
    (void)blk_set_sector(9);
    (void)memset(&buf, 0x00, BUF_SIZE);
    t_assert_eq(BLKERR_OK, blk_read(BLOCK_CNT, &buf));
    t_assert_mem_eq(&buf, RAND_SECDATA, BUF_SIZE);

    T_RETURN(T_PASS, NULL);
}

static uint8_t
test_blk_write(void)
{
}

static uint8_t
test_blk_write_protect(void)
{
}


DEFINE_RUN_ALL_TESTS(
    test_blk_unset_drive,
    test_blk_set_drive,
    test_blk_set_platter,
    test_blk_set_cylinder,
    test_blk_set_sector,
    test_blk_reset,
)

/* end of file */
