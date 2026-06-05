
    .module math

    .globl _uint16div

    .area _CODE

_uint16div_result: .ds 4

;struct uint16div_t *uint16div (hl_x, de_y);
_uint16div:
    ld a,h                  ;ac_x = hl_x
    ld c,l
    call _uint16div_int     ;ac_x divmod de_y = hl_rem, ac_quot
    ex de,hl                ;de_rem
    ld hl,#_uint16div_result+3  ;c a e d
    ld (hl),d
    dec hl
    ld (hl),e
    dec hl
    ld (hl),a
    dec hl
    ld (hl),c
    ex de,hl
    ret

;www.smspower.org/Development/DivMod#Unsigned16161616Bit
;integer divides A:C by DE
;result in A:C, remainder in HL
;clobbers F,B
_uint16div_int:
    ld hl,#0x0000
    ld b,#16
_u16div_sub:
    sla c
    set 0,c
    rla
    adc hl,hl
    sbc hl,de
    jr nc,_u16div_no_add
    add hl,de
    dec c
_u16div_no_add:
    djnz _u16div_sub
    ret

    .area _CODE
;end of file
