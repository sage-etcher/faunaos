
#include "advantage.h"
#include "advantage_prom.h"
#include "crt0.h"
#include "types.h"
#include "z80std.h"

void clear (void);

void
main (void)
{
    pvid_cursor_t cursor = PVID_CURSOR_DEFAULT;
    struct pvid_data vdata = {
        .curx = 0,
        .cury = 0,
        .pixel = PVID_STD_CHARSET,
        .scrct = 0,
        .stats = PVID_STAT_SCROLL,
        .ctemp = (uint8_t *)&cursor,
        .video = PVID_NORMAL,
    };

    adv_mmu_slot0 = MMU_PAGE_VRAM_0;
    adv_mmu_slot1 = MMU_PAGE_VRAM_1;
    adv_mmu_slot2 = MMU_PAGE_PROM;

    /* clear screen */
    adv_crt_scan = 0x00;
    clear ();

    /* write character */
    pvid_putchar ('H', &vdata);
    pvid_putchar ('e', &vdata);
    pvid_putchar ('l', &vdata);
    pvid_putchar ('l', &vdata);
    pvid_putchar ('o', &vdata);
    pvid_putchar ('r', &vdata);
    pvid_putchar ('l', &vdata);
    pvid_putchar ('d', &vdata);
    pvid_putchar (PVID_NEWLINE, &vdata);

    return;
}

void
clear (void)
{
    const uint8_t MAX_X = 0x4f;
    const uint8_t MAX_Y = 0xf0;

    register uint8_t x;
    register uint8_t y;
    register uint8_t *ptr;


    for (x = 0; x < MAX_X; x++)
    {
        for (y = 0; y < MAX_Y; y++)
        {
            ptr = (uint8_t *)(((uint16_t)x << 8) | y);
            *ptr = 0x00;
        }
    }
}

/* end of file */
