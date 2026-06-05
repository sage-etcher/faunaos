
#ifndef MATH_H
#define MATH_H

#include "types.h"

//struct uint8div_t {
//    uint8_t quot;
//    uint8_t rem;
//};

struct uint16div_t {
    uint16_t quot;
    uint16_t rem;
};

//struct uint8div_t *uint8div (uint8_t x, uint8_t y);
struct uint16div_t *uint16div (uint16_t x, uint16_t y);

#endif
/* end of file */
