#ifndef TEST_H
#define TEST_H

#include "io.h"
#include "mem.h"

#include "types.h"

#define T_PASS  0
#define T_FAIL  1
#define T_SKIP  77

#define T_FALSE 0x00
#define T_TRUE  0xff

#define T_RETURN(state, msg) do {               \
        test_log_result (state, msg, __LINE__); \
        return (state);                         \
    } while (0)

#define t_assert(cond, msg) do {        \
        if (!(cond))                    \
        {                               \
            T_RETURN (T_FAIL, msg);     \
        }                               \
    } while (0)

#define t_assert_null(x)     t_assert((x == NULL), #x " == NULL")
#define t_assert_not_null(x) t_assert((x != NULL), #x " != NULL")

#define t_assert_eq(x, y)  t_assert((x == y), #x " == " #y)
#define t_assert_neq(x, y) t_assert((x != y), #x " != " #y)
#define t_assert_lt(x, y)  t_assert((x <  y), #x " <  " #y)
#define t_assert_lte(x, y) t_assert((x <= y), #x " <= " #y)
#define t_assert_gt(x, y)  t_assert((x >  y), #x " >  " #y)
#define t_assert_gte(x, y) t_assert((x >= y), #x " >= " #y)

#define t_assert_str_eq(x, y)  t_assert((0 == strcmp (x, y)), #x " == " #y)
#define t_assert_str_neq(x, y) t_assert((0 != strcmp (x, y)), #x " != " #y)

#define t_assert_mem_eq(x, y, n)  t_assert((0 == memcmp (x, y)), #x "[] == " #y "[]")
#define t_assert_mem_neq(x, y, n) t_assert((0 != memcmp (x, y)), #x "[] != " #y "[]")

#define DECLARE_RUN_ALL_TESTS() void run_all_tests (void)

#define DEFINE_RUN_ALL_TESTS(...)                   \
    void                                            \
    run_all_tests (void)                            \
    {                                               \
        /* {{{ */                                   \
        uint16_t pass_count = 0;                    \
        uint16_t fail_count = 0;                    \
        uint16_t skip_count = 0;                    \
                                                    \
        test_t test_list[] = { __VA_ARGS__ };       \
        size_t test_count = ARRLEN (test_list);     \
        size_t i = 0;                               \
                                                    \
        test_t test_cb;                             \
        uint8_t status;                             \
                                                    \
        for (i = 0; i < test_count; i++)            \
        {                                           \
            test_cb = test_list[i];                 \
            status = test_cb ();                    \
            switch (status) {                       \
                case T_PASS: pass_count++; break;   \
                case T_FAIL: fail_count++; break;   \
                case T_SKIP: skip_count++; break;   \
            }                                       \
        }                                           \
                                                    \
        crlf ();                                    \
        puts ("Results:");                          \
        puts_raw ("    pass: ");                    \
        putu (pass_count);                          \
        crlf ();                                    \
                                                    \
        puts_raw ("    fail: ");                    \
        putu (fail_count);                          \
        crlf ();                                    \
                                                    \
        puts_raw ("    skip: ");                    \
        putu (skip_count);                          \
        crlf ();                                    \
        /* }}} */                                   \
    }

typedef uint8_t (*test_t)(void);
const char *test_state_name(uint8_t state);
void test_log_result (uint8_t state, const char *msg, uint16_t line);

#endif
/* vim: ts=4 sts=4 sw=4 et fdm=marker
 * end of file */
