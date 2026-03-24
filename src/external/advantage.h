
#ifndef ADVANTAGE_H
#define ADVANTAGE_H

/* I/O Control Register Format 0xf0 */
#define CCMD_SHOW_SECTOR    0x00
#define CCMD_KB_LSB         0x01
#define CCMD_KB_MSB         0x02
#define CCMD_KB_NI          0x03
#define CCMD_CURSOR_LOCK    0x04
#define CCMD_START_MOTORS   0x05
#define CCMD_KB_NMI_P1      0x06
#define CCMD_KB_NMI_P2      0x07
#define CCMD_ALL_CAPS       0x07
#define CCMD_MASK           0x07

#define CTRL_ACQUIRE        0x08    /* 0 activated */
#define CTRL_IO_RESET       0x10    /* 0 activated */
#define CTRL_BLANK_DISPLAY  0x20
#define CTRL_SPEAKER_DATA   0x40
#define CTRL_ENABLE_VSYNC   0x80

/* I/O Status 1 Register Format 0xe0 */
#define STAT1_KB_INT        0x01
#define STAT1_IO_INT        0x02
#define STAT1_VSYNC_INT     0x04
#define STAT1_NMASK_INT     0x08
#define STAT1_WRITE_PROTECT 0x10
#define STAT1_TRACK_ZERO    0x20
#define STAT1_SECTOR_MARK   0x40
#define STAT1_DISK_SDATA    0x80

/* I/O Status 2 Register Format 0xd0 */
#define STAT2_CMD_SECTOR    0x0f
#define STAT2_CMD_KB_LSB    0x0f
#define STAT2_CMD_KB_HSB    0x0f
#define STAT2_CMD_KB_MI     0x01
#define STAT2_CMD_CURLOCK   0x01
#define STAT2_CMD_KB_NMI    0x01
#define STAT2_CMD_ALL_CAPS  0x01
#define STAT2_CMD_MASK      0x0f
#define STAT2_KB_REPEAT     0x10
#define STAT2_KB_C_OVERFLOW 0x20
#define STAT2_KB_DATA_INT   0x40
#define STAT2_CMD_ACK       0x80

/* Drive Control Register Format */
#define DCTRL_DRIVE_1       0x01
#define DCTRL_DRIVE_2       0x02
#define DCTRL_DRIVE_MASK    0x03
#define DCTRL_STEP_PULSE    0x10
#define DCTRL_STEPDIR_OUT   0x00
#define DCTRL_STEPDIR_IN    0x20
#define DCTRL_STEPDIR_MASK  0x20
#define DCTRL_PRECOMP       0x20
#define DCTRL_SIDE_0        0x00
#define DCTRL_SIDE_1        0x40

/* memory mapping page base addresses */
#define MMU_PAGE_0_BADDR    0x0000
#define MMU_PAGE_1_BADDR    0x4000
#define MMU_PAGE_2_BADDR    0x8000
#define MMU_PAGE_3_BADDR    0xc000

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
