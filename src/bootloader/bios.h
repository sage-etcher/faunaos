
#ifndef FAUNAOS_BIOS
#define FAUNAOS_BIOS

#include "types.h"

#define VID_CURSOR_SHAPE_BLOCK  0x00
#define VID_CURSOR_SHAPE_HOLLOW 0x01
#define VID_CURSOR_SHAPE_LINE   0x02
#define VID_CURSOR_SHAPE_BAR    0x03
#define VID_CURSOR_SHAPE_MASK   0x03

#define VID_POS_GET_X(pos) (pos & 0x00ff);
#define VID_POS_GET_Y(pos) ((pos & 0xff00) >> 8);
#define VID_POS_SET_XY(x,y) (((y) << 8) | (x))

void vid_set_cursor_shape (uint8_t shape);
void vid_set_cursor_position (uint16_t position);
uint16_t vid_get_cursor_position (void);
void vid_write_c_raw (char c, uint8_t count);
void vid_write_c (char c);

uint8_t kb_get_status (void);
uint8_t kb_get_keycode (void);

#define BLK_TYPE_FLOPPY   0x00
#define BLK_TYPE_HARDDISK 0x80

enum {
    BLKERR_OK = 0x00,
    BLKERR_CANNOT_RESET,
    BLKERR_BAD_DRIVE,
    BLKERR_BAD_PLATTER,
    BLKERR_BAD_CYLINDER,
    BLKERR_BAD_SECTOR,
    BLKERR_WRITE_PROTECT,
    BLKERR_HARDWARE_ERROR,
};

uint8_t blk_reset (void);
uint8_t blk_set_drive (uint8_t drive);
uint8_t blk_set_platter (uint8_t platter);      /* floppy: side */
uint8_t blk_set_cylinder (uint8_t cylinder);    /* floppy: track */
uint8_t blk_set_sector (uint8_t sector);
uint8_t blk_set_write_protect (uint8_t status);
uint8_t blk_get_write_protect (void);
uint8_t blk_read (uint8_t *buf, uint8_t sec_cnt);
uint8_t blk_write (uint8_t *buf, uint8_t sec_cnt);

#endif
/* end of file */
