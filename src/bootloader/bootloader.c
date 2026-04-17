
#include "bios.h"

#include "advantage.h"
#include "advantage_prom.h"
#include "z80std.h"

uint8_t getchar (void);
void puts_line (char *s);
void puts (char *s);
char xtoc (uint8_t x);
void putbyte (uint8_t byte);
void putword (uint16_t word);
int readline (char *buf, uint16_t n);

void
main (void)
{
    /* clear screen */
    adv_crt_scan = 0x00;
    vid_write_c (PVID_HOME_CURSOR);
    vid_write_c (PVID_CLEAR_TO_EO_SCREEN);

    /* hellorld */
    puts ("Hellorld!\r");

    /* read from disk */
    puts ("reading from disk...");
    blk_reset ();
    putbyte (blk_set_drive    (0));
    putbyte (blk_set_platter  (0));
    putbyte (blk_set_cylinder (0));
    putbyte (blk_set_sector   (4));
    //putbyte (blk_read (0, (uint8_t *)0xd000));
    vid_write_c (PVID_LINE_FEED);
    vid_write_c (PVID_CARRIAGE_RETURN);

    putword (vid_get_cursor_position ()); /* base hellorld line */
    vid_write_c_raw ('.', 20);
    puts_line ("Hello world!");
    putword (vid_get_cursor_position ()); /* post hellorld */

    uint16_t pos1 = vid_get_cursor_position (); /* pos 1 */
    vid_set_cursor_position (pos1);
    uint16_t pos2 = vid_get_cursor_position (); /* pos 2 */
    vid_set_cursor_position (VID_POS_SET_XY (0,10));
    putword (pos1);
    putword (pos2);


    /* prompt for input */
    vid_write_c ('#');
    putbyte (readline (NULL, 15));
    vid_write_c (PVID_LINE_FEED);
    vid_write_c (PVID_CARRIAGE_RETURN);

    /* exit */
    puts ("exiting");
    while (1)
    {
        cpu_halt ();
    }
}

uint8_t
getchar (void)
{
    uint8_t c = kb_get_keycode ();
    vid_write_c (c);

    return c;
}

void
puts_line (char *s)
{
    register char c;
    while ((c = *s++))
    {
        vid_write_c (c);
    }
}

void
puts (char *s)
{
    puts_line (s);
    vid_write_c (PVID_LINE_FEED);
    vid_write_c (PVID_CARRIAGE_RETURN);
}

char
xtoc (uint8_t x)
{
    x &= 0x0f;
    if (x >= 0x0a)
    {
        return x + 'a' - 10;
    }
    return x + '0';
}

void
putbyte (uint8_t byte)
{
    vid_write_c (xtoc (byte >>  4));
    vid_write_c (xtoc (byte >>  0));
    vid_write_c (' ');
}

void
putword (uint16_t word)
{
    vid_write_c (xtoc (word >> 12));
    vid_write_c (xtoc (word >>  8));
    vid_write_c (xtoc (word >>  4));
    vid_write_c (xtoc (word >>  0));
    vid_write_c (' ');
}

int
readline (char *buf, uint16_t max)
{
    const char PLACEHOLDER = '.';
    uint8_t c;
    uint16_t len = 0;
    uint16_t pos = 0;

    uint16_t homepos;
    uint16_t endpos;

    vid_write_c_raw (PLACEHOLDER, max);

    homepos = vid_get_cursor_position ();
    endpos = homepos;

    for (;;)
    {
        /* get key */
        c = kb_get_keycode ();

        /* handle control special keys */
        switch (c)
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

            vid_write_c (c);

            pos++;
            if (pos < len)
            {
                vid_write_c_raw (PLACEHOLDER, (len - pos));
            }
            endpos = vid_get_cursor_position ();
            len = pos;

            if (buf == NULL) { break; }
            buf[pos] = c;
            break;
        }
    }
}

/* end of file */
