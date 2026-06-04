#ifndef TEST_H
#define TEST_H

#include "io.h"
#include "mem.h"

#include "types.h"

#define PASS    0
#define FAIL    1
#define SKIP    77

#define FALSE   0x00
#define TRUE    0xff

#define return_state(retcode, state, msg) do {  \
        puts_raw (state);                       \
        if (msg != NULL)                        \
        {                                       \
            puts_raw (" - ");                   \
            puts_raw (msg);                     \
        }                                       \
        putchar ('\n');                         \
        putchar ('\r');                         \
        return retcode;                         \
    } while (0)

#define return_pass(msg) return_state (PASS, "pass", msg)
#define return_fail(msg) return_state (FAIL, "fail", msg)
#define return_skip(msg) return_state (SKIP, "skip", msg)

#define assert(cond, msg) do {      \
        if (!(cond))                \
        {                           \
            return_fail (msg);      \
        }                           \
    } while (0)

#define assert_null(x)     assert((x == NULL), #x " == NULL")
#define assert_not_null(x) assert((x != NULL), #x " != NULL")

#define assert_eq(x, y)  assert((x == y), #x " == " #y)
#define assert_neq(x, y) assert((x != y), #x " != " #y)
#define assert_lt(x, y)  assert((x <  y), #x " <  " #y)
#define assert_lte(x, y) assert((x <= y), #x " <= " #y)
#define assert_gt(x, y)  assert((x >  y), #x " >  " #y)
#define assert_gte(x, y) assert((x >= y), #x " >= " #y)

#define assert_str_eq(x, y)  assert((0 == strcmp (x, y)), #x " == " #y)
#define assert_str_neq(x, y) assert((0 != strcmp (x, y)), #x " != " #y)

#define assert_mem_eq(x, y, n)  assert((0 == memcmp (x, y)), #x "[] == " #y "[]")
#define assert_mem_neq(x, y, n) assert((0 != memcmp (x, y)), #x "[] != " #y "[]")


#endif
/* end of file */
