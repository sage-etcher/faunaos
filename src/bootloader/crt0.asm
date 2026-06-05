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
    call _blk_reset         ;add support for 3kb bootloader
    ld a,#0
    call _blk_set_drive
    ld a,#0
    call _blk_set_platter
    ld a,#0
    call _blk_set_cylinder
    ld a,#8                 ;PROM loads t0 4,5,6,7 we load 8,9
    call _blk_set_sector    ;           t1 0..10
    ld a,#12
    ld de,#0xc800           ;0xc800..0xcc00
    call _blk_read
    ld a,#0                 ;argc
    ld de,#0                ;argv
    call _main              ;(void)main (0, NULL)
_exit:
    halt
    jp _exit


	.area _CODE
