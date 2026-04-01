	.module crt0
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
    .globl __entry0
    .globl _exit

;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE

__entry0:
    ld sp,#0xffff
    ld a,#0     ;argc
    ld hl,#0    ;argv
    call _main  ;(void)main (0,0)
_exit:
    halt
    jp _exit

	.area _CODE
