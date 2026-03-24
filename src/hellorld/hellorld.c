
#include "advantage.h"
#include "advantage_prom.h"
#include "z80std.h"

static void ret_cb (void);

void
_entry0 (void)
{
    uint8_t cursor[10] = {
        0xff, 0xff, 0xff, 0xff, 0xff,
        0xff, 0xff, 0xff, 0xff, 0xff,
    };
    struct video_data vdata = { 0 };
    adv_crt_scan = 0x00;

    vdata.pixel = VID_STD_CHARSET;
    vdata.retfp = ret_cb;
    vdata.ctemp = cursor;

    prom_video_driver (&vdata);


}

static void
ret_cb (void)
{
    return;
}

/* end of file */
