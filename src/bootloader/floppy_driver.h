
#ifndef BOOTLOADER_FLOPPY_DRIVER_H
#define BOOTLOADER_FLOPPY_DRIVER_H

#include "types.h"

uint8_t floppy_set_drive (uint8_t drive);
uint8_t floppy_set_side (uint8_t side);
uint8_t floppy_set_track (uint8_t track);
uint8_t floppy_set_sector (uint8_t sector);

uint8_t floppy_read (void *buf, uint16_t blk_cnt);

#endif
/* end of file */
