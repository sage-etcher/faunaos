
#include "cpmstd.h"
#include "z80std.h"


#define C_SYSCALL(c_name, fn, rett, param, pname)                                \
    rett                                                                \
    c_name (param) __naked                                              \
    {                                                                   \
        bdos_syscall (fn, (uint16_t)pname);                             \
        __asm__ ("ret");                                                \
    }


/* not really void; returns 
 *  8bit values in L
 * 16bit values in DE */
static void
bdos_syscall (uint8_t l_fn, uint16_t de_arg)
{
    (void)l_fn;
    (void)de_arg;
    __asm__ (
        "ld c,l\n"          /* fn code, de param already in place */
        "call #0x0005\n"    /* bdos syscall */
        "ret\n"             /* return */
    );
}

C_SYSCALL (bdos_p_termcpm,   0, void _Noreturn, void,             NULL)
C_SYSCALL (bdos_c_read,      1, char,    void,                    NULL)
C_SYSCALL (bdos_c_write,     2, void,    char c,                  c)
C_SYSCALL (bdos_c_writestr,  9, void,    char *msg,               msg)
C_SYSCALL (bdos_c_readstr,  10, void,    struct bdos_buffer *buf, buf)
C_SYSCALL (bdos_f_open,     15, uint8_t, struct bdos_fcb *fcb,    fcb)
C_SYSCALL (bdos_f_close,    16, uint8_t, struct bdos_fcb *fcb,    fcb)

/* end of file */
