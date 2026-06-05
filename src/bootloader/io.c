#include "io.h"

#include "advantage_prom.h"
#include "bios.h"
#include "math.h"
#include "types.h"
#include "z80std.h"

static char xtoc (uint8_t x);

char
getchar (void)
{
    char ch = kb_get_keycode ();
    vid_write_c (ch);
    return ch;
}

int8_t
putchar (char ch)
{
    vid_write_c (ch);
    return 0;
}

int8_t
puts_raw (char *str)
{
    register char ch;
    while ((ch = *str++))
    {
        vid_write_c (ch);
    }
    return 0;
}

int8_t
puts (char *str)
{
    (void)puts_raw (str);
    vid_write_c (PVID_NEWLINE);
    return 0;
}

int8_t
crlf (void)
{
    vid_write_c (PVID_NEWLINE);
    return 0;
}

static char
xtoc (uint8_t x)
{
    x &= 0x0f;
    if (x >= 0x0a)
    {
        return x + 'a' - 10;
    }
    return x + '0';
}

int8_t
putbyte (uint8_t byte)
{
    vid_write_c (xtoc (byte >>  4));
    vid_write_c (xtoc (byte >>  0));
    vid_write_c (' ');
    return 0;
}

int8_t
putword (uint16_t word)
{
    vid_write_c (xtoc (word >> 12));
    vid_write_c (xtoc (word >>  8));
    vid_write_c (xtoc (word >>  4));
    vid_write_c (xtoc (word >>  0));
    vid_write_c (' ');
    return 0;
}

int8_t
putu (uint16_t word)
{
    enum { BUF_MAX = 5 }; // max value "65535"
    char buf[BUF_MAX+1] = "    0";
    char *iter = buf + BUF_MAX;
    int8_t i = BUF_MAX;

    for (; i >= 0 && word > 0; i--)
    {
        struct uint16div_t *s = uint16div (word, 10);
        *--iter = (uint8_t)s->rem + '0';
        word = s->quot;
    }

    puts_raw (iter);
    putchar (' ');

    return 0;
}

size_t
readline (char *buf, size_t max)
{
    const char PLACEHOLDER = '.';
    char ch;
    size_t len = 0;
    uint16_t pos = 0;

    uint16_t homepos;
    uint16_t endpos;

    vid_write_c_raw (PLACEHOLDER, max);

    homepos = vid_get_cursor_position ();
    endpos = homepos;

    for (;;)
    {
        /* get key */
        ch = kb_get_keycode ();

        /* handle control special keys */
        switch (ch)
        {
        /* ----------------------------------------------------------- */
        case 0x0d: /* enter handler */
            vid_write_c (PVID_LINE_FEED);
            vid_write_c (PVID_CARRIAGE_RETURN);
            return len;

        case 0x7f: /* backspace handler */
            if (pos > 0) 
            {
                vid_write_c (PVID_CURSOR_LEFT);
                pos--;
            }

            vid_write_c_raw (PLACEHOLDER, (len - pos));
            endpos = vid_get_cursor_position ();
            len = pos;
            break;

        /* ----------------------------------------------------------- */
        case 0x88:  /*      left */
            if (pos == 0) { continue; }

            vid_write_c (PVID_CURSOR_LEFT);
            pos--;
            continue;

        case 0x8a:  /* down */
            vid_set_cursor_position (homepos);
            pos = 0;
            continue;

        case 0x82:  /* up */
            vid_set_cursor_position (endpos);
            pos = len;
            continue;

        case 0x86:  /*    right */
            if (pos == len) { continue; }

            vid_write_c (PVID_CURSOR_RIGHT);
            pos++;
            continue;

        /* ----------------------------------------------------------- */
        default:
            /* echo characters only when it can be added to the buffer */
            if (pos == max) { break; }

            vid_write_c (ch);

            pos++;
            if (pos < len)
            {
                vid_write_c_raw (PLACEHOLDER, (len - pos));
            }
            endpos = vid_get_cursor_position ();
            len = pos;

            if (buf == NULL) { break; }
            buf[pos] = ch;
            break;
        }
    }
}

/* end of file */
