
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
main (void)
{
    /* clear screen */
    vid_write_c (PVID_HOME_CURSOR);
    vid_write_c (PVID_CLEAR_TO_EO_SCREEN);

    /* setup drives */
    blk_reset ();                       /* unset drive */
    putbyte (blk_set_platter  (0));     /* 01 01 */
    putbyte (blk_set_cylinder (0));     /* 01 01 */
    putbyte (blk_set_sector   (4));     /* 01 01 */
    vid_write_c (PVID_NEWLINE);

    blk_reset ();                       /* valid, minimum values */
    putbyte (blk_set_drive    (0));     /* 00 00 */
    putbyte (blk_set_platter  (0));     /* 00 00 */
    putbyte (blk_set_cylinder (0));     /* 00 00 */
    putbyte (blk_set_sector   (0));     /* 00 00 */
    vid_write_c (PVID_NEWLINE);

    blk_reset ();                       /* valid, maximum values */
    putbyte (blk_set_drive    (1));     /* 00 00 */
    putbyte (blk_set_platter  (1));     /* 00 00 */
    putbyte (blk_set_cylinder (34));    /* 00 00 */
    putbyte (blk_set_sector   (9));     /* 00 00 */
    vid_write_c (PVID_NEWLINE);

    blk_reset ();                       /* drive out of range */
    putbyte (blk_set_drive    (2));     /* 02 02 */
    putbyte (blk_set_platter  (1));     /* 01 01 */
    putbyte (blk_set_cylinder (34));    /* 01 01 */
    putbyte (blk_set_sector   (9));     /* 01 01 */
    vid_write_c (PVID_NEWLINE);

    blk_reset ();                       /* valid drive, invalid everything */
    putbyte (blk_set_drive    (1));     /* 00 00 */
    putbyte (blk_set_platter  (2));     /* 02 02 */
    putbyte (blk_set_cylinder (35));    /* 02 02 */
    putbyte (blk_set_sector   (10));    /* 02 02 */
    vid_write_c (PVID_NEWLINE);

    /* hellorld */
    puts ("Hellorld!");

    /* prompt for each cursor shape */
    //vid_set_cursor_position (VID_POS_SET_XY (10, 10));
    //vid_write_c_raw ('$', 10);
    //vid_set_cursor_shape (VID_CURSOR_SHAPE_BLOCK);
    //(void)getchar ();

    //vid_set_cursor_shape (VID_CURSOR_SHAPE_HOLLOW);
    //(void)getchar ();

    //vid_set_cursor_shape (VID_CURSOR_SHAPE_LINE);
    //(void)getchar ();

    //vid_set_cursor_shape (VID_CURSOR_SHAPE_BAR);
    //(void)getchar ();

    /* prompt for control codes */
    vid_set_cursor_position (VID_POS_SET_XY (10, 20));
    vid_write_c ('>');

    uint16_t pos = vid_get_cursor_position ();
    vid_write_c (xtoc (pos >> 12)); /* n */
    vid_write_c (xtoc (pos >>  8)); /* o */
    vid_write_c (xtoc (pos >>  4)); /* 0 */
    vid_write_c (xtoc (pos >>  0)); /* l */
    register uint8_t c;

    vid_set_cursor_position (pos);
    vid_write_c ('#');

    do {
        c = kb_get_keycode ();

        switch (c)
        {
        case 'h': vid_set_cursor_position (pos); break;

        /* return */
        case 0x0d: vid_write_c (PVID_NEWLINE); break;

        /* backspace */
        case 0x7f: 
            vid_write_c (PVID_CURSOR_LEFT);
            vid_write_c_raw (' ', 1);
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
            break;
        }
    } while (c != 'q');
    vid_write_c (PVID_NEWLINE);

    /* exit */
    puts ("done");
exit:
    while (1)
    {
        cpu_halt ();
    }
}

/* end of file */
