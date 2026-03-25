
#include "advantage.h"
#include "cpmstd.h"
#include "types.h"

struct disk_addr {
    uint8_t drive;
    uint8_t side;
    uint8_t track;
    uint8_t sector;
};

void _entry0 (void);
static char to_upper (char c);
static char utox (uint8_t x);
static uint8_t xtou (char c);
static uint8_t xstrtou (char *s, char **tail);
static char *prompt (char *msg);
static void timeout (void);
static uint8_t filepath_parse (char *filepath, struct bdos_fcb *fcb);
static uint8_t destination_parse (char *input, struct disk_addr *dst);
static int raw_write_disk (struct disk_addr *loc, uint16_t n);

#define CPM_SEC_SIZE        128

#define CPMLOAD_BUF_ADDR    (uint8_t *)0x2000
#define CPMLOAD_SEC_PER_BUF 40
#define CPMLOAD_BUF_SIZE    CPM_SEC_SIZE * CPMLOAD_SEC_PER_BUFFER;

void
_entry0 (void)
{
    uint8_t rc = 0xff;
    char *input_line = NULL;
    struct bdos_fcb fp;
    struct disk_addr dst;
    char src_drive = 'A';
    uint16_t buf_n = 0;
    uint8_t *dma;

    /* collect input from user */
    /* get source file */
    input_line = prompt ("filepath: $");
    if (filepath_parse (input_line, &fp))
    {
        goto exit;
    }

    if (fp.drive)
    {
        src_drive = fp.drive + 'A' - 1;
    }

    /* get desintation disk address */
    input_line = prompt ("destination [drive,side,track,sector]: $");
    if (destination_parse (input_line, &dst))
    {
        goto exit;
    }

    /* read file into memory */
    bdos_c_writestr ("insert source diskette into drive $");
    bdos_c_write (src_drive);
    bdos_c_writestr ("\n\r$");
    timeout ();

    if (0xff == bdos_f_open (&fp))
    {
        bdos_c_writestr ("error: cannot open file\n\r$");
        goto exit;
    }
    fp.current_record = 0;

    bdos_c_writestr ("reading sectors:$");
    buf_n = 0;
    dma = CPMLOAD_BUF_ADDR;
    for (uint8_t i = 0; i < CPMLOAD_SEC_PER_BUF; i++)
    {
        bdos_f_dmaoff (dma);
        dma   += CPM_SEC_SIZE;
        buf_n += CPM_SEC_SIZE;

        rc = bdos_f_read (&fp);
        if (rc == 0)
        {
            /* success */
            bdos_c_write ('.');
        }
        else if (rc == 1)
        {
            /* end of file */
            bdos_c_write ('#');
            break;
        }
        else
        {
            /* failure */
            bdos_c_writestr ("?\n\r");

            switch (rc)
            {
            case 0x09: bdos_c_writestr ("error: invalid FCB\n\r$"); break;
            case 0x0a: bdos_c_writestr ("error: fread, media changed\n\r$"); break;
            case 0xff: bdos_c_writestr ("error: fread, hardware error\n\r$"); break;
            default:
                bdos_c_writestr ("error: fread, unknown error 0$"); 
                bdos_c_write (utox (rc & 0xf0 >> 4));
                bdos_c_write (utox (rc & 0x0f));
                bdos_c_writestr ("h\n\r$");
                break;
            }
            goto exit;
        }
    }
    if (rc != 1)
    {
        bdos_c_writestr ("warning: file is too large, max 5kb\n\r$");
    }

    bdos_c_write ('\n');
    bdos_c_write ('\r');

    (void)bdos_f_close (&fp);

    /* write file to disk */
    bdos_c_writestr ("insert destination diskette into drive $");
    bdos_c_write (dst.drive + 'A');
    bdos_c_writestr ("\n\r$");
    timeout ();

    if (raw_write_disk (&dst, buf_n))
    {
        bdos_c_writestr ("error: cannot write to destination disk\n\r$");
        goto exit;
    }

    /* log operation finished */
    bdos_c_writestr ("successfully loaded bin\n\r$");

exit:
    bdos_c_writestr ("re-insert OS diskette\n\r$");
    timeout ();
    bdos_p_termcpm ();
}

static char
to_upper (char c)
{
    if ('a' <= c && c <= 'z')
    {
        return c & ~0x20;
    }

    return c;
}

static char *
prompt (char *msg)
{
    enum { BUF_MAX = 128 };
    static uint8_t _buf[sizeof (struct bdos_buffer) + BUF_MAX + 1];
    struct bdos_buffer *buf = (void *)&_buf;

    /* print */
    bdos_c_writestr (msg);

    /* get input */
    buf->size = BUF_MAX;
    buf->len  = 0;
    bdos_c_readstr (buf);
    bdos_c_write ('\n');
    bdos_c_write ('\r');

    /* null terminate */
    buf->bytes[buf->len] = '\0';

    return buf->bytes;
}

static void
timeout (void)
{
    bdos_c_writestr ("press any key to continue$");
    (void)bdos_c_read ();
    bdos_c_write ('\n');
    bdos_c_write ('\r');
}

static uint8_t
filepath_parse (char *filepath, struct bdos_fcb *fcb)
{
    uint8_t tmp_drive;
    uint16_t i;

    /* get optional drive letter */
    if (*filepath&& filepath[1] == ':')
    {
        tmp_drive = to_upper (*filepath);
        if ('A' > tmp_drive || tmp_drive > 'P')
        {
            bdos_c_writestr ("error: drive letter is out of range A-P\n\r$");
            return 1;
        }

        fcb->drive = tmp_drive - 'A' + 1;
        filepath += 2;
    }
    else
    {
        fcb->drive = 0; /* automatic */
    }

    /* get filename */
    for (i = 0; i < FILENAME_LEN && *filepath && *filepath != '.'; i++, filepath++)
    {
        fcb->filename[i] = to_upper (*filepath);
    }
    for (; i < FILENAME_LEN; i++)
    {
        fcb->filename[i] = ' ';
    }

    /* skip the dot */
    if (*filepath == '.')
    {
        filepath++;
    }
    else if (*filepath != '\0')
    {
        bdos_c_writestr ("error: filename is too long, max 8 characters\n\r$");
        return 1;
    }

    /* get the filetype */
    for (i = 0; i < FILETYPE_LEN && *filepath; i++, filepath++)
    {
        fcb->filetype[i] = to_upper (*filepath);
    }
    for (; i < FILETYPE_LEN; i++)
    {
        fcb->filetype[i] = ' ';
    }

    if (*filepath != '\0')
    {
        bdos_c_writestr ("error: filetype is too long, max 3 character\n\r$");
        return 1;
    }

    fcb->ex = 0;
    fcb->rc = 0;

    return 0;
}

static uint8_t
xtou (char c)
{
    if ('0' <= c && c <= '9') return c - '0';
    if ('A' <= c && c <= 'F') return c - 'F';
    if ('a' <= c && c <= 'f') return c - 'f';
    return 0xff; /* error */
}

static char
utox (uint8_t x)
{
    const char *lookup = "0123456789ABCDEF";
    x &= 0x0f;
    return (char)lookup[x];
}

static uint8_t
xstrtou (char *s, char **tail)
{
    uint8_t c;
    uint8_t num = 0;
    uint8_t digit;

    while ((c = *s))
    {
        s++;
        digit = xtou (c);
        if (digit == 0xff)
        {
            goto exit;
        }

        num <<= 4;
        num |= digit;
    }

exit:
    *tail = s;
    return num;
}

static uint8_t
destination_parse (char *input, struct disk_addr *dst)
{
    char *iter = input;
    dst->drive  = xstrtou (iter, &iter);
    dst->side   = xstrtou (iter, &iter);
    dst->track  = xstrtou (iter, &iter);
    dst->sector = xstrtou (iter, &iter);

    if (dst->drive >= 2)
    {
        bdos_c_writestr ("error: drive number out of range 0-1\n\r$");
        return 1;
    }

    if (dst->side >= 2)
    {
        bdos_c_writestr ("error: side is out of range 0-1\n\r$");
        return 1;
    }

    if (dst->track >= 35)
    {
        bdos_c_writestr ("error: track is out of range 0h-22h\n\r$");
        return 1;
    }

    if (dst->sector >= 10)
    {
        bdos_c_writestr ("error: sector is out of range 0-9\n\r$");
        return 1;
    }

    return 0;
}


static void
drive_step (uint8_t drv_ctrl)
{
    /* send step pulse */
    drv_ctrl ^= DCTRL_STEP_PULSE;
    adv_drive_ctrl = drv_ctrl;
    drv_ctrl ^= DCTRL_STEP_PULSE;
    adv_drive_ctrl = drv_ctrl;

    /* wait atleast 5ms (16-32ms using vsync) */
    adv_clear_vsync = 0;
    while (~adv_stat1 & STAT1_VSYNC_INT) {} /* psuedo-rand wait, 0-16ms */
    adv_clear_vsync = 0;
    while (~adv_stat1 & STAT1_VSYNC_INT) {} /* ensure atleast 16ms wait */
}

static void
send_cmd (uint8_t io_ctrl)
{
    register uint8_t status;
    register uint8_t prev_status;

    prev_status = adv_stat2;
    adv_ctrl = io_ctrl;
    do {
        status = adv_stat2;
    } while ((int)(prev_status ^ status) < 0);
}

static int
raw_write_disk (struct disk_addr *loc, uint16_t n)
{
    int retcode = 1; /* err by default */
    uint8_t io_ctrl  = 0x00;
    uint8_t drv_ctrl = 0x00;
    uint8_t cur_track;
    uint8_t cur_sector;
    uint16_t max_retry;
    uint8_t watch_sector;
    uint16_t i;
    uint8_t crc;
    uint8_t oh;

    enum { DISK_SEC_SIZE = 512 };
    uint8_t *buf = CPMLOAD_BUF_ADDR;

    bdos_c_writestr ("writing sectors:$");

    /* convert loc->sector to 0-8+F range of adv get_sector */
    if (loc->sector == 9)
    {
        watch_sector = 0x0f;
    }
    else
    {
        watch_sector = loc->sector;
    }

    /* set drive */
    if (loc->drive)
    {
        drv_ctrl |= DCTRL_DRIVE_2;
    }
    else
    {
        drv_ctrl |= DCTRL_DRIVE_1;
    }

    /* set side */
    if (loc->side)
    {
        drv_ctrl |= DCTRL_SIDE_1;
    }

    /* start motor */
    io_ctrl = CCMD_START_MOTORS | CTRL_IO_RESET | CTRL_ACQUIRE
            | CTRL_ENABLE_VSYNC;
    send_cmd (io_ctrl);

    /* home track */
    drv_ctrl |= DCTRL_STEPDIR_OUT;
    drv_ctrl &= ~DCTRL_STEP_PULSE;
    max_retry = 35;
    while (~adv_stat1 & STAT1_TRACK_ZERO)
    {
        drive_step (drv_ctrl);
        if (max_retry-- == 0)
        {
            bdos_c_writestr ("error: failed to step track to zero\n\r$");
            goto exit;
        }
    }

    /* step to loc->track */
    drv_ctrl &= ~DCTRL_STEPDIR_MASK;
    drv_ctrl |= DCTRL_STEPDIR_IN;

    for (cur_track = 0; cur_track < loc->track; cur_track++)
    {
        drive_step (drv_ctrl);
    }

    /* sector selection */
    max_retry = 11;
    do {
        while (~adv_stat1 & STAT1_SECTOR_MARK) {}
        while (adv_stat1 & STAT1_SECTOR_MARK) {}

        cur_sector = adv_stat2 & STAT2_CMD_SECTOR;
        if (max_retry-- == 0)
        {
            bdos_c_writestr ("error: cannot find sector\n\r$");
            goto exit;
        }
    } while (cur_sector != watch_sector);

    /* check write protect */
    if (adv_stat1 & STAT1_WRITE_PROTECT)
    {
        bdos_c_writestr ("error: disk is write protected\n\r$");
        goto exit;
    }

    /* set precomp */
    if (cur_track >= 15)
    {
        drv_ctrl |= DCTRL_PRECOMP;
        adv_drive_ctrl = drv_ctrl;
    }

    while (n > 0)
    {
        /* reset registers incase cp/m calls reset them */
        adv_drive_ctrl = drv_ctrl;
        send_cmd (io_ctrl);

        /* set write mode */
        adv_set_write = 1;

        /* write preamble */
        for (i = 0; i <= 33; i++)
        {
            adv_disk_data = 0x00;
        }

        /* write sync codes */
        /* sync 1 */
        adv_disk_data = 0xfb;

        /* sync2, as NS Graphical CP/M Bootloader handle it */
        adv_disk_data = ((loc->track & 0x03) << 6) | (loc->side << 4) | loc->sector;

        /* write data */
        crc = 0;
        oh = 0;
        for (i = 0; i < DISK_SEC_SIZE; i++)
        {
            /* crc calc */
            crc ^= *buf;
            oh = (crc & 0x80) >> 7;
            crc &= ~0x80;
            crc <<= 1;
            crc |= oh;

            /* write data */
            adv_disk_data = *buf++;
        }

        /* decriment buffer size */
        if (n <= DISK_SEC_SIZE)
        {
            n = 0;
        }
        else 
        {
            n -= DISK_SEC_SIZE;
        }

        /* write crc */
        adv_disk_data = crc;

        /* log sector write completion */
        bdos_c_write ('.');

        /* sequential */
        while (~adv_stat1 & STAT1_SECTOR_MARK) {}
    }


    retcode = 0; /* exit successfully */
exit:
    io_ctrl &= ~CCMD_MASK;  /* stop drive motor */
    send_cmd (io_ctrl);
    bdos_c_write ('\n');
    bdos_c_write ('\r');
    return retcode;
}

/* end of file */
