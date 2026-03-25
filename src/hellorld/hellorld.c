
#include "advantage.h"
#include "advantage_prom.h"
#include "z80std.h"

void
_entry0 (void)
{
    uint16_t p;
    struct pvid_data vdata = { 0 };
    pvid_cursor_t cursor = PVID_CURSOR_DEFAULT;
    vdata.pixel = PVID_STD_CHARSET,
    vdata.ctemp = (uint8_t *)&cursor,

    adv_mmu_slot0 = MMU_PAGE_VRAM_0;
    adv_mmu_slot1 = MMU_PAGE_VRAM_1;
    adv_mmu_slot2 = MMU_PAGE_PROM;

    adv_crt_scan = 0x00;

    /* clear screen */
    for (p = 0x0000; p < 0x5000; p++)
    {
        *(uint8_t *)p = 0x00;
    }

    /* write character */
    pvid_putchar ('H', &vdata);
    //pvid_putchar ('e', &vdata);
    //pvid_putchar ('l', &vdata);
    //pvid_putchar ('l', &vdata);
    //pvid_putchar ('o', &vdata);
    //pvid_putchar ('r', &vdata);
    //pvid_putchar ('l', &vdata);
    //pvid_putchar ('d', &vdata);
    //pvid_putchar (PVID_NEWLINE, &vdata);

    while (1)
    {
        cpu_halt ();
    }
}

/* end of file */
