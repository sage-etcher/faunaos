
#include "bios.h"

#include "advantage_prom.h"
#include "z80std.h"

uint8_t
getchar (void)
{
    uint8_t c = kb_get_keycode ();
    vid_write_c (c);

    return c;
}

void
puts (char *s)
{
    register char c;
    while ((c = *s++))
    {
        vid_write_c (c);
    }
    vid_write_c (PVID_NEWLINE);
}

void
main (void)
{
    /* clear screen */
    vid_write_c (PVID_HOME_CURSOR);
    vid_write_c (PVID_CLEAR_TO_EO_SCREEN);

    /* hellorld */
    puts ("Hellorld!");

    /* prompt for each cursor shape */
    vid_set_cursor_shape (VID_CURSOR_SHAPE_BLOCK);
    (void)getchar ();

    vid_set_cursor_shape (VID_CURSOR_SHAPE_HOLLOW);
    (void)getchar ();

    vid_set_cursor_shape (VID_CURSOR_SHAPE_LINE);
    (void)getchar ();

    vid_set_cursor_shape (VID_CURSOR_SHAPE_BAR);
    (void)getchar ();

    vid_write_c (PVID_NEWLINE);
    vid_write_c ('>');
    register uint8_t c;
    do {
        c = kb_get_keycode ();

        switch (c)
        {
        /* return */
        case 0x0d: vid_write_c (PVID_NEWLINE); break;

        /* backspace */
        case 0x7f: 
            vid_write_c (PVID_CURSOR_LEFT);
            vid_write_c (' ');
            vid_write_c (PVID_CURSOR_LEFT);
            break;

        /* numbers */
        case 0x31: vid_set_cursor_shape (VID_CURSOR_SHAPE_BLOCK);  break;
        case 0x32: vid_set_cursor_shape (VID_CURSOR_SHAPE_HOLLOW); break;
        case 0x33: vid_set_cursor_shape (VID_CURSOR_SHAPE_LINE);   break;
        case 0x34: vid_set_cursor_shape (VID_CURSOR_SHAPE_BAR);    break;

        /* arrows */
        case 0x84: vid_write_c (PVID_CURSOR_DOWN);  /* down+left */
        case 0x88: vid_write_c (PVID_CURSOR_LEFT);  /*      left */
            break;

        case 0x83: vid_write_c (PVID_CURSOR_RIGHT);  /* down+right */
        case 0x8a: vid_write_c (PVID_CURSOR_DOWN);   /* down */
            break;

        case 0x87: vid_write_c (PVID_CURSOR_LEFT);  /* up+left */
        case 0x82: vid_write_c (PVID_CURSOR_UP);    /* up */
            break;

        case 0x89: vid_write_c (PVID_CURSOR_UP);    /* up+right */
        case 0x86: vid_write_c (PVID_CURSOR_RIGHT); /*    right */
            break;

        /* everything else */
        default:
            vid_write_c (c);
        }
    } while (c != 'q');
    vid_write_c (PVID_NEWLINE);

    /* exit */
    puts ("done");
    while (1)
    {
        cpu_halt ();
    }
}

/* end of file */
