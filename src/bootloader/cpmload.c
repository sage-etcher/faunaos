
#include "cpmstd.h"
#include "z80std.h"

#ifdef NDEBUG
#   define assert(cond)
#else
#   define assert(cond) \
    do { \
        if (!(cond)) \
        { \
            bdos_c_writestr ("failed assert\n\r$"); \
            bdos_p_termcpm (); \
        } \
    } while (0)

#endif

void *memset (void *dst, uint8_t byte, size_t n);
void *memcpy (void *dst, void *src, size_t n);
void hexdump (void *src, size_t n);
void string_to_upper (uint8_t *string, size_t n);

void
_entry0 (void)
{
    uint8_t rc = 0;
    struct bdos_fcb fcb = { 0 };
    uint8_t dma[512];

#define BUFFER_MAX 128
    uint8_t buffer[sizeof (struct bdos_buffer) + BUFFER_MAX];
    struct bdos_buffer *input = (struct bdos_buffer *)&buffer;

    input->size = BUFFER_MAX;
    input->len = 0;

    /* get file */
    (void)memset (&fcb.filename, ' ', 8);
    (void)memset (&fcb.filetype, ' ', 3);

#define FILENAME_LEN 8
    bdos_c_writestr ("filename: $");
    assert (FILENAME_LEN <= BUFFER_MAX);
    input->size = FILENAME_LEN;
    input->len  = 0;
    bdos_c_readstr (input);
    bdos_c_writestr ("\n\r$");
    string_to_upper ((uint8_t *)input->bytes, input->len);
    (void)memcpy (&fcb.filename, &input->bytes, input->len);

#define FILETYPE_LEN 3
    bdos_c_writestr ("filetype: $");
    assert (FILETYPE_LEN <= BUFFER_MAX);
    input->size = FILETYPE_LEN;
    input->len  = 0;
    bdos_c_readstr (input);
    bdos_c_writestr ("\n\r$");
    string_to_upper ((uint8_t *)input->bytes, input->len);
    (void)memcpy (&fcb.filetype, &input->bytes, input->len);

    /* log file name */
    memset (&buffer, '0', 15);
    buffer[0] = fcb.drive + 'A';
    buffer[1] = ':';
    memcpy (&buffer+2, &fcb.filename, FILENAME_LEN);
    buffer[10] = '.';
    memcpy (&buffer+11, &fcb.filetype, FILETYPE_LEN);
    buffer[14] = '$';
    /* D:NNNNNNNN.EEE$ */
    /* 0 D
     * 1 :
     * 2..10 N
     * 11 .
     * 12..15 E
     * 16 $ */
    hexdump (&buffer, 16);

    /* open file */
    rc = bdos_f_open (&fcb);
    if (rc == 0xff)
    {
        bdos_c_writestr ("failed to open file: $");
        bdos_c_writestr (buffer);
        bdos_c_writestr ("\r\n$");
        goto exit;
    }

    /* hex dump */
    hexdump (&fcb, sizeof (struct bdos_fcb));

    /* close file */
    rc = bdos_f_close (&fcb);
    if (rc == 0xff)
    {
        bdos_c_writestr ("failed to close file: $");
        bdos_c_writestr (buffer);
        bdos_c_writestr ("\r\n$");
        goto exit;
    }

    bdos_c_writestr ("success\n\r$");
exit:
    bdos_c_writestr ("exiting\n\r$");
    bdos_p_termcpm ();
}

void *
memcpy (void *dst, void *src, size_t n)
{
    uint8_t *pdst = dst;
    uint8_t *psrc = src;

    while (n-- != 0)
    {
        *pdst++ = *psrc++;
    }

    return dst;
}

void *
memset (void *dst, uint8_t byte, size_t n)
{
    uint8_t *pdst = dst;

    while (n-- != 0)
    {
        *pdst++ = byte;
    }

    return dst;
}

uint8_t
hex_char (uint8_t nibble)
{
    assert (nibble < 0x10);
    if (nibble <= 9)
    {
        return nibble + '0';
    }
    else
    {
        return nibble + 'A' - 9;
    }
}

void
hexdump (void *src, size_t n)
{
    uint8_t *psrc = src;
    uint8_t data = 0;
    uint8_t c = 0;
    uint8_t index = 0;

    while (n-- != 0)
    {
        data = *psrc++;
        bdos_c_write (hex_char ((data & 0xf0) >> 4));
        bdos_c_write (hex_char (data & 0x0f));
        bdos_c_write (' ');

        if (++index == 16)
        {
            bdos_c_write ('\n');
            bdos_c_write ('\r');
            index = 0;
        }
    }
    bdos_c_write ('\n');
    bdos_c_write ('\r');
}

void
string_to_upper (uint8_t *string, size_t n)
{
    uint8_t c = 0;

    while (n-- != 0)
    {
        c = *string;
        if ('a' <= c && c <= 'z')
        {
            *string = c & ~0x20;
        }
        string++;
    }
}

/* end of file */
