#include "test.h"

#include "types.h"
#include "io.h"


#define EVAL_CALLBACK(cb, ...)                          \
    do {                                                \
        if ((cb) == NULL) { break; }                    \
        (cb)(__VA_ARGS__);                              \
    } while (0)

test_prepare_cb_t g_prepare_print_cb = (test_prepare_cb_t)NULL;
test_finalize_cb_t g_finalize_print_cb = (test_finalize_cb_t)NULL;

const char *
test_state_name (uint8_t state)
{
    switch (state)
    {
    case T_PASS: return "pass";
    case T_FAIL: return "fail";
    case T_SKIP: return "skip";
    default: return "unknown";
    }
}

void
test_log_result (uint8_t state, const char *msg, uint16_t line)
{
    EVAL_CALLBACK(g_prepare_print_cb);
    puts_raw (test_state_name (state));
    puts_raw (" @ ln");
    putu (line);
    if (msg != NULL)
    {
        puts_raw ("- ");
        puts_raw (msg);
    }
    crlf ();
    EVAL_CALLBACK(g_finalize_print_cb);
}

/* end of file */
