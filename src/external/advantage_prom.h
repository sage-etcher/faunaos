
#ifndef ADVANTAGE_PROM_H
#define ADVANTAGE_PROM_H

#define VID_CURSOR_LEFT     0x08
#define VID_CURSOR_DOWN     0x0A
#define VID_CURSOR_UP       0x0B
#define VID_CURSOR_RIGHT    0x0C
#define VID_CARRIAGE_RETURN 0x0D
#define VID_CLEAR_LINE      0x0E
#define VID_CLEAR_END       0x0F
#define VID_CURSOR_ON       0x18
#define VID_CURSOR_OFF      0x19
#define VID_NEWLINE         0x1F
#define VID_CURSOR_HOME     0x1E

#define VID_STD_CHARSET     0x8561

struct video_data {
    uint8_t curx;
    uint8_t cury;
    uint16_t pixel;
    uint8_t scrct;
    uint8_t stats;
    void (*retfp)(void);
    uint8_t *ctemp;
    uint8_t video;
};

#endif
/* end of file */
