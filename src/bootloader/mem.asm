
    .module mem_h

    ; {{{
    .globl _memcmp
    .globl _strcmp
    ; }}}

    .area _DATA
    .area _INITIALIZED
    .area _DABS (ABS)

    .area _HOME
    .area _GSINIT
    .area _GSFINAL
    .area _GSINIT

    .area _HOME
    .area _HOME

    .area _CODE

;uint8_t memcmp (void *de_x, void *hl_y, size_t sp_n);
_memcmp:
    push hl             ;protect hl_y
    ld hl,#4            ;hl = &sp_n
    add hl,sp
    ld b,(hl)           ;bc = sp_n
    inc hl
    ld c,(hl)
    pop hl              ;restore hl_y
_memcmp_loop:
    ld a,b              ;if sp_n == 0: return 0
    or c
    jp z,_memcmp_ret
    ld a,(de)           ;acc = *de_x - *hl_y
    sub (hl)
    jp nz,_memcmp_ret   ;if acc != 0: return acc
    inc de              ;de_x++
    inc hl              ;hl_y++
    dec bc              ;sp_n--
    jp _memcmp_loop
_memcmp_ret:
    pop hl              ;hl = retptr
    inc sp              ;pop sp_n
    inc sp
    jp (hl)             ;ret


;uint8_t strcmp (char *de_x, char *hl_y);
_strcmp:
    ld b,(hl)   ;b = (hl_y)
    ld a,(de)   ;a, c = (de_x)
    ld c,a
    or b        ;if (c | b) == 0: return 0
    ret z
    ld a,c      ;if (c - b) != 0: return result
    sub b
    ret nz
    inc de      ;de_x++
    inc hl      ;hl_y++
    jp _strcmp  ;loop

    .area _CODE
    .area _INITIALIZED
    .area _CABS (ABS)
;end of file
