
#ifndef EXTERNAL_CPMSTD_H
#define EXTERNAL_CPMSTD_H

#include "z80std.h"

struct bdos_buffer {
    uint8_t size;
    uint8_t len;
    uint8_t bytes[];
};

struct bdos_version {
    uint8_t machine;
    uint8_t version;
};

struct bdos_fcb {
    uint8_t drive;
    uint8_t filename[8];
    uint8_t filetype[3];
    uint8_t ex;
    uint8_t reserved[2];
    uint8_t rc;
    uint16_t blocks[8];
    uint8_t current_record;
    uint16_t record_number;
};

enum {
    CPM_MACHINE_8080  = 0x00,
    CPM_MACHINE_8086  = 0x10,
    CPM_MACHINE_68000 = 0x20,
    CPM_MACHINE_Z8000 = 0x30,
};

enum {
    CPM_TYPE_CPM   = 0x00,
    CPM_TYPE_MPM   = 0x01,
    CPM_TYPE_CPNET = 0x02,
    CPM_TYPE_MULTI = 0x04,
};

enum {
    CPM_VERSION_1  = 0x00,
    CPM_VERSION_20 = 0x20,
    CPM_VERSION_21 = 0x20,
    CPM_VERSION_22 = 0x22,
    CPM_VERSION_25 = 0x25,
    CPM_VERSION_28 = 0x28,
    CPM_VERSION_30 = 0x30,
    CPM_VERSION_31 = 0x31,
    CPM_VERSION_33 = 0x33,
    CPM_VERSION_41 = 0x41,
    CPM_VERSION_50 = 0x50,
};

#ifndef CPM_TARGET
#   define CPM_TARGET CPM_VERSION_22
#endif

void _Noreturn bdos_p_termcpm (void);               /* BDOS fn  0 - System reset */
uint8_t bdos_c_read (void);                         /* BDOS fn  1 - Console input */
void bdos_c_write (uint8_t e_char);                 /* BDOS fn  2 - Console output */
uint8_t bdos_a_read (void);                         /* BDOS fn  3 - Auxiliary input */
void bdos_a_write (uint8_t e_char);                 /* BDOS fn  4 - Auxiliary output */
void bdos_l_write (uint8_t e_char);                 /* BDOS fn  5 - Printer output */

#if CPM_TARGET >= CPM_VERSION_20
uint8_t bdos_c_rawio (uint8_t e_code);              /* BDOS fn  6 - Direct console I/O */
#endif

#if CPM_TARGET <= CPM_VERSION_28
uint8_t bdos_get_io (void);                         /* BDOS fn  7 - Get I/O byte */
void bdos_set_io (uint8_t e_io);                    /* BDOS fn  8 - Set I/O byte */
#endif

void bdos_c_writestr (char *hl_msg);                /* BDOS fn  9 - Output string */
void bdos_c_readstr (struct bdos_buffer *de_buf);   /* BDOS fn 10 - Output string */
void bdos_c_stat (void);                            /* BDOS fn 11 - Console status */

#if CPM_TARGET >= CPM_VERSION_20
struct bdos_version bdos_s_ver (void);              /* BDOS fn 12 - Return version number */
#endif

void bdos_drv_allreset (void);                      /* BDOS fn 13 - Reset disks */
uint8_t bdos_drv_set (uint8_t e_drive);             /* BDOS fn 14 - Select disk */
uint32_t bdos_f_open   (struct bdos_fcb *de_fcb);   /* BDOS fn 15 - Open file */
uint32_t bdos_f_close  (struct bdos_fcb *de_fcb);   /* BDOS fn 16 - Close file */
uint32_t bdos_f_sfirst (struct bdos_fcb *de_fcb);   /* BDOS fn 17 - Search for first */
uint32_t bdos_f_snext  (struct bdos_fcb *de_fcb);   /* BDOS fn 18 - Search for next */
uint32_t bdos_f_delete (struct bdos_fcb *de_fcb);   /* BDOS fn 19 - Delete file */
uint32_t bdos_f_read   (struct bdos_fcb *de_fcb);   /* BDOS fn 20 - Read next record */
uint32_t bdos_f_write  (struct bdos_fcb *de_fcb);   /* BDOS fn 21 - Write next record */
uint32_t bdos_f_make   (struct bdos_fcb *de_fcb);   /* BDOS fn 22 - Create file */
uint32_t bdos_f_rename (struct bdos_fcb *de_fcb);   /* BDOS fn 23 - Rename file */
uint16_t bdos_drv_loginvec (void);                  /* BDOS fn 24 - Return bitmap of logged-in drives */
uint8_t bdos_drv_get (void);                        /* BDOS fn 25 - Return current drive */
void bdos_f_dmaoff (uint16_t de_dma);               /* BDOS fn 26 - Set DMA address */
uint16_t bdos_drv_allocvec (void);                  /* BDOS fn 27 - Return address of allocation map */
void bdos_drv_setro (void);                         /* BDOS fn 28 - Software write-protect the current disk */
uint16_t bdos_drv_rovec (void);                     /* BDOS fn 29 - Return bitmap of read-only drives */

#if CPM_TARGET >= CPM_VERSION_20
uint32_t bdos_f_attrib (struct bdos_fcb *de_fcb);   /* BDOS fn 30 - set file attributes */
uint16_t bdos_drv_dpb (void);                       /* BDOS fn 31 - Get DPB address */
uint8_t bdos_f_usernum (uint8_t e_number);          /* BDOS fn 32 - Get/Set user number */
uint32_t bdos_f_readrand (struct bdos_fcb *de_fcb); /* BDOS fn 33 - Random accesss read record */
uint32_t bdos_f_writerand (struct bdos_fcb *de_fcb);/* BDOS fn 34 - Random accesss write record */
uint32_t bdos_f_size (struct bdos_fcb *de_fcb);     /* BDOS fn 35 - Compute file size */
void bdos_f_randrec (struct bdos_fcb *de_fcb);      /* BDOS fn 36 - Update Random access pointer */
#endif

#if CPM_TARGET >= CPM_VERSION_22
uint8_t bdos_drv_reset (uint16_t de_drives);        /* BDOS fn 37 - Selectively reset disc drives */
uint32_t bdos_f_writezf (struct bdos_fcb *de_fcb);  /* BDOS fn 40 - Write random with zero fill */
#endif

#endif
/* end of file */
