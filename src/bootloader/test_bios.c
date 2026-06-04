#include "test_bios.h"

#include "io.h"
#include "test.h"

#include "types.h"

typedef uint8_t (*test_cb_t)(void);

#define ARRLEN(arr) (sizeof (arr) / sizeof (*(arr)))

static uint8_t
test_asserts (void)
{
    puts_raw ("test_asserts... ");

    assert (TRUE, NULL);
    assert (TRUE, "msg");

    int a = 6;
    assert_eq (a, 7);

    return_pass (NULL);
}

static uint8_t 
test_pass (void)
{
    puts_raw ("test_pass... ");
    return_pass ("always pass");
}

static uint8_t 
test_fail (void)
{
    puts_raw ("test_fail... ");
    return_fail ("always fail");
}

static uint8_t 
test_skip (void)
{
    puts_raw ("test_skip... ");
    return_skip ("always skip");
}


void
test_bios (void)
{
    uint16_t pass_count = 0;
    uint16_t fail_count = 0;
    uint16_t skip_count = 0;

    test_cb_t test_list[] = {
        test_asserts,
        test_pass,
        test_fail,
        test_skip,
    };
    size_t test_count = ARRLEN (test_list);
    size_t i = 0;

    test_cb_t test_cb;
    uint8_t status;

    for (i = 0; i < test_count; i++)
    {
        test_cb = test_list[i];
        status = test_cb ();
        switch (status) {
        case PASS: pass_count++; break;
        case FAIL: fail_count++; break;
        case SKIP: skip_count++; break;
        }
    }

    //puts ("test results:");
    //puts_raw ("pass: 0x");
    //putword (pass_count);
    //putchar ('\n');
    //putchar ('\r');

    //puts_raw ("fail: 0x");
    //putword (fail_count);
    //putchar ('\n');
    //putchar ('\r');

    //puts_raw ("skip: 0x");
    //putword (skip_count);
    //putchar ('\n');
    //putchar ('\r');
}

/* end of file */
