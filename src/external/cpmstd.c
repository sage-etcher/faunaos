
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

/*         name               fn  return   param                     pref */
C_SYSCALL (bdos_p_termcpm,     0, void _Noreturn, void,              NULL)
C_SYSCALL (bdos_c_read,        1, char,     void,                    NULL)
C_SYSCALL (bdos_c_write,       2, void,     char c,                  c)
C_SYSCALL (bdos_a_read,        3, char,     void,                    NULL)
C_SYSCALL (bdos_a_write,       4, void,     char c,                  c)
C_SYSCALL (bdos_l_write,       5, void,     char c,                  c)
C_SYSCALL (bdos_c_rawio,       6, uint8_t,  uint8_t code,            code)
C_SYSCALL (bdos_get_io,        7, uint8_t,  void,                    NULL)
C_SYSCALL (bdos_set_io,        8, void,     uint8_t io,              io)
C_SYSCALL (bdos_c_writestr,    9, void,     char *msg,               msg)
C_SYSCALL (bdos_c_readstr,    10, void,     struct bdos_buffer *buf, buf)
C_SYSCALL (bdos_c_stat,       11, uint8_t,  void,                    NULL)
C_SYSCALL (bdos_s_ver,        12, struct bdos_version, void,         NULL)
C_SYSCALL (bdos_drv_allreset, 13, void,     void,                    NULL)
C_SYSCALL (bdos_drv_set,      14, uint8_t,  uint8_t drive,           drive)
C_SYSCALL (bdos_f_open,       15, uint8_t,  struct bdos_fcb *fcb,    fcb)
C_SYSCALL (bdos_f_close,      16, uint8_t,  struct bdos_fcb *fcb,    fcb)
C_SYSCALL (bdos_f_sfirst,     17, uint8_t,  struct bdos_fcb *fcb,    fcb)
C_SYSCALL (bdos_f_snext,      18, uint8_t,  struct bdos_fcb *fcb,    fcb)
C_SYSCALL (bdos_f_delete,     19, uint8_t,  struct bdos_fcb *fcb,    fcb)
C_SYSCALL (bdos_f_read,       20, uint8_t,  struct bdos_fcb *fcb,    fcb)
C_SYSCALL (bdos_f_write,      21, uint8_t,  struct bdos_fcb *fcb,    fcb)
C_SYSCALL (bdos_f_make,       22, uint8_t,  struct bdos_fcb *fcb,    fcb)
C_SYSCALL (bdos_f_rename,     23, uint8_t,  struct bdos_fcb *fcb,    fcb)
C_SYSCALL (bdos_drv_loginvec, 24, uint16_t, void,                    NULL)
C_SYSCALL (bdos_drv_get,      25, uint8_t,  void,                    NULL)
C_SYSCALL (bdos_f_dmaoff,     26, void,     uint8_t *dma,            dma)
C_SYSCALL (bdos_drv_allocvec, 27, uint16_t, void,                    NULL)
C_SYSCALL (bdos_drv_setro,    28, void,     void,                    NULL)
C_SYSCALL (bdos_drv_rovec,    29, uint16_t, void,                    NULL)
C_SYSCALL (bdos_f_attrib,     30, uint8_t,  struct bdos_fcb *fcb,    fcb)
C_SYSCALL (bdos_drv_dpb,      31, uint16_t, void,                    NULL)
C_SYSCALL (bdos_f_usernum,    32, uint8_t,  uint8_t number,          number)
C_SYSCALL (bdos_f_readrand,   33, uint8_t,  struct bdos_fcb *fcb,    fcb)
C_SYSCALL (bdos_f_writerand,  34, uint8_t,  struct bdos_fcb *fcb,    fcb)
C_SYSCALL (bdos_f_size,       35, uint8_t,  struct bdos_fcb *fcb,    fcb)
C_SYSCALL (bdos_f_randrec,    36, void,     struct bdos_fcb *fcb,    fcb)
C_SYSCALL (bdos_drv_reset,    37, uint8_t,  uint16_t drives,         drives)
C_SYSCALL (bdos_f_writezf,    40, uint8_t,  struct bdos_fcb *fcb,    fcb)

/* end of file */
