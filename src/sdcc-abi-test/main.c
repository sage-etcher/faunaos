
typedef unsigned char  u8_t;
typedef unsigned short u16_t;
typedef u16_t          size_t;

void putbyte (u8_t byte);
void putword (u16_t word);

void fn1b (u8_t b1);                            /*  a                   */
void fn2b (u8_t b1, u8_t b2);                   /*  a    l              */
void fn3b (u8_t b1, u8_t b2, u8_t b3);          /*  a    l   sp-1       */
void fn1w (u16_t w1);                           /* hl                   */
void fn2w (u16_t w1, u16_t w2);                 /* hl   de              */
void fn3w (u16_t w1, u16_t w2, u16_t w3);       /* hl   de   sp-2       */
void fn1b1w (u8_t  b1, u16_t w1);               /*  a   de              */
void fn2b1w (u8_t  b1, u8_t  b2, u16_t w1);     /*  a    l   sp-2       */
void fn1w1b (u16_t w1, u8_t  b1);               /* hl   sp-1            */
void fn2w1b (u16_t w1, u16_t w2, u8_t  b1);     /* hl   de   sp-1       */
void fn1p (void *p1);                           /* hl                   */

u8_t fnrb (void);                               /*  a                   */
u16_t fnrw (void);                              /*  de                  */
void *fnrp (void);                              /*  de                  */

u8_t *callee_saves_memcopy (u8_t *dst, u8_t *src, size_t n);

int
main (void)
{
    volatile u8_t b;
    volatile u16_t w;
    volatile void *p = (void *)0x0101;

    fn1b (0x01);
    fn2b (0x01, 0x02);
    fn3b (0x01, 0x02, 0x03);
    fn1w (0x0101);
    fn2w (0x0101, 0x0202);
    fn3w (0x0101, 0x0202, 0x0303);
    fn1b1w (0x01, 0x0202);
    fn2b1w (0x01, 0x02, 0x0303);
    fn1w1b (0x0101, 0x02);
    fn2w1b (0x0101, 0x0202, 0x03);
    fn1p (p);

    callee_saves_memcopy ((void *)&w, (void *)&b, 1);
    b = fnrb ();
    putbyte (b);

    w = fnrw ();
    putword (w);

    p = fnrp ();
    putword ((u16_t)p);

    return 0;
}

void fn1b (u8_t b1)                         { (void)b1; }
void fn2b (u8_t b1, u8_t b2)                { (void)b1; (void)b2; }
void fn3b (u8_t b1, u8_t b2, u8_t b3)       { (void)b1; (void)b2; (void)b3; }
void fn1w (u16_t w1)                        { (void)w1; }
void fn2w (u16_t w1, u16_t w2)              { (void)w1; (void)w2; }
void fn3w (u16_t w1, u16_t w2, u16_t w3)    { (void)w1; (void)w2; (void)w3; }
void fn1b1w (u8_t  b1, u16_t w1)            { (void)b1; (void)w1; }
void fn2b1w (u8_t  b1, u8_t  b2, u16_t w1)  { (void)b1; (void)b2; (void)w1; }
void fn1w1b (u16_t w1, u8_t  b1)            { (void)w1; (void)b1; }
void fn2w1b (u16_t w1, u16_t w2, u8_t  b1)  { (void)w1; (void)w2; (void)b1; }
//void fn1bu (union byte_union bu1)           { (void)bu1; }
//void fn1wu (union word_union wu1)           { (void)wu1; }
//void fn1bs (struct byte_struct bs1)         { (void)bs1; }
//void fn1ws (struct word_struct ws1)         { (void)ws1; }
void fn1p (void *p1)                        { (void)p1; }

u8_t fnrb (void)                { return 0xff; }
u16_t fnrw (void)               { return 0xffff; }
//union byte_union fnrbu (void)   { return (union  byte_union){ .b1 = 0xff }; }
//union word_union fnrwu (void)   { return (union  word_union){ .w1 = 0xffff }; }
//struct byte_struct fnrbs (void) { return (struct byte_union){ .b1 = 0xff }; }
//struct word_struct fnrws (void) { return (struct word_union){ .b1 = 0xf1, .b2 = 0xf2 }; }
void *fnrp (void)               { return (void *)0xffff; }

void putbyte (u8_t byte)  { (void)byte; }
void putword (u16_t word) { (void)word; }

u8_t *
callee_saves_memcopy (u8_t *dst, u8_t *src, size_t n)
{
    register u8_t *iter = dst;
    register u8_t c;

    while (n-- > 0)
    {
        c = *src;
        *iter = c;

        src++;
        iter++;
    }

    return dst;

}

/* end of file */
