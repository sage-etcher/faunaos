
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

    .globl _floppy_await_secmark0
    .globl _floppy_await_secmark1
    .globl _floppy_home
    .globl _floppy_step
    .globl _floppy_await_sector
    .globl _floppy_position
    .globl _floppy_read
    .globl _floppy_read_sector_loop
    .globl _floppy_read_valid_sync1
    .globl _floppy_read_valid_sync2
    .globl _floppy_read_data_loop
    .globl _floppy_read_valid_crc
    .globl _floppy_read_exit
    .globl _prom_video_context
    .globl _send_io_ctrl
    .globl _a_mult_10
    .globl _a_mult_l
    .globl _a_divmod_l
    .globl _a_div
    .globl _a_mod
    .globl _memset
    .globl _cursor_shape_block
    .globl _cursor_shape_hollow
    .globl _cursor_shape_line
    .globl _cursor_shape_bar
    .globl _kb_enable_mi
    .globl _blk_context
    .globl _blk_devices
    .globl _blk_deref_drive_ptr
    .globl _blk_fn_return_parent
    .globl _blk_fn_return
    .globl _blk_check_range
    .globl _floppy_ctrl
    .globl _blk_increment


_adv_io_ctrl  = 0xf0
_adv_io_stat1 = 0xe0
_adv_io_stat2 = 0xd0

_adv_drv_data     = 0x80
_adv_drv_sync1    = 0x81
_adv_drv_ctrl     = 0x81
_adv_drv_set_read = 0x82

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
    push hl
    ld d,#0                 ;de = (uint16_t)param_l
    ld e,l
    ld h,a                  ;hl = (uint16_t)param_a
    ld l,d
    ld c,#8                 ;c = 8
_a_mult_l_loop:
    add hl,hl               ;hl = hl + hl
    jp nc,_a_mult_l_noadd   ;if addition overflows, add de
    add hl,de               ;hl = hl + de
_a_mult_l_noadd:
    dec c                   ;bit loop decriment
    jp nz,_a_mult_l_loop    ;loop until c == 0
    ex de,hl
    pop hl
    pop bc
    ret

;typedef union {
;    uint16_t de_ret;
;    struct { uint8_t d_quotient, e_remainder; };
;} divmod8_t;

;divmod8_t a_divmod_l (uint8_t divident, uint8_t divisor);
_a_divmod_l:
    push bc
    push hl
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
    ld d,a                  ;d = quotient
    ld e,b                  ;e = remainder
    pop hl
    pop bc
    ret

;uint8_t a_div (uint8_t divident, uint8_t divisor);
_a_div:
    push de
    call _a_divmod_l    ;a_divmod_l (divident, divisor)
    ld a,d              ;a = quotient
    pop de
    ret

;uint8_t a_mod (uint8_t divident, uint8_t divisor);
_a_mod:
    push de
    call _a_divmod_l    ;a_divmod_l (divident, divisor)
    ld a,e              ;a = remainder 
    pop de
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

;uint16_t vid_get_cursor_position (void);
_vid_get_cursor_position:
    push bc
    push hl
    ld hl,#_prom_video_context+4    ;hl = &prom_video_context.scrct
    ld a,(hl)                       ;a = scrct
    dec hl                          ;hl = &prom_video_context.raw_y
    dec hl
    dec hl
    ld b,(hl)                       ;b = raw_y
    dec hl                          ;hl = &prom_video_context.raw_x
    ld c,(hl)                       ;c = raw_x
    add a,b                         ;a = (raw_y + scrct) / 10
    ld l,#10
    call _a_div
    ld d,a                          ;ret_y(d) = a;
    ld e,c                          ;ret_x(e) = c;
    pop hl
    pop bc
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
    ld a,#0x10|0x08|0x03    ;toggle keyboard mi
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
    ld a,#0x10|0x08|0x01    ;get low nibble from character
    call _send_io_ctrl
    in a,(#_adv_io_stat2)
    and a,#0x0f
    ld b,a                  ;store unfinished character in c
    ld a,#0x10|0x08|0x02    ;get high nibble from character
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
_err_maxretry   = 0x03
_err_bad_sync1  = 0x04
_err_bad_sync2  = 0x05
_err_bad_crc    = 0x06

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
    ld hl,#_blk_devices
    add hl,de
    ex de,hl                    ;de = hl
    ld hl,#_blk_context+1       ;blk_context.drive_ptr = de
    ld (hl),e
    inc hl
    ld (hl),d
    xor a,a                     ;return 0
    jp _blk_fn_return

;de = blk_context.drive_ptr on success
;a = err_null_deref and return from parent on failure
_blk_deref_drive_ptr:
    push hl
    ld hl,(#_blk_context+1)     ;hl = blk_context.drive_ptr
    ld a,h                      ;if (blk_context.drive_ptr == NULL)
    or a,l
    ex de,hl
    pop hl
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
_blk_check_range:               ;e = input
    ld a,(hl)                   ;a = max
    cp a,e                      ;if (max >= request)
    ret nc                      ;    return CY=1
    ld a,#_err_range            ;return err_range
    jp  _blk_fn_return_parent

;uint8_t blk_set_platter (uint8_t platter)
_blk_set_platter:
    push hl
    push de
    ld l,a                      ;e = platter
    call _blk_deref_drive_ptr   ;de = blk_context.drive_ptr or return err
    inc de                      ;hl = &hl->max_platters
    ex de,hl
    call _blk_check_range       ;on failure, return err
    ld hl,#_blk_context+3       ;blk_context.platter = platter
    ld (hl),e
    xor a,a                     ;return 0
    jp _blk_fn_return

;uint8_t blk_set_cylinder (uint8_t cylinder)
_blk_set_cylinder:
    push hl
    push de
    ld l,a                      ;e = cylinder
    call _blk_deref_drive_ptr   ;de = blk_context.drive_ptr or return err
    inc de                      ;hl = &hl->max_cylinders
    inc de
    ex de,hl
    call _blk_check_range       ;on failure, return err
    ld hl,#_blk_context+4       ;blk_context.cyclinder = cylinder
    ld (hl),e
    xor a,a                     ;return 0
    jp _blk_fn_return

;uint8_t blk_set_sector (uint8_t sector)
_blk_set_sector:
    push hl
    push de
    ld l,a                      ;e = sector
    call _blk_deref_drive_ptr   ;de = blk_context.drive_ptr or return err
    inc de                      ;hl = &hl->max_sectors
    inc de
    inc de
    ex de,hl
    call _blk_check_range       ;on failure, return err
    ld hl,#_blk_context+5       ;blk_context.sector = sector
    ld (hl),e
    xor a,a                     ;return 0
    jp _blk_fn_return

;void blk_set_write_protect (void)
_blk_set_write_protect:
    push hl
    ld hl,#_blk_context+6
    ld a,(hl)
    or a,#_blk_stat_write_protect
    ld (hl),a
    pop hl
    ret

;void blk_unset_write_protect (void)
_blk_unset_write_protect:
    push hl
    ld hl,#_blk_context+6
    ld a,(hl)
    and a,#~_blk_stat_write_protect
    ld (hl),a
    pop hl
    ret

;uint8_t blk_get_write_protect (void)
_blk_get_write_protect:
    ld a,(#_blk_context+6)
    and a,#_blk_stat_write_protect
    ret

_floppy_ctrl:   .ds     1

_floppy_await_secmark0:
    in a,(_adv_io_stat1)            ;get io status
    and a,#0x40                     ;isolate secmark
    jp nz,_floppy_await_secmark0    ;loop until secmark == 0
    ret

_floppy_await_secmark1:
    in a,(_adv_io_stat1)            ;get io status
    and a,#0x40                     ;isolate secmark
    jp z,_floppy_await_secmark1     ;loop until secmark == 1
    ret

_floppy_step_pulse   = #0x10
_floppy_stepdir_out  = #0x00
_floppy_stepdir_in   = #0x20
_floppy_stepdir_mask = #0x20
;uint8_t floppy_step (uint8_t count, uint8_t direction)
_floppy_step:
    or a,a                          ;if count == 0:
    ret z                           ;    return 0
    push hl
    push de
    ld d,a                          ;d = count
    ld e,l                          ;e = direction
    ld hl,#_floppy_ctrl             ;hl = &floppy_ctrl
    ld a,(hl)                       ;a = floppy_ctrl &= ~STEPDIR_MASK
    and a,#~_floppy_stepdir_mask    ;apply step direction
    or a,e
    and a,#~_floppy_step_pulse      ;clear step pulse
    ld e,#_floppy_step_pulse        ;e = floppy_step_pulse
_floppy_step_loop:
    out (_adv_drv_ctrl),a           ;step pulse 0
    xor a,e                         ;step pulse 1
    out (_adv_drv_ctrl),a
    xor a,e                         ;step pulse 0
    out (_adv_drv_ctrl),a
    push af                         ;wait atleast 5ms
    call _floppy_await_secmark1     ;if in secmark, wait till leave 0-5ms
    call _floppy_await_secmark0     ;hold until next secmark        0-15ms
    call _floppy_await_secmark1     ;hold until secmark finished    5ms
    pop af
    dec d                           ;count--
    jp nz,_floppy_step_loop         ;loop until count == 0
    pop de
    pop hl
    ret

;A = 0 on success,
;A = err_maxretry on failure
;uint8_t floppy_home (void)
_floppy_home:
    push hl
    ld h,#0xff                  ;h = maxretry
_floppy_home_loop:              ;do {
    dec h                       ;    h--
    jp z,_floppy_home_error     ;    if (h == 0) goto _floppy_home_error
    ld a,#1                     ;    floppy_step (0, STEPDIR_OUT)
    ld l,#_floppy_stepdir_out
    call _floppy_step
    in a,(#_adv_io_stat1)       ;} while (~adv_io_stat1 & TRACKZERO)
    and a,#0x20
    jp z,_floppy_home_loop
    pop hl
    xor a,a
    ret                         ;return 0x00
_floppy_home_error:
    ld a,#_err_maxretry         ;return _err_maxretry
    pop hl
    ret

;uint8_t floppy_await_sector(uint8_t sector)
_floppy_await_sector:
    push de
    dec a                           ;e = watch_sector
    and a,#0x0f
    ld e,a
_floppy_await_sector_loop:
    call _floppy_await_secmark0     ;wait until sector mark is met
    in a,(_adv_io_stat2)            ;read sector number
    and a,#0x0f
    cp a,e                          ;if (read_sector_num == watch_sector)
    jp z,_floppy_await_sector_found ;   goto floppy_await_sector_found
    call _floppy_await_secmark1     ;wait until sector mark passes before jump
    jp _floppy_await_sector_loop    ;loop
_floppy_await_sector_found:
    pop de
    ret

_floppy_position:
    push hl
    push de

    ;clear floppy_ctrl
    xor a,a                     ;floppy_ctrl = 0
    ld (#_floppy_ctrl),a

    ;floppy_ctrl |= drive select
    call _blk_deref_drive_ptr   ;hl = blk_context.drive_ptr or return err
    ex de,hl
    ld de,#4                    ;hl = &blk_context.drive_ptr->args
    add hl,de
    ld a,(hl)                   ;a = hw disk select
    and a,#0x03                 ;a &= 0b0000_0011 isolate drive select
    ld e,a                      ;e = temp floppy_ctrl

    ;floppy_ctrl |= side select
    ld hl,#_blk_context+3       ;hl = &_blk_context.platter
    ld a,(hl)                   ;a = platter (either 0 or 1)
    rrca                        ;a right_rotate 2
    rrca
    and a,#0x40                 ;a &= 0b0100_0000 isolate platter/side select
    or a,e                      ;temp floppy_ctrl |= a
    ld e,a

    ;set floppy_ctrl
    ld a,e                      ;floppy_ctrl = temp floppy_ctrl
    ld (#_floppy_ctrl),a

    ;start motor
    ld a,#0x10|0x08|0x05        ;a = start_motor
    call _send_io_ctrl

    ;home track
    call _floppy_home

    ;move to track
    inc hl                      ;de = &_blk_context.cylinder
    ex de,hl
    ld a,(de)                   ;a = cylinder
    ld l,#_floppy_stepdir_in    ;l = DCTRL_STEPDIR_IN
    call _floppy_step           ;step the floppy
    ex de,hl

    ;await sector
    inc hl                      ;hl = &_blk_context.sector
    ld a,(hl)                   ;a = sector
    call _floppy_await_sector   ;wait until we are at sector 

    pop de
    pop hl
    ret

;void blk_increment(void)
_blk_increment:
    push hl
    push de
    call _blk_deref_drive_ptr       ;hl = blk_context.drive_ptr or return err
    push bc
    ex de,hl
    inc hl                          ;hl = &max_sector
    inc hl
    inc hl
    ld de,#_blk_context+5           ;de = &blk_context->sector
    call _blk_increment_stage       ;increment sector
    dec de                          ;increment cylinder
    dec hl
    call _blk_increment_stage
    dec de                          ;increment platter
    dec hl
    call _blk_increment_stage
_blk_increment_exit:
    pop bc
    pop de
    pop hl
    ret
_blk_increment_stage:
    ld a,(de)                       ;a = sector
    inc a                           ;a = next sector
    ld b,(hl)                       ;b = max_sector
    cp a,b                          ;if sector >= max_sector
    jp nc,_blk_increment_overflow   ;    goto blk_increment_overflow
    ld (de),a                       ;blk_context->sector = next sector
    pop hl                          ;remove call return
    jp _blk_increment_exit          ;exit parent function
_blk_increment_overflow:
    sub a,b                         ;next sector -= max_sector
    ld (de),a                       ;blk_context->sector = next sector
    ret                             ;return from call

;uint8_t floppy_sync2_calc(void)
_floppy_sync2_calc:
    ;this procedure deviates from the documentation in the technical manual
    ;instead it follows a similar procedure to what is used by NorthStarDOS/CPM
    ;a = track | (side << 6)
    ;b = rrot (a, 2) & 0xf0
    ;c = b | sector
    push bc
    push hl
    ld hl,#_blk_context+3   ;hl = &_blk_context.platter
    ld a,(hl)               ;a = platter
    inc hl                  ;b = cylinder
    ld b,(hl)
    inc hl                  ;c = sector
    ld c,(hl)
    rlca                    ;a = platter << 6
    rlca
    rlca
    rlca
    rlca
    rlca
    or a,b                  ;a |= track
    rrca                    ;a >>= 2
    rrca
    and a,#0xf0             ;a &= 0xf0
    or a,c                  ;a |= sector
    pop hl
    pop bc
    ret

;    push de
;    push hl
;    ld hl,#_blk_context+5           ;hl = &sector
;    ld a,(hl)                       ;a = sector
;    add a,#16                       ;a = a + 16
;    dec hl                          ;hl = &track
;    ld l,(hl)                       ;l = track
;    call _a_mult_l                  ;hl = a * track
;    ld a,e                          ;a = (uin8_t)hl
;    pop hl
;    pop de
;    ret

;uint8_t floppy_read(uint8_t sec_cnt, uint8_t *buf);
_floppy_read:
    push bc
    push de
    ex de,hl
    ld c,a                          ;c = sec_cnt
    call _floppy_position           ;align floppy drive to requested address
_floppy_read_sector_loop:
    call _floppy_await_secmark1     ;step 1 wait for sectormark to pass
    in a,(#_adv_io_stat1) ;1ms
    xor a,a                         ;step 2 set disk read
    out (#_adv_drv_set_read),a
    ld a,#0x10|0x05                 ;step 3 enter aquire mode
    call _send_io_ctrl
    ;in a,(#_adv_io_stat1) ;1ms     ;step 4 exit aquire mode
    ld a,#0x10|#0x08|0x05
    call _send_io_ctrl
_floppy_await_disk_data:            ;step 5 wait for disk data
    in a,(#_adv_io_stat1)
    and a,#0x80
    jp z,_floppy_await_disk_data
    in a,(#_adv_drv_sync1)          ;step 6 input sync1
    cp a,#0xfb                      ;if read_sync1 == 0xfb
    jp z,_floppy_read_valid_sync1   ;    goto floppy_valid_sync1
    ld a,#_err_bad_sync1            ;return err_bad_sync1
    jp _floppy_read_exit
_floppy_read_valid_sync1:           ;step 7.1 input sync2
    call _floppy_sync2_calc         ;b = floppy_sync2_calc(buf)
    ld b,a
    in a,(#_adv_drv_data)           ;a = read_sync2
    cp a,b                          ;if read_sync2 == calc_sync2
    jp z,_floppy_read_valid_sync2   ;    goto floppy_valid_sync2
    ld a,#_err_bad_sync2            ;return err_bad_crc
    jp _floppy_read_exit
_floppy_read_valid_sync2:           ;step 7.2 input 512 bytes of data
    ld b,#0                         ;b = crc = 0
    ld de,#512                      ;counter = 512
_floppy_read_data_loop:             ;do {
    in a,(#_adv_drv_data)           ;    a = read_data_byte
    ld (hl),a                       ;    *buf = a
    xor a,b                         ;b = crc calc
    rlca
    ld b,a
    inc hl                          ;    buf++
    dec de                          ;    counter--
    ld a,d
    or a,e
    jp nz,_floppy_read_data_loop    ;} while (counter != 0)
    in a,(#_adv_drv_data)           ;step 7.3 input crc byte
    cp a,b                          ;if read_crc == calc_crc
    jp z,_floppy_read_valid_crc     ;    goto _floppy_valid_crc
    ld a,#_err_bad_crc              ;return err_bad_crc
    jp _floppy_read_exit
_floppy_read_valid_crc:
    xor a,a                         ;acc = 0
    dec c                           ;step 8 after read next sector or exit
    jp z,_floppy_read_exit          ;if sec_cnt == 0: return acc
    ;call _floppy_await_secmark0     ;wait for next sector mark
    call _blk_increment             ;increment context to next sector
    ld a,(#_blk_context+5)          ;if sector == 0, we wrapped to new track
    or a,a
    call z,_floppy_position         ;so we need to reposition the disk
    jp _floppy_read_sector_loop     ;read next sector
_floppy_read_exit:
    ld b,a                          ;protect retcode
    ld a,#0x10|0x08                 ;unset motor enable
    call _send_io_ctrl
    ld a,b                          ;restore retcode
    pop de
    pop bc
    ret

_blk_read:
    call _floppy_read
    ret

_blk_write:
    call _floppy_position
    ret

    .area _CODE
    .area _INITIALIZER
    .area _CABS (ABS)
; end of file
