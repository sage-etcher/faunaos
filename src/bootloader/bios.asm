
    .module FAUNAOS_BIOS

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
    .globl _blk_get_write_portect
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

_blk_reset:
    ret

_blk_set_drive:
    ret

_blk_set_platter:
    ret

_blk_set_cylinder:
    ret

_blk_set_sector:
    ret

_blk_set_write_protect:
    ret

_blk_get_write_portect:
    ret

_blk_read:
    ret

_blk_write:
    ret

    .area _CODE
    .area _INITIALIZER
    .area _CABS (ABS)
; end of file
