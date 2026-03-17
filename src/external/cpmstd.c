
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
 *  8bit values in A
 * 16bit values in HL */
static void
bdos_syscall (uint8_t fn, uint16_t arg)
{
    __asm__ (
        "ld c,l\n"
        "call #0x0005\n"
        "ret\n"
    );
}

C_SYSCALL (bdos_p_termcpm, 0, void _Noreturn, void, NULL)
C_SYSCALL (bdos_c_write, 2, void, uint8_t e_char, e_char)


void
bdos_c_writestr (char *de_msg)
{
    bdos_syscall (9, (uint16_t)de_msg);
    __asm__ ("ret");
}

void
bdos_c_readstr (struct bdos_buffer *de_buf)
{
    bdos_syscall (10, (uint16_t)de_buf);
    __asm__ ("ret");
}

void
bdos_drv_allreset (void)
{
    bdos_syscall (13, (uint16_t)NULL);
    __asm__ ("ret");
}

uint8_t
bdos_drv_set (uint8_t e_drive)
{
    bdos_syscall (14, (uint16_t)e_drive);
    __asm__ ("ret");
}

uint8_t
bdos_f_open (struct bdos_fcb *de_fcb)
{
    bdos_syscall (15, (uint16_t)de_fcb);
    __asm__ ("ret");
}

uint8_t
bdos_f_close (struct bdos_fcb *de_fcb)
{
    bdos_syscall (16, (uint16_t)de_fcb);
    __asm__ ("ret");
}

void
bdos_f_dmaoff (uint8_t *de_dma)
{
    bdos_syscall (26, (uint16_t)de_dma);
    __asm__ ("ret");
}

uint8_t
bdos_f_readrand (struct bdos_fcb *de_fcb)
{
    bdos_syscall (33, (uint16_t)de_fcb);
    __asm__ ("ret");
}

uint8_t
bdos_f_writerand (struct bdos_fcb *de_fcb)
{
    bdos_syscall (34, (uint16_t)de_fcb);
    __asm__ ("ret");
}

/* end of file */
