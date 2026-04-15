
    .module faunaos_bios

    .globl _vid_set_cursor_shape
    .globl _vid_set_cursor_position
    .globl _vid_get_cursor_position
    .globl _vid_write_c_raw
    .globl _vid_write_c

    .globl _kb_get_status
    .globl _kb_get_keycode

    .globl _blk_reset
    .globl _blk_set_drive
    .globl _blk_set_platter
    .globl _blk_set_cylinder
    .globl _blk_set_sector
    .globl _blk_set_write_protect
    .globl _blk_unset_write_protect
    .globl _blk_get_write_protect
    .globl _blk_read
    .globl _blk_write

_adv_io_ctrl  = 0xf0
_adv_io_stat1 = 0xe0
_adv_io_stat2 = 0xd0

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

_prom_video_context:    ;11 bytes
    .db 0x00                ; 0 curx 0
    .db 0x00                ; 1 cury 0
    .dw 0x8561              ; 2 default character set
    .db 0x00                ; 4 scrct line 0
    .db 0x00                ; 5 stats enable scroll and autowrap
    .dw 0x0000              ; 6 retfp none
    .dw _cursor_shape_block ; 8 cursor template
    .db 0x00                ;10 video normal

;static void send_io_ctrl(uint8_t io_ctrl_value);
_send_io_ctrl:
    push bc                 ;callee saves
    ld b,a                  ;protect io_ctrl_value in b
    in a,(#_adv_io_stat1)   ;get initial cmd_ack state
    ld c,a                  ;protect previous state in c
    ld a,b                  ;output io_ctrl_value
    out (#_adv_io_ctrl),a
_send_io_ctrl_wait_cmd_ack:
    in a,(#_adv_io_stat1)   ;get cmd_ack state
    xor a,c                 ;loop until cmd_ack compliments
    jp m,_send_io_ctrl_wait_cmd_ack
    pop bc
    ret

;static uint8_t a_mult_10 (uint8_t a);
;max a = 25
;error if CY
_a_mult_10:
    push de
    rlca                            ;d = a << 1 (A = AL * 10)
    ld d,a
    rlca                            ;a = a << 3
    rlca
    add a,d                         ;a = a | d
    pop de
    ret

;static uint16_t a_mult_l (uint8_t a, uint8_t l);
_a_mult_l:
    push bc
    push de
    ld d,#0
    ld e,l
    ld h,a
    ld l,d
    ld c,#8
_a_mult_l_loop:
    add hl,hl
    jp nc,_a_mult_l_noadd
    add hl,de
_a_mult_l_noadd:
    dec c
    jp nz,_a_mult_l_loop
    pop de
    pop bc
    ret

;typedef union {
;    uint16_t hl_ret;
;    struct { uint8_t h_quotient, l_remainder; };
;} divmod8_t;

;divmod8_t a_divmod_l (uint8_t divident, uint8_t divisor);
_a_divmod_l:
    push bc
    ld h,a                  ;H divident
    ld c,#9                 ;counter = 9
    xor a,a                 ;remainder = 0
_a_divmod_l_loop:
    ld b,a                  ;remainder = a
    ld a,h                  ;divident <<= 1
    rla
    ld h,a
    dec c                   ;counter--
    jp z,_a_divmod_l_exit   ;if (counter == 0) goto exit
    ld a,b                  ;remainder <<= 1
    rla
    sub a,l                 ;remainder -= divisor
    jp nc,_a_divmod_l_loop  ;loop
    add a,l                 ;remainder += divisor (and set CY)
    jp _a_divmod_l_loop
_a_divmod_l_exit:
    ld a,h                  ;~divident
    cpl
    ld h,a                  ;h = quotient
    ld l,b                  ;l = remainder
    pop bc
    ret

;uint8_t a_div (uint8_t divident, uint8_t divisor);
_a_div:
    push hl
    call _a_divmod_l    ;a_divmod_l (divident, divisor)
    ld a,h              ;a = quotient
    pop hl
    ret

;uint8_t a_mod (uint8_t divident, uint8_t divisor);
_a_mod:
    push hl
    call _a_divmod_l    ;a_divmod_l (divident, divisor)
    ld a,l              ;a = remainder 
    pop hl
    ret

;void vid_set_cursor_shape (uint8_t shape);
_vid_set_cursor_shape:
    push de
    push hl
    push af
    ld a,#0x19                      ;cursor off
    call _vid_write_c
    pop af
    and a,#0x03                     ;VID_CURSOR_SHAPE_MASK
    call _a_mult_10                 ;a = shape * 10
    ld e,a                          ;offset = (uint16_t)a
    ld d,#0x00
    ld hl,#_cursor_shape_list        ;p_cursor = cursor_shape_list + offset
    add hl,de
    ex de,hl                        ;de = p_cursor
    ld hl,#_prom_video_context+8     ;hl = &prom_video_context.ctemp
    ld (hl),e                       ;*ctemp = p_cursor
    inc hl
    ld (hl),d
    ld a,#0x18                      ;cursor on
    call _vid_write_c
    pop de
    pop hl
    ret

_cursor_shape_list:
_cursor_shape_block:    .dw 0xffff, 0xffff, 0xffff, 0xffff, 0xffff  ;block
_cursor_shape_hollow:   .dw 0x81ff, 0x8181, 0x8181, 0x8181, 0xff81  ;hollow
_cursor_shape_line:     .dw 0x0000, 0x0000, 0x0000, 0x0000, 0xff00  ;line
_cursor_shape_bar:      .dw 0x8080, 0x8080, 0x8080, 0x8080, 0x8080  ;bar

;void vid_set_cursor_position (uint16_t xy_position);
;register l uint8_t x_pos
;register h uint8_t y_pos
_vid_set_cursor_position:
    push de
    ld a,#0x19                  ;cursor off
    call _vid_write_c
    ld de,#_prom_video_context  ;de = &prom_video_context.x
    ld a,l                      ;prom_video_context.x = x_pos
    ld (de),a
    inc de                      ;de = &prom_video_context.y
    ld a,h                      ;a = y_pos * 10
    call _a_mult_10
    ld (de),a                   ;prom_video_context.y = a
    ld a,#0x18                  ;cursor on
    call _vid_write_c
    pop de
    ret

_vid_get_cursor_position:
    push de
    ld de,#_prom_video_context+1    ;de = &prom_video_context.y
    ld a,(de)                       ;y_pox(h) = prom_video_context.y / 10
    ld l,#10
    call _a_div
    ld h,a
    dec de                          ;de = &prom_video_context.x
    ld a,(de)                       ;x_pos(l) = prom_video_context.x
    ld l,a
    pop de
    ret

;void vid_write_c (uint8_t character, uint8_t count);
_vid_write_c_raw:
    push bc
    push de
    ld b,a                          ;b = character
    ld a,#0x19                      ;cursor off
    call _vid_write_c
    ld de,(#_prom_video_context)    ;protect initial xy_position
    jp _vid_write_c_raw_check       ;while (count != 0) {
_vid_write_c_raw_loop:
    ld a,b                          ;a = character
    call _vid_write_c               ;putchar (character)
    dec l                           ;count--
_vid_write_c_raw_check:
    ld a,l                          ;test count
    or a,a
    jp nz,_vid_write_c_raw_loop     ;} // while (count != 0)
    ld (#_prom_video_context),de    ;restore xy_position
    ld a,#0x18                      ;cursor on
    call _vid_write_c
    pop de
    pop bc
    ret

;void vid_write_c (uint8_t character);
_vid_write_c:
    push bc                     ;callee saves
    push de
    push hl
    push ix
    push iy
    ld e,a                      ;protect character
    ld a,#0x80                  ;mmu setup  page0=vram0
    out (#0xa0),a
    ld a,#0x81                  ;           page1=vram1
    out (#0xa1),a
    ld a,#0x84                  ;           page2=prom
    out (#0xa2),a
    ld a,e                      ;restore character
    ld de,#_prom_video_context  ;prom putchar
    call _pvid_putchar
    ld a,#0x00                  ;mmu cleanup page0=ram0
    out (#0xa0),a
    ld a,#0x01                  ;            page1=ram1
    out (#0xa1),a
    ld a,#0x02                  ;            page2=ram2
    out (#0xa2),a
    pop iy
    pop ix
    pop hl
    pop de
    pop bc
    ret

_kb_enable_mi:
    ld a,#0x9b              ;enable display int | io reset | toggle keyboard mi
    call _send_io_ctrl
    in a,(#_adv_io_stat2)   ;check result of toggle
    and a,#0x01
    jp nz,_kb_enable_mi     ;toggle again if it is disabled
    ret

_kb_get_status:
    call _kb_enable_mi      ;enable keyboard maskable interupt
    in a,(#_adv_io_stat2)   ;get status
    and a,#0x40             ;isolate keyboard data flag
    ret                     ;a = 0 when no data is present, not 0 otherwise

_kb_get_keycode:
    call _kb_get_status     ;get status
    jp z,_kb_get_keycode    ;loop until keypress is available
    push bc
    ld a,#0x99              ;get low nibble from character
    call _send_io_ctrl
    in a,(#_adv_io_stat2)
    and a,#0x0f
    ld b,a                  ;store unfinished character in c
    ld a,#0x9a              ;get high nibble from character
    call _send_io_ctrl
    in a,(#_adv_io_stat2)
    and a,#0x0f
    rlca                    ;shift high nibble into upper 4 bits
    rlca
    rlca
    rlca
    or a,b                  ;combine low and high nibbles
    pop bc
    ret

_blk_stat_write_protect = 0x01
_blk_stat_error         = 0x80

_sizeof_blk_context = 7
_blk_context:
    .ds 1   ;drive_index
    .ds 2   ;drive ptr
    .ds 1   ;platter
    .ds 1   ;cylinder
    .ds 1   ;sector
    .ds 1   ;stats


_blk_type_floppy    = 0
_blk_type_serial    = 1
_blk_type_ram       = 2
_blk_type_harddrive = 3

_sizeof_blk_device  = 6
_blk_device_cnt = 2
_blk_devices:
    .db _blk_type_floppy    ;type floppy
    .db 2                   ;max platters
    .db 35                  ;max cylinder
    .db 10                  ;max sector
    .dw 0x01                ;args: (hw disk select)

    .db _blk_type_floppy    ;type floppy
    .db 2                   ;max platters
    .db 35                  ;max cylinder
    .db 10                  ;max sector
    .dw 0x02                ;args: (hw disk select)

_err_ok         = 0x00
_err_null_deref = 0x01
_err_range      = 0x02

;void memset (void *buf, uint8_t byte, size_t n);
_memset:
    push bc
    push de
    ex de,hl            ;de = buf
    ld hl,#6            ;hl = &n
    add hl,sp
    ld c,(hl)           ;bc = n
    inc hl
    ld b,(hl)
    ld l,a              ;l = byte
_memset_loop:
    ld a,b              ;while (n != 0) {
    or a,c
    jp z,_memset_exit
    ld a,l              ;    *buf = byte
    ld (de),a
    inc de              ;    buff++;
    dec bc              ;    n--;
    jp _memset_loop     ;}
_memset_exit:
    pop de
    pop bc
    ret

;void blk_reset (void)
_blk_reset:
    push hl                     ;callee saves
    push de
    ld hl,#_blk_context         ;memset (blk_context, 0, sizeof_blk_context);
    ld a,#0
    ld de,#_sizeof_blk_context
    push de
    call _memset
    pop de
    pop de                      ;callee restores
    pop hl
    ret

;uint8_t blk_set_drive (uint8_t drive_index)
_blk_set_drive:
    push hl
    push de
    cp a,#_blk_device_cnt       ;if (drive_index >= blk_set_drive_valid) {
    jp c,_blk_set_drive_valid
    ld a,#_err_range            ;    return err_range
    jp _blk_fn_return
_blk_set_drive_valid:           ;}
    ld (#_blk_context+0),a      ;blk_context.drive_index = drive_index
    ld l,#_sizeof_blk_device    ;hl = &blk_devices[drive_index]
    call _a_mult_l
    ld h,#0
    ld l,a
    ld de,#_blk_devices
    add hl,de
    ex de,hl                    ;de = hl
    ld hl,#_blk_context+1       ;blk_context.drive_ptr = de
    ld (hl),e
    inc hl
    ld (hl),d
    xor a,a                     ;return 0
    jp _blk_fn_return

;hl = blk_context.drive_ptr on success
;a = err_null_deref and return from parent on failure
_blk_deref_drive_ptr:
    ld hl,(#_blk_context+1)     ;hl = blk_context.drive_ptr
    ld a,h                      ;if (blk_context.drive_ptr == NULL)
    or a,l
    ret nz                      ;    return hl
    ld a,#_err_null_deref       ;return err_null_deref
_blk_fn_return_parent:
    pop hl                      ;pop this functions's return addreess
_blk_fn_return:
    pop de                      ;pop protected block_set_* registers
    pop hl
    ret

;CY=1 and return to caller on success
;ACC = err_range, and return from parent on failure
_blk_check_range:
    ld e,(hl)                   ;e = max
    ld a,d                      ;a = input
    cp a,e                      ;if (input < max)
    ret c                       ;    return CY=1;
    ld a,#_err_range            ;return err_range
    jp  _blk_fn_return_parent

;uint8_t blk_set_platter (uint8_t platter)
_blk_set_platter:
    push hl
    push de
    ld e,a                      ;e = platter
    call _blk_deref_drive_ptr   ;hl = blk_context.drive_ptr or return err
    inc hl                      ;hl = &hl->max_platters
    call _blk_check_range       ;on failure, return err
    ld hl,#_blk_context+3       ;blk_context.platter = platter
    ld (hl),e
    xor a,a                     ;return 0
    jp _blk_fn_return

;uint8_t blk_set_cylinder (uint8_t cylinder)
_blk_set_cylinder:
    push hl
    push de
    ld e,a                      ;e = cylinder
    call _blk_deref_drive_ptr   ;hl = blk_context.drive_ptr or return err
    inc hl                      ;hl = &hl->max_cylinders
    inc hl
    call _blk_check_range       ;on failure, return err
    ld hl,#_blk_context+4       ;blk_context.cyclinder = cylinder
    ld (hl),e
    xor a,a                     ;return 0
    jp _blk_fn_return

;uint8_t blk_set_sector (uint8_t sector)
_blk_set_sector:
    push hl
    push de
    ld e,a                      ;e = sector
    call _blk_deref_drive_ptr   ;hl = blk_context.drive_ptr or return err
    inc hl                      ;hl = &hl->max_sectors
    inc hl
    inc hl
    call _blk_check_range       ;on failure, return err
    ld hl,#_blk_context+5       ;blk_context.sector = sector
    ld (hl),e
    xor a,a                     ;return 0
    jp _blk_fn_return

;void blk_set_write_protect (void)
_blk_set_write_protect:
    ld hl,#_blk_context+6
    ld a,(hl)
    or a,#_blk_stat_write_protect
    ld (hl),a
    ret

;void blk_unset_write_protect (void)
_blk_unset_write_protect:
    ld hl,#_blk_context+6
    ld a,(hl)
    and a,#~_blk_stat_write_protect
    ld (hl),a
    ret

;uint8_t blk_get_write_protect (void)
_blk_get_write_protect:
    ld a,(#_blk_context+6)
    and a,#_blk_stat_write_protect
    ret

_blk_read:
    ret

_blk_write:
    ret

    .area _CODE
    .area _INITIALIZER
    .area _CABS (ABS)
; end of file
