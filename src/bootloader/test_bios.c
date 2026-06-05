#include "test_bios.h"

#include "io.h"
#include "mem.h"
#include "test.h"

#include "types.h"

DECLARE_RUN_ALL_TESTS ();

void
test_bios (void)
{
    run_all_tests ();
}


static uint8_t
test_asserts (void)
{
    puts_raw ("test_asserts... ");

    t_assert (T_TRUE, NULL);
    t_assert (T_TRUE, "msg");

    int a = 6;
    t_assert_eq (a, 7);

    T_RETURN (T_PASS, NULL);
}

static uint8_t 
test_pass (void)
{
    puts_raw ("test_pass... ");
    T_RETURN (T_PASS, "always pass");
}

static uint8_t 
test_fail (void)
{
    puts_raw ("test_fail... ");
    T_RETURN (T_FAIL, "always fail");
}

static uint8_t 
test_skip (void)
{
    puts_raw ("test_skip... ");
    T_RETURN (T_SKIP, "always skip");
}

static uint8_t 
test_silent (void)
{
    puts_raw ("test_silent...");
    T_RETURN (T_PASS, NULL);
}

DEFINE_RUN_ALL_TESTS (
    test_asserts,
    test_pass,
    test_fail,
    test_skip,
    test_silent,
)

/* end of file */
