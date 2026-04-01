
#include "advantage.h"
#include "types.h"

struct floppy_driver {
    uint8_t drive;
    uint8_t side;
    uint8_t track;
    uint8_t sector;
};

static uint8_t find_sector (void);

static struct floppy_drive s_fctx;  /* floppy sector address object */
static uint8_t s_io_ctrl;
static uint8_t s_drv_ctrl;

uint8_t
floppy_set_drive (uint8_t drive)
{
    /* {{{ */
    const uint8_t MAX_DRIVE = 0x0f;

    if (drive > MAX_DRIVE)
    {
        return 1;
    }

    s_fctx.drive = drive;
    return 0;
    /* }}} */
}

uint8_t
floppy_set_side (uint8_t side)
{
    /* {{{ */
    const uint8_t MAX_SIDE = 1;

    if (side > MAX_SIDE)
    {
        return 1;
    }

    s_fctx.side = side;
    return 0;
    /* }}} */
}

uint8_t
floppy_set_track (uint8_t track)
{
    /* {{{ */
    const uint8_t MAX_TRACK = 34;

    if (track > MAX_TRACK)
    {
        return 1;
    }

    s_fctx.track = track;
    return 0;
    /* }}} */
}

uint8_t
floppy_set_sector (uint8_t sector)
{
    /* {{{ */
    const uint8_t MAX_SECTOR = 9;

    if (sector > MAX_SECTOR)
    {
        return 1;
    }

    s_fctx.sector = sector;
    return 0;
    /* }}} */
}

static uint8_t 
find_sector (void)
{
    /* {{{ */
    uint8_t errcode = 1; /* default error */
    register uint8_t wait_sector;
    register uint8_t max_retry_cnt;


    /* select drive */
    s_drv_ctrl = 0x00;
    s_drv_ctrl |= (s_fctx.drive) ? DCTRL_DRIVE_1 : DCTRL_DRIVE_2;

    /* select side */
    if (s_fctx.side)
    {
        s_drv_ctrl |= DCTRL_SIDE_1;
    }

    /* start motors */
    s_io_ctrl = CCMD_START_MOTORS | CTRL_IO_RESET | CTRL_ACQUIRE;
    send_cmd (s_io_ctrl);

    /* select track */
    s_drv_ctrl |= DCTRL_STEPDIR_OUT;
    s_drv_ctrl & ~DCTRL_STEP_PULSE;
    max_retry_cnt = 35;
    while (~adv_stat1 & STAT1_TRACK_ZERO)
    {
        floppy_step ();
        if (max_retry_cnt-- == 0)
        {
            goto exit;
        }
    }



    /* find sector */
    wait_sector = (s_fctx.sector == 9) ? 0x0f : s_fctx.sector;



    errcode = 0; /* exit successfully */
exit:
    s_io_ctrl &= ~CCMD_MASK; /* stop drive motors */
    send_cmd (s_io_ctrl);
    return errcode;
    /* }}} */
}

uint8_t
floppy_read (void *buf, uint16_t blk_cnt)
{
    /* {{{ */
    return 1;
    /* }}} */
}

uint8_t
floppy_write (void *buf, uint16_t blk_cnt)
{
    /* {{{ */
    return 1;
    /* }}} */
}


/* vim: fdm=marker
 * end of file */
