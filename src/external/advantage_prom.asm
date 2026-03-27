    .module advantage_prom

;------------------------------------------------------------------------
; public variables
;------------------------------------------------------------------------
    .globl _pvid_putchar

;------------------------------------------------------------------------
; code
;------------------------------------------------------------------------
    .area _CODE

; A: char c
;DE: struct pvid_data *vdata
;_pvid_putchar:
;    ld ix,de        ;ix = vdata
;    pop de          ;de = return_addr
;    ld +6 (ix),e    ;vdata->retfp = return_addr
;    ld +7 (ix),d
;    jp #0x87FD      ;call pvid_putchar


; A: char c
;DE: struct pvid_data *vdata
_pvid_putchar:
    ld ix,#0        ;ix = vdata
    add ix,de
    pop de          ;de = return_address
    ld +6 (ix),e    ;vdata->retfp = return_addres
    ld +7 (ix),d
    ld hl,#0x87FD   ;call pvid_putchar (idk why sdcc doesnt like direct jp)
    jp (hl)

    .area _CODE
