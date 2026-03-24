
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

#define CPM_SEC_SIZE        128

#define CPMLOAD_BUF_ADDR    (uint8_t *)0x2000
#define CPMLOAD_SEC_PER_BUF 40
#define CPMLOAD_BUF_SIZE    CPM_SEC_SIZE * CPMLOAD_SEC_PER_BUFFER;

void
_entry0 (void)
{
    uint8_t rc;
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

    if (dst->drive >= 16)
    {
        bdos_c_writestr ("error: drive number out of range 0h-0fh\n\r$");
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



/* end of file */
