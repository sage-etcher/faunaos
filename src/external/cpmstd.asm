    .module cpmstd

;------------------------------------------------------------------------
; public variables
;------------------------------------------------------------------------
    .globl _bdos_a_read
    .globl _bdos_a_write
    .globl _bdos_c_rawio
    .globl _bdos_c_read
    .globl _bdos_c_readstr
    .globl _bdos_c_stat
    .globl _bdos_c_write
    .globl _bdos_c_writestr
    .globl _bdos_drv_allocvec
    .globl _bdos_drv_dpb
    .globl _bdos_drv_get
    .globl _bdos_drv_loginvec
    .globl _bdos_drv_reset
    .globl _bdos_drv_rovec
    .globl _bdos_drv_set
    .globl _bdos_drv_setro
    .globl _bdos_f_attrib
    .globl _bdos_f_close
    .globl _bdos_f_delete
    .globl _bdos_f_dmaoff
    .globl _bdos_f_make
    .globl _bdos_f_open
    .globl _bdos_f_randrec
    .globl _bdos_f_read
    .globl _bdos_f_readrand
    .globl _bdos_f_rename
    .globl _bdos_f_sfirst
    .globl _bdos_f_size
    .globl _bdos_f_snext
    .globl _bdos_f_usernum
    .globl _bdos_f_write
    .globl _bdos_f_writerand
    .globl _bdos_f_writezf
    .globl _bdos_get_io
    .globl _bdos_l_write
    .globl _bdos_p_termcpm
    .globl _bdos_s_ver
    .globl _bdos_set_io

;------------------------------------------------------------------------
; code
;------------------------------------------------------------------------
    .area _CODE

_bdos_p_termcpm:
	ld c,#0
	call #0x0005
	ret

_bdos_c_read:
	ld c,#1
	call #0x0005
	ret

_bdos_c_write:
    ld e,a
	ld c,#2
	call #0x0005
	ret

_bdos_a_read:
	ld c,#3
	call #0x0005
	ret

_bdos_a_write:
    ld e,a
	ld c,#4
	call #0x0005
	ret

_bdos_l_write:
    ld e,a
	ld c,#5
	call #0x0005
	ret

_bdos_c_rawio:
    ld e,a
	ld c,#6
	call #0x0005
	ret

_bdos_get_io:
	ld c,#7
	call #0x0005
	ret

_bdos_set_io:
    ld e,a
	ld c,#8
	call #0x0005
	ret

_bdos_c_writestr:
    ex de,hl
	ld c,#9
	call #0x0005
	ret

_bdos_c_readstr:
    ex de,hl
	ld c,#10
	call #0x0005
	ret

_bdos_c_stat:
	ld c,#11
	call #0x0005
	ret

_bdos_s_ver:
    ld c,#12
    call #0x0005
	ret

_bdos_drv_allreset:
	ld c,#13
	call #0x0005
	ret

_bdos_drv_set:
    ld e,a
	ld c,#14
	call #0x0005
	ret

_bdos_f_open:
    ex de,hl
	ld c,#15
	call #0x0005
	ret

_bdos_f_close:
    ex de,hl
	ld c,#16
	call #0x0005
	ret

_bdos_f_sfirst:
    ex de,hl
	ld c,#17
	call #0x0005
	ret

_bdos_f_snext:
    ex de,hl
	ld c,#18
	call #0x0005
	ret

_bdos_f_delete:
    ex de,hl
	ld c,#19
	call #0x0005
	ret

_bdos_f_read:
    ex de,hl
	ld c,#20
	call #0x0005
	ret

_bdos_f_write:
    ex de,hl
	ld c,#21
	call #0x0005
	ret

_bdos_f_make:
    ex de,hl
	ld c,#22
	call #0x0005
	ret

_bdos_f_rename:
    ex de,hl
	ld c,#23
	call #0x0005
	ret

_bdos_drv_loginvec:
	ld c,#24
	call #0x0005
	ret

_bdos_drv_get:
	ld c,#25
	call #0x0005
	ret

_bdos_f_dmaoff:
    ex de,hl
	ld c,#26
	call #0x0005
	ret

_bdos_drv_allocvec:
	ld c,#27
	call #0x0005
	ret

_bdos_drv_setro:
	ld c,#28
	call #0x0005
	ret

_bdos_drv_rovec:
	ld c,#29
	call #0x0005
	ret

_bdos_f_attrib:
    ex de,hl
	ld c,#30
	call #0x0005
	ret

_bdos_drv_dpb:
	ld c,#31
	call #0x0005
	ret

_bdos_f_usernum:
    ld e,a
	ld c,#32
	call #0x0005
	ret

_bdos_f_readrand:
    ex de,hl
	ld c,#33
	call #0x0005
	ret

_bdos_f_writerand:
    ex de,hl
	ld c,#34
	call #0x0005
	ret

_bdos_f_size:
    ex de,hl
	ld c,#35
	call #0x0005
	ret

_bdos_f_randrec:
    ex de,hl
	ld c,#36
	call #0x0005
	ret

_bdos_drv_reset:
    ex de,hl
	ld c,#37
	call #0x0005
	ret

_bdos_f_writezf:
    ex de,hl
	ld c,#40
	call #0x0005
	ret

    .area _CODE
