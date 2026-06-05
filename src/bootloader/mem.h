
#ifndef MEM_H
#define MEM_H

#include "types.h"

#define ARRLEN(arr) (sizeof (arr) / sizeof (*(arr)))

uint8_t memcmp (uint8_t *x, uint8_t *y, size_t n);
uint8_t strcmp (char *x, char *y);

#endif
/* end of file */
