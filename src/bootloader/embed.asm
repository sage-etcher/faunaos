    .module embed

    .globl ___sdcc_call_hl

    .area _CODE

___sdcc_call_hl:
    jp (hl)

    .area _CODE
;end of file
