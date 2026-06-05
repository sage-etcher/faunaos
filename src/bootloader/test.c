#include "test.h"

#include "types.h"
#include "io.h"

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
    puts_raw (test_state_name (state));
    puts_raw (" @ ln");
    putu (line);
    if (msg != NULL)
    {
        puts_raw ("- ");
        puts_raw (msg);
    }
    crlf ();
}

/* end of file */
