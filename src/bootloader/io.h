
#ifndef IO_H
#define IO_H

#include "types.h"

/* stdio.h */
char getchar (void);
int8_t putchar (char ch);
int8_t puts (const char *str);

/* custom */
int8_t puts_raw (const char *str);
int8_t putbyte (uint8_t byte);
int8_t putword (uint16_t word);
size_t readline (char *buf, size_t n);

#endif
/* end of file */
