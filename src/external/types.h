
#ifndef FAUNAOS_EXTERNAL_TYPES_H
#define FAUNAOS_EXTERNAL_TYPES_H

typedef unsigned char   uint8_t;
typedef unsigned short  uint16_t;
typedef unsigned long   uint32_t;

typedef signed char     int8_t;
typedef signed short    int16_t;
typedef signed long     int32_t;

typedef uint16_t        size_t;
typedef uint16_t        uintptr_t;
typedef int16_t         ptrdiff_t;

#define UINT8_MAX   255
#define UINT16_MAX  65535
#define UINT32_MAX  4294967295

#define INT8_MAX    127
#define INT8_MIN    -128
#define INT16_MAX   32767
#define INT16_MIN   -32768
#define INT32_MAX   2147483647
#define INT32_MIN   -2147483648

#define UINTPTR_MAX UINT16_MAX
#define PTRDIFF_MAX INT16_MAX
#define PTRDIFF_MIN INT16_MIN

#define NULL (void *)0

#endif
/* end of file */
