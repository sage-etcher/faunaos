
#include "cpmstd.h"
#include "z80std.h"

#define SYSCALL(fn) __asm__(    \
            "ld c,#" #fn "\n"   \
            "call #0x0005\n"    \
        )


void _Noreturn
bdos_p_termcpm (void)
{
    SYSCALL (0);
    while (1)
    {
        z80_halt ();
    }
}

void
bdos_c_writestr (char *de_msg)
{
    (void)de_msg;
    __asm__ ("ex de,hl");
    SYSCALL (9);
}

void
bdos_drv_allreset (void)
{
    SYSCALL (13);
}

uint8_t
bdos_drv_set (uint8_t e_drive)
{
    (void)e_drive;
    __asm__ ("ld e,a");
    SYSCALL (14);
    __asm__ ("ret");
    return 0; /* unreachable */
}

void
bdos_f_dmaoff (uint16_t de_dma)
{
    __asm__ ("ex de,hl");
    SYSCALL (26);
}

uint32_t
bdos_f_readrand (struct bdos_fcb *de_fcb)
{
    __asm__ ("ex de,hl");
    SYSCALL (33);
}

uint32_t
bdos_f_writerand (struct bdos_fcb *de_fcb)
{
    __asm__ ("ex de,hl");
    SYSCALL (34);
}

/* end of file */
