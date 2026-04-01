
#include "floppy_driver.h"

#include "advantage.h"
#include "types.h"
#include "z80std.h"


int
main (void)
{
    register uint8_t rc = 0;

    /* init mmu */
    adv_mmu_slot0 = MMU_PAGE_VRAM_0;
    adv_mmu_slot1 = MMU_PAGE_VRAM_1;
    adv_mmu_slot2 = MMU_PAGE_PROM;

    adv_crt_scan = 0;   /* init display */

    /* read rest of bootloader from disk0:0:0:8 onwards into 0xc800 */
    const uint16_t EXT_BOOTLOADER_ADDR = 0xc800;
    const uint16_t EXT_BOOTLOADER_BLK_CNT = 3;
    rc |= floppy_set_drive  (0);
    rc |= floppy_set_side   (0);
    rc |= floppy_set_track  (0);
    rc |= floppy_set_sector (8);
    rc |= floppy_read ((void *)EXT_BOOTLOADER_ADDR, EXT_BOOTLOADER_BLK_CNT);
    if (rc)
    {
        /* error reading extended bootloader from disk */
        return 1;
    }

    /* transfer control to kernel */

    /* exit */
    while (1)
    {
        z80_halt ();
    }

    return 0;
}

/* end of file */
