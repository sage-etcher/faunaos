    .module advantage_prom

;------------------------------------------------------------------------
; public variables
;------------------------------------------------------------------------
    .globl _pvid_putchar

;------------------------------------------------------------------------
; code
;------------------------------------------------------------------------
    .area _CODE

;modifies BC, HL
; A: char c
;DE: struct pvid_data *vdata
_pvid_putchar:
    push ix                     ;protect SDCC frame pointer
    call _pvid_putchar_core     ;modifies IX
    pop ix                      ;restore IX
    ret

;modifies BC, HL, IX
; A: char c
;DE: struct pvid_data *vdata
_pvid_putchar_core:
    ld ix,#0        ;ix = vdata
    add ix,de
    pop de          ;de = return_address
    ld +6 (ix),e    ;vdata->retfp = return_addres
    ld +7 (ix),d
    ld hl,#0x87FD   ;call pvid_putchar (idk why sdcc doesnt like direct jp)
    jp (hl)

    .area _CODE
