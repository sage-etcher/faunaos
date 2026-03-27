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
    call _main
_exit:
    halt
    jp _exit

	.area _CODE
