
#ifndef ADVANTAGE_H
#define ADVANTAGE_H

__sfr __at(0x80) adv_disk_data;     /* io read/write data on disk */
__sfr __at(0x81) adv_read_sync;     /* i  read sync byte from disk drive */
__sfr __at(0x81) adv_drive_ctrl;    /*  o drive control register*/
__sfr __at(0x82) adv_clear_read;    /* i  clear disk read/write flags */
__sfr __at(0x82) adv_set_read;      /*  o set disk read flag */
__sfr __at(0x83) adv_beep;          /* i  generates a beep sound */
__sfr __at(0x83) adv_set_write;     /*  o set disk write flag */
__sfr __at(0x90) adv_crt_scan;      /*  o crt set scanline offset */
__sfr __at(0xa0) adv_mmu_slot0;     /*  o mmu set slot 0 */
__sfr __at(0xa0) adv_mmu_slot1;     /*  o mmu set slot 1 */
__sfr __at(0xa0) adv_mmu_slot2;     /*  o mmu set slot 2 */
__sfr __at(0xa0) adv_mmu_slot3;     /*  o mmu set slot 3 */
__sfr __at(0xb0) adv_clear_vsync;   /* io crt clear vertical sync flag */
__sfr __at(0xc0) adv_clear_nmi;     /* io z80 clear non-maskable interupt */
__sfr __at(0xd0) adv_stat2;         /* i  status 2 register */
__sfr __at(0xe0) adv_stat1;         /* i  status 1 register */
__sfr __at(0xf0) adv_ctrl;          /*  o control register */

#endif
/* end of file */
