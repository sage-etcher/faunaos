
#ifndef ADVANTAGE_PROM_H
#define ADVANTAGE_PROM_H

#include "types.h"



#define PVID_BACKSPACE          0x08    /* CTRL-H */
#define PVID_LINE_FEED          0x0A    /* CTRL-J */
#define PVID_REVERSE_LINE_FEED  0x0B    /* CTRL-K */
#define PVID_FORESPACE          0x0C    /* CTRL-L */
#define PVID_CARRIAGE_RETURN    0x0D    /* CTRL-M */
#define PVID_CLEAR_TO_EO_LINE   0x0E    /* CTRL-N */
#define PVID_CLEAR_TO_EO_SCREEN 0x0F    /* CTRL-O */
#define PVID_CURSOR_ON          0x18    /* CTRL-X */
#define PVID_CURSOR_OFF         0x19    /* CTRL-Y */
#define PVID_NEWLINE            0x1F    /* CTRL-_ */
#define PVID_HOME_CURSOR        0x1E    /* CTRL-^ */
#define PVID_CURSOR_LEFT        PVID_PACKSPACE
#define PVID_CURSOR_DOWN        PVID_LINE_FEED
#define PVID_CURSOR_UP          PVID_REVERSE_LINE_FEED
#define PVID_CURSOR_RIGHT       PVID_FORESPACE

#define PVID_STD_CHARSET    (void *)0x8561

#define PVID_STAT_CURSOR    0x01    /* ro* cursor is disabled */
#define PVID_STAT_AUTOWRAP  0x02    /* rw  disable autowrap */
#define PVID_STAT_SCROLL    0x04    /* rw  disable scrolling */
#define PVID_STAT_TOP       0x40    /* ro* cursor at top of screen */
#define PVID_STAT_BOTTOM    0x80    /* ro* cursor at bottom of screen */

#define PVID_NORMAL     0x00
#define PVID_REVERSE    0xff

typedef uint8_t pvid_cursor_t[10];

#define PVID_CURSOR_DEFAULT { 0xff, 0xff, 0xff, 0xff, 0xff, \
                              0xff, 0xff, 0xff, 0xff, 0xff }

struct pvid_data {
    uint8_t curx;           /* cursor X pos 00-4FH */
    uint8_t cury;           /* cursor Y pos 00-FFH */
    void *pixel;            /* character set/font */
    uint8_t scrct;          /* line number */
    uint8_t stats;          /* status flags */
    void (*retfp)(void);    /* return address */
    uint8_t *ctemp;         /* cursor template (&pvid_cursor_t) */
    uint8_t video;          /* 00 normal, FF reverse video */
};

void pvid_putchar (char c, struct pvid_data *ctx);

#endif
/* end of file */
