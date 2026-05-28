; this file was generated using /home/sage/local/disi80/dismz80intel on Thu May 28 11:21:12 2026
; using input binary file: bootloader_boot.bin
; and address offset: c000
	rnz                                		;c000	c0          	.   
	nop                                		;c001	00          	.   
	nop                                		;c002	00          	.   
	nop                                		;c003	00          	.   
	nop                                		;c004	00          	.   
	nop                                		;c005	00          	.   
	nop                                		;c006	00          	.   
	nop                                		;c007	00          	.   
	nop                                		;c008	00          	.   
	nop                                		;c009	00          	.   
	jmp     __entry0                   		;c00a	c3 10 c0    	... 
	nop                                		;c00d	00          	.   
	nop                                		;c00e	00          	.   
	nop                                		;c00f	00          	.   
__entry0:
	lxi     sp,0ffffh  ;-1             		;c010	31 ff ff    	1.. 
	call    _blk_reset                 		;c013	cd d6 c1    	... 
	mvi     a,000h                     		;c016	3e 00       	>.  
	call    _blk_set_drive             		;c018	cd e8 c1    	... 
	mvi     a,000h                     		;c01b	3e 00       	>.  
	call    _blk_set_platter           		;c01d	cd 22 c2    	.". 
	mvi     a,000h                     		;c020	3e 00       	>.  
	call    _blk_set_cylinder          		;c022	cd 35 c2    	.5. 
	mvi     a,008h                     		;c025	3e 08       	>.  
	call    _blk_set_sector            		;c027	cd 49 c2    	.I. 
	mvi     a,002h                     		;c02a	3e 02       	>.  
	lxi     d,0c800h                   		;c02c	11 00 c8    	... 
	call    _blk_read                  		;c02f	cd 7c c4    	.|. 
	mvi     a,000h                     		;c032	3e 00       	>.  
	lxi     d,00000h                   		;c034	11 00 00    	... 
	call    _main                      		;c037	cd b3 c4    	... 
_exit:
	hlt                                		;c03a	76          	v   
	jmp     _exit                      		;c03b	c3 3a c0    	.:. 
_prom_video_context:
	nop                                		;c03e	00          	.   
	nop                                		;c03f	00          	.   
	mov     h,c                        		;c040	61          	a   
	add     l                          		;c041	85          	.   
	nop                                		;c042	00          	.   
	nop                                		;c043	00          	.   
	nop                                		;c044	00          	.   
	nop                                		;c045	00          	.   
	rz                                 		;c046	c8          	.   
	rnz                                		;c047	c0          	.   
	nop                                		;c048	00          	.   
_send_io_ctrl:
	push    b                          		;c049	c5          	.   
	mov     b,a                        		;c04a	47          	G   
	in      0e0h                       		;c04b	db e0       	..  
	mov     c,a                        		;c04d	4f          	O   
	mov     a,b                        		;c04e	78          	x   
	out     0f0h                       		;c04f	d3 f0       	..  
	in      0e0h                       		;c051	db e0       	..  
	xra     c                          		;c053	a9          	.   
	jm      0c051h                     		;c054	fa 51 c0    	.Q. 
	pop     b                          		;c057	c1          	.   
	ret                                		;c058	c9          	.   
_a_mult_10:
	push    d                          		;c059	d5          	.   
	rlc                                		;c05a	07          	.   
	mov     d,a                        		;c05b	57          	W   
	rlc                                		;c05c	07          	.   
	rlc                                		;c05d	07          	.   
	add     d                          		;c05e	82          	.   
	pop     d                          		;c05f	d1          	.   
	ret                                		;c060	c9          	.   
_a_mult_l:
	push    b                          		;c061	c5          	.   
	push    h                          		;c062	e5          	.   
	mvi     d,000h                     		;c063	16 00       	..  
	mov     e,l                        		;c065	5d          	]   
	mov     h,a                        		;c066	67          	g   
	mov     l,d                        		;c067	6a          	j   
	mvi     c,008h                     		;c068	0e 08       	..  
	dad     h                          		;c06a	29          	)   
	jnc     0c06fh                     		;c06b	d2 6f c0    	.o. 
	dad     d                          		;c06e	19          	.   
	dcr     c                          		;c06f	0d          	.   
	jnz     0c06ah                     		;c070	c2 6a c0    	.j. 
	xchg                               		;c073	eb          	.   
	pop     h                          		;c074	e1          	.   
	pop     b                          		;c075	c1          	.   
	ret                                		;c076	c9          	.   
_a_divmod_l:
	push    b                          		;c077	c5          	.   
	push    h                          		;c078	e5          	.   
	mov     h,a                        		;c079	67          	g   
	mvi     c,009h                     		;c07a	0e 09       	..  
	xra     a                          		;c07c	af          	.   
	mov     b,a                        		;c07d	47          	G   
	mov     a,h                        		;c07e	7c          	|   
	ral                                		;c07f	17          	.   
	mov     h,a                        		;c080	67          	g   
	dcr     c                          		;c081	0d          	.   
	jz      0c08fh                     		;c082	ca 8f c0    	... 
	mov     a,b                        		;c085	78          	x   
	ral                                		;c086	17          	.   
	sub     l                          		;c087	95          	.   
	jnc     0c07dh                     		;c088	d2 7d c0    	.}. 
	add     l                          		;c08b	85          	.   
	jmp     0c07dh                     		;c08c	c3 7d c0    	.}. 
	mov     a,h                        		;c08f	7c          	|   
	cma                                		;c090	2f          	/   
	mov     d,a                        		;c091	57          	W   
	mov     e,b                        		;c092	58          	X   
	pop     h                          		;c093	e1          	.   
	pop     b                          		;c094	c1          	.   
	ret                                		;c095	c9          	.   
_a_div:
	push    d                          		;c096	d5          	.   
	call    _a_divmod_l                		;c097	cd 77 c0    	.w. 
	mov     a,d                        		;c09a	7a          	z   
	pop     d                          		;c09b	d1          	.   
	ret                                		;c09c	c9          	.   
_a_mod:
	push    d                          		;c09d	d5          	.   
	call    _a_divmod_l                		;c09e	cd 77 c0    	.w. 
	mov     a,e                        		;c0a1	7b          	{   
	pop     d                          		;c0a2	d1          	.   
	ret                                		;c0a3	c9          	.   
_vid_set_cursor_shape:
	push    d                          		;c0a4	d5          	.   
	push    h                          		;c0a5	e5          	.   
	push    psw                        		;c0a6	f5          	.   
	mvi     a,019h                     		;c0a7	3e 19       	>.  
	call    _vid_write_c               		;c0a9	cd 44 c1    	.D. 
	pop     psw                        		;c0ac	f1          	.   
	ani     003h                       		;c0ad	e6 03       	..  
	call    _a_mult_10                 		;c0af	cd 59 c0    	.Y. 
	mov     e,a                        		;c0b2	5f          	_   
	mvi     d,000h                     		;c0b3	16 00       	..  
	lxi     h,_cursor_shape_block      		;c0b5	21 c8 c0    	!.. 
	dad     d                          		;c0b8	19          	.   
	xchg                               		;c0b9	eb          	.   
	lxi     h,0c046h                   		;c0ba	21 46 c0    	!F. 
	mov     m,e                        		;c0bd	73          	s   
	inx     h                          		;c0be	23          	#   
	mov     m,d                        		;c0bf	72          	r   
	mvi     a,018h                     		;c0c0	3e 18       	>.  
	call    _vid_write_c               		;c0c2	cd 44 c1    	.D. 
	pop     d                          		;c0c5	d1          	.   
	pop     h                          		;c0c6	e1          	.   
	ret                                		;c0c7	c9          	.   
_cursor_shape_block:
	rst     7                          		;c0c8	ff          	.   
	rst     7                          		;c0c9	ff          	.   
	rst     7                          		;c0ca	ff          	.   
	rst     7                          		;c0cb	ff          	.   
	rst     7                          		;c0cc	ff          	.   
	rst     7                          		;c0cd	ff          	.   
	rst     7                          		;c0ce	ff          	.   
	rst     7                          		;c0cf	ff          	.   
	rst     7                          		;c0d0	ff          	.   
	rst     7                          		;c0d1	ff          	.   
_cursor_shape_hollow:
	rst     7                          		;c0d2	ff          	.   
	add     c                          		;c0d3	81          	.   
	add     c                          		;c0d4	81          	.   
	add     c                          		;c0d5	81          	.   
	add     c                          		;c0d6	81          	.   
	add     c                          		;c0d7	81          	.   
	add     c                          		;c0d8	81          	.   
	add     c                          		;c0d9	81          	.   
	add     c                          		;c0da	81          	.   
	rst     7                          		;c0db	ff          	.   
_cursor_shape_line:
	nop                                		;c0dc	00          	.   
	nop                                		;c0dd	00          	.   
	nop                                		;c0de	00          	.   
	nop                                		;c0df	00          	.   
	nop                                		;c0e0	00          	.   
	nop                                		;c0e1	00          	.   
	nop                                		;c0e2	00          	.   
	nop                                		;c0e3	00          	.   
	nop                                		;c0e4	00          	.   
	rst     7                          		;c0e5	ff          	.   
_cursor_shape_bar:
	add     b                          		;c0e6	80          	.   
	add     b                          		;c0e7	80          	.   
	add     b                          		;c0e8	80          	.   
	add     b                          		;c0e9	80          	.   
	add     b                          		;c0ea	80          	.   
	add     b                          		;c0eb	80          	.   
	add     b                          		;c0ec	80          	.   
	add     b                          		;c0ed	80          	.   
	add     b                          		;c0ee	80          	.   
	add     b                          		;c0ef	80          	.   
_vid_set_cursor_position:
	push    d                          		;c0f0	d5          	.   
	mvi     a,019h                     		;c0f1	3e 19       	>.  
	call    _vid_write_c               		;c0f3	cd 44 c1    	.D. 
	lxi     d,_prom_video_context      		;c0f6	11 3e c0    	.>. 
	mov     a,l                        		;c0f9	7d          	}   
	stax    d                          		;c0fa	12          	.   
	inx     d                          		;c0fb	13          	.   
	mov     a,h                        		;c0fc	7c          	|   
	call    _a_mult_10                 		;c0fd	cd 59 c0    	.Y. 
	stax    d                          		;c100	12          	.   
	mvi     a,018h                     		;c101	3e 18       	>.  
	call    _vid_write_c               		;c103	cd 44 c1    	.D. 
	pop     d                          		;c106	d1          	.   
	ret                                		;c107	c9          	.   
_vid_get_cursor_position:
	push    b                          		;c108	c5          	.   
	push    h                          		;c109	e5          	.   
	lxi     h,0c042h                   		;c10a	21 42 c0    	!B. 
	mov     a,m                        		;c10d	7e          	~   
	dcx     h                          		;c10e	2b          	+   
	dcx     h                          		;c10f	2b          	+   
	dcx     h                          		;c110	2b          	+   
	mov     b,m                        		;c111	46          	F   
	dcx     h                          		;c112	2b          	+   
	mov     c,m                        		;c113	4e          	N   
	add     b                          		;c114	80          	.   
	mvi     l,00ah                     		;c115	2e 0a       	..  
	call    _a_div                     		;c117	cd 96 c0    	... 
	mov     d,a                        		;c11a	57          	W   
	mov     e,c                        		;c11b	59          	Y   
	pop     h                          		;c11c	e1          	.   
	pop     b                          		;c11d	c1          	.   
	ret                                		;c11e	c9          	.   
_vid_write_c_raw:
	push    b                          		;c11f	c5          	.   
	push    d                          		;c120	d5          	.   
	mov     b,a                        		;c121	47          	G   
	mvi     a,019h                     		;c122	3e 19       	>.  
	call    _vid_write_c               		;c124	cd 44 c1    	.D. 
	lded    _prom_video_context        		;c127	ed 5b 3e c0 	.[>.
	jmp     0c133h                     		;c12b	c3 33 c1    	.3. 
	mov     a,b                        		;c12e	78          	x   
	call    _vid_write_c               		;c12f	cd 44 c1    	.D. 
	dcr     l                          		;c132	2d          	-   
	mov     a,l                        		;c133	7d          	}   
	ora     a                          		;c134	b7          	.   
	jnz     0c12eh                     		;c135	c2 2e c1    	... 
	sded    _prom_video_context        		;c138	ed 53 3e c0 	.S>.
	mvi     a,018h                     		;c13c	3e 18       	>.  
	call    _vid_write_c               		;c13e	cd 44 c1    	.D. 
	pop     d                          		;c141	d1          	.   
	pop     b                          		;c142	c1          	.   
	ret                                		;c143	c9          	.   
_vid_write_c:
	push    b                          		;c144	c5          	.   
	push    d                          		;c145	d5          	.   
	push    h                          		;c146	e5          	.   
	push    x                          		;c147	dd e5       	..  
	push    y                          		;c149	fd e5       	..  
	mov     e,a                        		;c14b	5f          	_   
	mvi     a,080h                     		;c14c	3e 80       	>.  
	out     0a0h                       		;c14e	d3 a0       	..  
	mvi     a,081h                     		;c150	3e 81       	>.  
	out     0a1h                       		;c152	d3 a1       	..  
	mvi     a,084h                     		;c154	3e 84       	>.  
	out     0a2h                       		;c156	d3 a2       	..  
	mov     a,e                        		;c158	7b          	{   
	lxi     d,_prom_video_context      		;c159	11 3e c0    	.>. 
	call    _pvid_putchar              		;c15c	cd 98 c4    	... 
	mvi     a,000h                     		;c15f	3e 00       	>.  
	out     0a0h                       		;c161	d3 a0       	..  
	mvi     a,001h                     		;c163	3e 01       	>.  
	out     0a1h                       		;c165	d3 a1       	..  
	mvi     a,002h                     		;c167	3e 02       	>.  
	out     0a2h                       		;c169	d3 a2       	..  
	pop     y                          		;c16b	fd e1       	..  
	pop     x                          		;c16d	dd e1       	..  
	pop     h                          		;c16f	e1          	.   
	pop     d                          		;c170	d1          	.   
	pop     b                          		;c171	c1          	.   
	ret                                		;c172	c9          	.   
_kb_enable_mi:
	mvi     a,01bh                     		;c173	3e 1b       	>.  
	call    _send_io_ctrl              		;c175	cd 49 c0    	.I. 
	in      0d0h                       		;c178	db d0       	..  
	ani     001h                       		;c17a	e6 01       	..  
	jnz     _kb_enable_mi              		;c17c	c2 73 c1    	.s. 
	ret                                		;c17f	c9          	.   
_kb_get_status:
	call    _kb_enable_mi              		;c180	cd 73 c1    	.s. 
	in      0d0h                       		;c183	db d0       	..  
	ani     040h                       		;c185	e6 40       	.@  
	ret                                		;c187	c9          	.   
_kb_get_keycode:
	call    _kb_get_status             		;c188	cd 80 c1    	... 
	jz      _kb_get_keycode            		;c18b	ca 88 c1    	... 
	push    b                          		;c18e	c5          	.   
	mvi     a,019h                     		;c18f	3e 19       	>.  
	call    _send_io_ctrl              		;c191	cd 49 c0    	.I. 
	in      0d0h                       		;c194	db d0       	..  
	ani     00fh                       		;c196	e6 0f       	..  
	mov     b,a                        		;c198	47          	G   
	mvi     a,01ah                     		;c199	3e 1a       	>.  
	call    _send_io_ctrl              		;c19b	cd 49 c0    	.I. 
	in      0d0h                       		;c19e	db d0       	..  
	ani     00fh                       		;c1a0	e6 0f       	..  
	rlc                                		;c1a2	07          	.   
	rlc                                		;c1a3	07          	.   
	rlc                                		;c1a4	07          	.   
	rlc                                		;c1a5	07          	.   
	ora     b                          		;c1a6	b0          	.   
	pop     b                          		;c1a7	c1          	.   
	ret                                		;c1a8	c9          	.   
_blk_context:
	rst     7                          		;c1a9	ff          	.   
	rst     7                          		;c1aa	ff          	.   
	rst     7                          		;c1ab	ff          	.   
	rst     7                          		;c1ac	ff          	.   
	rst     7                          		;c1ad	ff          	.   
	rst     7                          		;c1ae	ff          	.   
	rst     7                          		;c1af	ff          	.   
_blk_devices:
	nop                                		;c1b0	00          	.   
	stax    b                          		;c1b1	02          	.   
	inx     h                          		;c1b2	23          	#   
	ldax    b                          		;c1b3	0a          	.   
	lxi     b,00000h                   		;c1b4	01 00 00    	... 
	stax    b                          		;c1b7	02          	.   
	inx     h                          		;c1b8	23          	#   
	ldax    b                          		;c1b9	0a          	.   
	stax    b                          		;c1ba	02          	.   
	nop                                		;c1bb	00          	.   
_memset:
	push    b                          		;c1bc	c5          	.   
	push    d                          		;c1bd	d5          	.   
	xchg                               		;c1be	eb          	.   
	lxi     h,00006h                   		;c1bf	21 06 00    	!.. 
	dad     sp                         		;c1c2	39          	9   
	mov     c,m                        		;c1c3	4e          	N   
	inx     h                          		;c1c4	23          	#   
	mov     b,m                        		;c1c5	46          	F   
	mov     l,a                        		;c1c6	6f          	o   
	mov     a,b                        		;c1c7	78          	x   
	ora     c                          		;c1c8	b1          	.   
	jz      0c1d3h                     		;c1c9	ca d3 c1    	... 
	mov     a,l                        		;c1cc	7d          	}   
	stax    d                          		;c1cd	12          	.   
	inx     d                          		;c1ce	13          	.   
	dcx     b                          		;c1cf	0b          	.   
	jmp     0c1c7h                     		;c1d0	c3 c7 c1    	... 
	pop     d                          		;c1d3	d1          	.   
	pop     b                          		;c1d4	c1          	.   
	ret                                		;c1d5	c9          	.   
_blk_reset:
	push    h                          		;c1d6	e5          	.   
	push    d                          		;c1d7	d5          	.   
	lxi     h,_blk_context             		;c1d8	21 a9 c1    	!.. 
	mvi     a,000h                     		;c1db	3e 00       	>.  
	lxi     d,00007h                   		;c1dd	11 07 00    	... 
	push    d                          		;c1e0	d5          	.   
	call    _memset                    		;c1e1	cd bc c1    	... 
	pop     d                          		;c1e4	d1          	.   
	pop     d                          		;c1e5	d1          	.   
	pop     h                          		;c1e6	e1          	.   
	ret                                		;c1e7	c9          	.   
_blk_set_drive:
	push    h                          		;c1e8	e5          	.   
	push    d                          		;c1e9	d5          	.   
	cpi     002h                       		;c1ea	fe 02       	..  
	jc      0c1f4h                     		;c1ec	da f4 c1    	... 
	mvi     a,002h                     		;c1ef	3e 02       	>.  
	jmp     _blk_fn_return             		;c1f1	c3 17 c2    	... 
	sta     _blk_context               		;c1f4	32 a9 c1    	2.. 
	mvi     l,006h                     		;c1f7	2e 06       	..  
	call    _a_mult_l                  		;c1f9	cd 61 c0    	.a. 
	lxi     h,_blk_devices             		;c1fc	21 b0 c1    	!.. 
	dad     d                          		;c1ff	19          	.   
	xchg                               		;c200	eb          	.   
	lxi     h,0c1aah                   		;c201	21 aa c1    	!.. 
	mov     m,e                        		;c204	73          	s   
	inx     h                          		;c205	23          	#   
	mov     m,d                        		;c206	72          	r   
	xra     a                          		;c207	af          	.   
	jmp     _blk_fn_return             		;c208	c3 17 c2    	... 
_blk_deref_drive_ptr:
	push    h                          		;c20b	e5          	.   
	lhld    0c1aah                     		;c20c	2a aa c1    	*.. 
	mov     a,h                        		;c20f	7c          	|   
	ora     l                          		;c210	b5          	.   
	xchg                               		;c211	eb          	.   
	pop     h                          		;c212	e1          	.   
	rnz                                		;c213	c0          	.   
	mvi     a,001h                     		;c214	3e 01       	>.  
_blk_fn_return_parent:
	pop     h                          		;c216	e1          	.   
_blk_fn_return:
	pop     d                          		;c217	d1          	.   
	pop     h                          		;c218	e1          	.   
	ret                                		;c219	c9          	.   
_blk_check_range:
	mov     a,m                        		;c21a	7e          	~   
	cmp     e                          		;c21b	bb          	.   
	rnc                                		;c21c	d0          	.   
	mvi     a,002h                     		;c21d	3e 02       	>.  
	jmp     _blk_fn_return_parent      		;c21f	c3 16 c2    	... 
_blk_set_platter:
	push    h                          		;c222	e5          	.   
	push    d                          		;c223	d5          	.   
	mov     l,a                        		;c224	6f          	o   
	call    _blk_deref_drive_ptr       		;c225	cd 0b c2    	... 
	inx     d                          		;c228	13          	.   
	xchg                               		;c229	eb          	.   
	call    _blk_check_range           		;c22a	cd 1a c2    	... 
	lxi     h,0c1ach                   		;c22d	21 ac c1    	!.. 
	mov     m,e                        		;c230	73          	s   
	xra     a                          		;c231	af          	.   
	jmp     _blk_fn_return             		;c232	c3 17 c2    	... 
_blk_set_cylinder:
	push    h                          		;c235	e5          	.   
	push    d                          		;c236	d5          	.   
	mov     l,a                        		;c237	6f          	o   
	call    _blk_deref_drive_ptr       		;c238	cd 0b c2    	... 
	inx     d                          		;c23b	13          	.   
	inx     d                          		;c23c	13          	.   
	xchg                               		;c23d	eb          	.   
	call    _blk_check_range           		;c23e	cd 1a c2    	... 
	lxi     h,0c1adh                   		;c241	21 ad c1    	!.. 
	mov     m,e                        		;c244	73          	s   
	xra     a                          		;c245	af          	.   
	jmp     _blk_fn_return             		;c246	c3 17 c2    	... 
_blk_set_sector:
	push    h                          		;c249	e5          	.   
	push    d                          		;c24a	d5          	.   
	mov     l,a                        		;c24b	6f          	o   
	call    _blk_deref_drive_ptr       		;c24c	cd 0b c2    	... 
	inx     d                          		;c24f	13          	.   
	inx     d                          		;c250	13          	.   
	inx     d                          		;c251	13          	.   
	xchg                               		;c252	eb          	.   
	call    _blk_check_range           		;c253	cd 1a c2    	... 
	lxi     h,0c1aeh                   		;c256	21 ae c1    	!.. 
	mov     m,e                        		;c259	73          	s   
	xra     a                          		;c25a	af          	.   
	jmp     _blk_fn_return             		;c25b	c3 17 c2    	... 
_blk_set_write_protect:
	push    h                          		;c25e	e5          	.   
	lxi     h,0c1afh                   		;c25f	21 af c1    	!.. 
	mov     a,m                        		;c262	7e          	~   
	ori     001h                       		;c263	f6 01       	..  
	mov     m,a                        		;c265	77          	w   
	pop     h                          		;c266	e1          	.   
	ret                                		;c267	c9          	.   
_blk_unset_write_protect:
	push    h                          		;c268	e5          	.   
	lxi     h,0c1afh                   		;c269	21 af c1    	!.. 
	mov     a,m                        		;c26c	7e          	~   
	ani     0feh                       		;c26d	e6 fe       	..  
	mov     m,a                        		;c26f	77          	w   
	pop     h                          		;c270	e1          	.   
	ret                                		;c271	c9          	.   
_blk_get_write_protect:
	lda     0c1afh                     		;c272	3a af c1    	:.. 
	ani     001h                       		;c275	e6 01       	..  
	ret                                		;c277	c9          	.   
_floppy_ctrl:
	rst     7                          		;c278	ff          	.   
_floppy_await_secmark0:
	in      0e0h                       		;c279	db e0       	..  
	ani     040h                       		;c27b	e6 40       	.@  
	jnz     _floppy_await_secmark0     		;c27d	c2 79 c2    	.y. 
	ret                                		;c280	c9          	.   
_floppy_await_secmark1:
	in      0e0h                       		;c281	db e0       	..  
	ani     040h                       		;c283	e6 40       	.@  
	jz      _floppy_await_secmark1     		;c285	ca 81 c2    	... 
	ret                                		;c288	c9          	.   
_floppy_step:
	ora     a                          		;c289	b7          	.   
	rz                                 		;c28a	c8          	.   
	push    h                          		;c28b	e5          	.   
	push    d                          		;c28c	d5          	.   
	mov     d,a                        		;c28d	57          	W   
	mov     e,l                        		;c28e	5d          	]   
	lxi     h,_floppy_ctrl             		;c28f	21 78 c2    	!x. 
	mov     a,m                        		;c292	7e          	~   
	ani     0dfh                       		;c293	e6 df       	..  
	ora     e                          		;c295	b3          	.   
	ani     0efh                       		;c296	e6 ef       	..  
	mvi     e,010h                     		;c298	1e 10       	..  
	out     081h                       		;c29a	d3 81       	..  
	xra     e                          		;c29c	ab          	.   
	out     081h                       		;c29d	d3 81       	..  
	xra     e                          		;c29f	ab          	.   
	out     081h                       		;c2a0	d3 81       	..  
	push    psw                        		;c2a2	f5          	.   
	call    _floppy_await_secmark1     		;c2a3	cd 81 c2    	... 
	call    _floppy_await_secmark0     		;c2a6	cd 79 c2    	.y. 
	call    _floppy_await_secmark1     		;c2a9	cd 81 c2    	... 
	pop     psw                        		;c2ac	f1          	.   
	dcr     d                          		;c2ad	15          	.   
	jnz     0c29ah                     		;c2ae	c2 9a c2    	... 
	pop     d                          		;c2b1	d1          	.   
	pop     h                          		;c2b2	e1          	.   
	ret                                		;c2b3	c9          	.   
_floppy_home:
	push    h                          		;c2b4	e5          	.   
	mvi     h,0ffh                     		;c2b5	26 ff       	&.  
	dcr     h                          		;c2b7	25          	%   
	jz      0c2cch                     		;c2b8	ca cc c2    	... 
	mvi     a,001h                     		;c2bb	3e 01       	>.  
	mvi     l,000h                     		;c2bd	2e 00       	..  
	call    _floppy_step               		;c2bf	cd 89 c2    	... 
	in      0e0h                       		;c2c2	db e0       	..  
	ani     020h                       		;c2c4	e6 20       	.   
	jz      0c2b7h                     		;c2c6	ca b7 c2    	... 
	pop     h                          		;c2c9	e1          	.   
	xra     a                          		;c2ca	af          	.   
	ret                                		;c2cb	c9          	.   
	mvi     a,003h                     		;c2cc	3e 03       	>.  
	pop     h                          		;c2ce	e1          	.   
	ret                                		;c2cf	c9          	.   
_floppy_await_sector:
	push    d                          		;c2d0	d5          	.   
	dcr     a                          		;c2d1	3d          	=   
	ani     00fh                       		;c2d2	e6 0f       	..  
	mov     e,a                        		;c2d4	5f          	_   
	call    _floppy_await_secmark0     		;c2d5	cd 79 c2    	.y. 
	in      0d0h                       		;c2d8	db d0       	..  
	ani     00fh                       		;c2da	e6 0f       	..  
	cmp     e                          		;c2dc	bb          	.   
	jz      0c2e6h                     		;c2dd	ca e6 c2    	... 
	call    _floppy_await_secmark1     		;c2e0	cd 81 c2    	... 
	jmp     0c2d5h                     		;c2e3	c3 d5 c2    	... 
	pop     d                          		;c2e6	d1          	.   
	ret                                		;c2e7	c9          	.   
_floppy_position:
	push    h                          		;c2e8	e5          	.   
	push    d                          		;c2e9	d5          	.   
	xra     a                          		;c2ea	af          	.   
	sta     _floppy_ctrl               		;c2eb	32 78 c2    	2x. 
	call    _blk_deref_drive_ptr       		;c2ee	cd 0b c2    	... 
	xchg                               		;c2f1	eb          	.   
	lxi     d,00004h                   		;c2f2	11 04 00    	... 
	dad     d                          		;c2f5	19          	.   
	mov     a,m                        		;c2f6	7e          	~   
	ani     003h                       		;c2f7	e6 03       	..  
	mov     e,a                        		;c2f9	5f          	_   
	lxi     h,0c1ach                   		;c2fa	21 ac c1    	!.. 
	mov     a,m                        		;c2fd	7e          	~   
	rrc                                		;c2fe	0f          	.   
	rrc                                		;c2ff	0f          	.   
	ani     040h                       		;c300	e6 40       	.@  
	ora     e                          		;c302	b3          	.   
	mov     e,a                        		;c303	5f          	_   
	mov     a,e                        		;c304	7b          	{   
	sta     _floppy_ctrl               		;c305	32 78 c2    	2x. 
	mvi     a,01dh                     		;c308	3e 1d       	>.  
	call    _send_io_ctrl              		;c30a	cd 49 c0    	.I. 
	call    _floppy_home               		;c30d	cd b4 c2    	... 
	inx     h                          		;c310	23          	#   
	xchg                               		;c311	eb          	.   
	ldax    d                          		;c312	1a          	.   
	mvi     l,020h                     		;c313	2e 20       	.   
	call    _floppy_step               		;c315	cd 89 c2    	... 
	xchg                               		;c318	eb          	.   
	inx     h                          		;c319	23          	#   
	mov     a,m                        		;c31a	7e          	~   
	call    _floppy_await_sector       		;c31b	cd d0 c2    	... 
	pop     d                          		;c31e	d1          	.   
	pop     h                          		;c31f	e1          	.   
	ret                                		;c320	c9          	.   
_blk_increment:
	push    h                          		;c321	e5          	.   
	push    d                          		;c322	d5          	.   
	call    _blk_deref_drive_ptr       		;c323	cd 0b c2    	... 
	push    b                          		;c326	c5          	.   
	xchg                               		;c327	eb          	.   
	inx     h                          		;c328	23          	#   
	inx     h                          		;c329	23          	#   
	inx     h                          		;c32a	23          	#   
	lxi     d,0c1aeh                   		;c32b	11 ae c1    	... 
	call    0c33fh                     		;c32e	cd 3f c3    	.?. 
	dcx     d                          		;c331	1b          	.   
	dcx     h                          		;c332	2b          	+   
	call    0c33fh                     		;c333	cd 3f c3    	.?. 
	dcx     d                          		;c336	1b          	.   
	dcx     h                          		;c337	2b          	+   
	call    0c33fh                     		;c338	cd 3f c3    	.?. 
	pop     b                          		;c33b	c1          	.   
	pop     d                          		;c33c	d1          	.   
	pop     h                          		;c33d	e1          	.   
	ret                                		;c33e	c9          	.   
	ldax    d                          		;c33f	1a          	.   
	inr     a                          		;c340	3c          	<   
	mov     b,m                        		;c341	46          	F   
	cmp     b                          		;c342	b8          	.   
	jnc     0c34bh                     		;c343	d2 4b c3    	.K. 
	stax    d                          		;c346	12          	.   
	pop     h                          		;c347	e1          	.   
	jmp     0c33bh                     		;c348	c3 3b c3    	.;. 
	sub     b                          		;c34b	90          	.   
	stax    d                          		;c34c	12          	.   
	ret                                		;c34d	c9          	.   
	push    b                          		;c34e	c5          	.   
	push    h                          		;c34f	e5          	.   
	lxi     h,0c1ach                   		;c350	21 ac c1    	!.. 
	mov     a,m                        		;c353	7e          	~   
	inx     h                          		;c354	23          	#   
	mov     b,m                        		;c355	46          	F   
	inx     h                          		;c356	23          	#   
	mov     c,m                        		;c357	4e          	N   
	rlc                                		;c358	07          	.   
	rlc                                		;c359	07          	.   
	rlc                                		;c35a	07          	.   
	rlc                                		;c35b	07          	.   
	rlc                                		;c35c	07          	.   
	rlc                                		;c35d	07          	.   
	ora     b                          		;c35e	b0          	.   
	rrc                                		;c35f	0f          	.   
	rrc                                		;c360	0f          	.   
	ani     0f0h                       		;c361	e6 f0       	..  
	ora     c                          		;c363	b1          	.   
	pop     h                          		;c364	e1          	.   
	pop     b                          		;c365	c1          	.   
	ret                                		;c366	c9          	.   
_floppy_read:
	push    b                          		;c367	c5          	.   
	push    d                          		;c368	d5          	.   
	xchg                               		;c369	eb          	.   
	mov     c,a                        		;c36a	4f          	O   
	call    _floppy_position           		;c36b	cd e8 c2    	... 
_floppy_read_sector_loop:
	call    _floppy_await_secmark1     		;c36e	cd 81 c2    	... 
	in      0e0h                       		;c371	db e0       	..  
	xra     a                          		;c373	af          	.   
	out     082h                       		;c374	d3 82       	..  
	mvi     a,015h                     		;c376	3e 15       	>.  
	call    _send_io_ctrl              		;c378	cd 49 c0    	.I. 
	mvi     a,01dh                     		;c37b	3e 1d       	>.  
	call    _send_io_ctrl              		;c37d	cd 49 c0    	.I. 
	in      0e0h                       		;c380	db e0       	..  
	ani     080h                       		;c382	e6 80       	..  
	jz      0c380h                     		;c384	ca 80 c3    	... 
	in      081h                       		;c387	db 81       	..  
	cpi     0fbh                       		;c389	fe fb       	..  
	jz      _floppy_read_valid_sync1   		;c38b	ca 93 c3    	... 
	mvi     a,004h                     		;c38e	3e 04       	>.  
	jmp     _floppy_rw_exit            		;c390	c3 d5 c3    	... 
_floppy_read_valid_sync1:
	call    0c34eh                     		;c393	cd 4e c3    	.N. 
	mov     b,a                        		;c396	47          	G   
	in      080h                       		;c397	db 80       	..  
	cmp     b                          		;c399	b8          	.   
	jz      _floppy_read_valid_sync2   		;c39a	ca a2 c3    	... 
	mvi     a,005h                     		;c39d	3e 05       	>.  
	jmp     _floppy_rw_exit            		;c39f	c3 d5 c3    	... 
_floppy_read_valid_sync2:
	mvi     b,000h                     		;c3a2	06 00       	..  
	lxi     d,00200h                   		;c3a4	11 00 02    	... 
_floppy_read_data_loop:
	in      080h                       		;c3a7	db 80       	..  
	mov     m,a                        		;c3a9	77          	w   
	xra     b                          		;c3aa	a8          	.   
	rlc                                		;c3ab	07          	.   
	mov     b,a                        		;c3ac	47          	G   
	inx     h                          		;c3ad	23          	#   
	dcx     d                          		;c3ae	1b          	.   
	mov     a,d                        		;c3af	7a          	z   
	ora     e                          		;c3b0	b3          	.   
	jnz     _floppy_read_data_loop     		;c3b1	c2 a7 c3    	... 
	in      080h                       		;c3b4	db 80       	..  
	cmp     b                          		;c3b6	b8          	.   
	jz      _floppy_read_valid_crc     		;c3b7	ca bf c3    	... 
	mvi     a,006h                     		;c3ba	3e 06       	>.  
	jmp     _floppy_rw_exit            		;c3bc	c3 d5 c3    	... 
_floppy_read_valid_crc:
	call    _floppy_rw_next            		;c3bf	cd c5 c3    	... 
	jmp     _floppy_read_sector_loop   		;c3c2	c3 6e c3    	.n. 
_floppy_rw_next:
	xra     a                          		;c3c5	af          	.   
	dcr     c                          		;c3c6	0d          	.   
	jz      _floppy_rw_exit            		;c3c7	ca d5 c3    	... 
	call    _blk_increment             		;c3ca	cd 21 c3    	.!. 
	lda     0c1aeh                     		;c3cd	3a ae c1    	:.. 
	ora     a                          		;c3d0	b7          	.   
	cz      _floppy_position           		;c3d1	cc e8 c2    	... 
	ret                                		;c3d4	c9          	.   
_floppy_rw_exit:
	mov     b,a                        		;c3d5	47          	G   
	mvi     a,018h                     		;c3d6	3e 18       	>.  
	call    _send_io_ctrl              		;c3d8	cd 49 c0    	.I. 
	mov     a,b                        		;c3db	78          	x   
	pop     d                          		;c3dc	d1          	.   
	pop     d                          		;c3dd	d1          	.   
	pop     b                          		;c3de	c1          	.   
	ret                                		;c3df	c9          	.   
_floppy_write:
	push    b                          		;c3e0	c5          	.   
	push    d                          		;c3e1	d5          	.   
	xchg                               		;c3e2	eb          	.   
	mov     c,a                        		;c3e3	4f          	O   
	call    _floppy_position           		;c3e4	cd e8 c2    	... 
	in      0e0h                       		;c3e7	db e0       	..  
	ani     010h                       		;c3e9	e6 10       	..  
	jz      _floppy_write_sector_loop  		;c3eb	ca f3 c3    	... 
	mvi     a,009h                     		;c3ee	3e 09       	>.  
	jmp     _floppy_rw_exit            		;c3f0	c3 d5 c3    	... 
_floppy_write_valid_wp:
_floppy_write_sector_loop:
	lxi     d,_floppy_ctrl             		;c3f3	11 78 c2    	.x. 
	lda     0c1adh                     		;c3f6	3a ad c1    	:.. 
	cpi     00fh                       		;c3f9	fe 0f       	..  
	ldax    d                          		;c3fb	1a          	.   
	jc      _floppy_write_no_precomp   		;c3fc	da 04 c4    	... 
	ori     020h                       		;c3ff	f6 20       	.   
	jmp     _floppy_write_valid_precomp		;c401	c3 06 c4    	... 
_floppy_write_no_precomp:
	ani     0dfh                       		;c404	e6 df       	..  
_floppy_write_valid_precomp:
	stax    d                          		;c406	12          	.   
	out     081h                       		;c407	d3 81       	..  
	call    _floppy_await_secmark1     		;c409	cd 81 c2    	... 
	out     083h                       		;c40c	d3 83       	..  
	xra     a                          		;c40e	af          	.   
	mvi     b,022h                     		;c40f	06 22       	."  
_floppy_write_preamble:
	out     080h                       		;c411	d3 80       	..  
	dcr     b                          		;c413	05          	.   
	jnz     _floppy_write_preamble     		;c414	c2 11 c4    	... 
	mvi     a,0fbh                     		;c417	3e fb       	>.  
	out     080h                       		;c419	d3 80       	..  
	call    0c34eh                     		;c41b	cd 4e c3    	.N. 
	out     080h                       		;c41e	d3 80       	..  
	mvi     b,000h                     		;c420	06 00       	..  
	lxi     d,00200h                   		;c422	11 00 02    	... 
_floppy_write_data:
	mov     a,m                        		;c425	7e          	~   
	out     080h                       		;c426	d3 80       	..  
	xra     b                          		;c428	a8          	.   
	rlc                                		;c429	07          	.   
	mov     b,a                        		;c42a	47          	G   
	inx     h                          		;c42b	23          	#   
	dcx     d                          		;c42c	1b          	.   
	mov     a,d                        		;c42d	7a          	z   
	ora     e                          		;c42e	b3          	.   
	jnz     _floppy_write_data         		;c42f	c2 25 c4    	.%. 
	mov     a,b                        		;c432	78          	x   
	out     080h                       		;c433	d3 80       	..  
	call    _floppy_rw_next            		;c435	cd c5 c3    	... 
	jmp     _floppy_write_sector_loop  		;c438	c3 f3 c3    	... 
_blk_unsupported_read:
	mvi     a,007h                     		;c43b	3e 07       	>.  
	ret                                		;c43d	c9          	.   
_blk_unsupported_write:
	mvi     a,008h                     		;c43e	3e 08       	>.  
	ret                                		;c440	c9          	.   
_blk_read_jmp_table:
	mov     h,a                        		;c441	67          	g   
	jmp     _blk_unsupported_read      		;c442	c3 3b c4    	.;. 
	dcx     sp                         		;c445	3b          	;   
	cnz     _blk_unsupported_read      		;c446	c4 3b c4    	.;. 
	nop                                		;c449	00          	.   
_blk_write_jmp_table:
	rpo                                		;c44a	e0          	.   
	jmp     _blk_unsupported_write     		;c44b	c3 3e c4    	.>. 
	mvi     a,0c4h                     		;c44e	3e c4       	>.  
	mvi     a,0c4h                     		;c450	3e c4       	>.  
	nop                                		;c452	00          	.   
_blk_jmp_table:
	push    h                          		;c453	e5          	.   
	push    d                          		;c454	d5          	.   
	call    _blk_deref_drive_ptr       		;c455	cd 0b c2    	... 
	ldax    d                          		;c458	1a          	.   
	cpi     004h                       		;c459	fe 04       	..  
	jnc     _blk_jmp_table_err_range   		;c45b	d2 77 c4    	.w. 
	push    h                          		;c45e	e5          	.   
	mov     l,a                        		;c45f	6f          	o   
	mvi     h,000h                     		;c460	26 00       	&.  
	pop     d                          		;c462	d1          	.   
	dad     h                          		;c463	29          	)   
	dad     d                          		;c464	19          	.   
	mov     e,m                        		;c465	5e          	^   
	inx     h                          		;c466	23          	#   
	mov     d,m                        		;c467	56          	V   
	xchg                               		;c468	eb          	.   
	pop     d                          		;c469	d1          	.   
	pop     d                          		;c46a	d1          	.   
	push    h                          		;c46b	e5          	.   
	lxi     h,00004h                   		;c46c	21 04 00    	!.. 
	dad     sp                         		;c46f	39          	9   
	mov     a,m                        		;c470	7e          	~   
	inx     h                          		;c471	23          	#   
	mov     e,m                        		;c472	5e          	^   
	inx     h                          		;c473	23          	#   
	mov     d,m                        		;c474	56          	V   
	pop     h                          		;c475	e1          	.   
	pchl                               		;c476	e9          	.   
_blk_jmp_table_err_range:
	mvi     a,002h                     		;c477	3e 02       	>.  
	pop     d                          		;c479	d1          	.   
	pop     h                          		;c47a	e1          	.   
	ret                                		;c47b	c9          	.   
_blk_read:
	push    h                          		;c47c	e5          	.   
	push    d                          		;c47d	d5          	.   
	push    psw                        		;c47e	f5          	.   
	inx     sp                         		;c47f	33          	3   
	lxi     h,_blk_read_jmp_table      		;c480	21 41 c4    	!A. 
	call    _blk_jmp_table             		;c483	cd 53 c4    	.S. 
	inx     sp                         		;c486	33          	3   
	pop     d                          		;c487	d1          	.   
	pop     h                          		;c488	e1          	.   
	ret                                		;c489	c9          	.   
_blk_write:
	push    h                          		;c48a	e5          	.   
	push    d                          		;c48b	d5          	.   
	push    psw                        		;c48c	f5          	.   
	inx     sp                         		;c48d	33          	3   
	lxi     h,_blk_write_jmp_table     		;c48e	21 4a c4    	!J. 
	call    _blk_jmp_table             		;c491	cd 53 c4    	.S. 
	inx     sp                         		;c494	33          	3   
	pop     d                          		;c495	d1          	.   
	pop     h                          		;c496	e1          	.   
	ret                                		;c497	c9          	.   
_pvid_putchar:
	push    x                          		;c498	dd e5       	..  
	call    0c4a0h                     		;c49a	cd a0 c4    	... 
	pop     x                          		;c49d	dd e1       	..  
	ret                                		;c49f	c9          	.   
	lxi     x,00000h                   		;c4a0	dd 21 00 00 	.!..
	dadx    d                          		;c4a4	dd 19       	..  
	pop     d                          		;c4a6	d1          	.   
	mov     [ix+6],e                   		;c4a7	dd 73 06    	.s. 
	mov     [ix+7],d                   		;c4aa	dd 72 07    	.r. 
	lxi     h,087fdh                   		;c4ad	21 fd 87    	!.. 
	pchl                               		;c4b0	e9          	.   
_cpu_halt:
	hlt                                		;c4b1	76          	v   
	ret                                		;c4b2	c9          	.   
_main:
	mvi     a,01eh                     		;c4b3	3e 1e       	>.  
	call    _vid_write_c               		;c4b5	cd 44 c1    	.D. 
	mvi     a,00fh                     		;c4b8	3e 0f       	>.  
	call    _vid_write_c               		;c4ba	cd 44 c1    	.D. 
	lxi     h,0c5a7h                   		;c4bd	21 a7 c5    	!.. 
	call    _puts                      		;c4c0	cd 40 c6    	.@. 
	mvi     a,00dh                     		;c4c3	3e 0d       	>.  
	call    _vid_write_c               		;c4c5	cd 44 c1    	.D. 
	lxi     h,0c5b1h                   		;c4c8	21 b1 c5    	!.. 
	call    _puts_line                 		;c4cb	cd 33 c6    	.3. 
	call    _blk_reset                 		;c4ce	cd d6 c1    	... 
	xra     a                          		;c4d1	af          	.   
	call    _blk_set_drive             		;c4d2	cd e8 c1    	... 
	call    _putbyte                   		;c4d5	cd 57 c6    	.W. 
	xra     a                          		;c4d8	af          	.   
	call    _blk_set_platter           		;c4d9	cd 22 c2    	.". 
	call    _putbyte                   		;c4dc	cd 57 c6    	.W. 
	mvi     a,015h                     		;c4df	3e 15       	>.  
	call    _blk_set_cylinder          		;c4e1	cd 35 c2    	.5. 
	call    _putbyte                   		;c4e4	cd 57 c6    	.W. 
	mvi     a,008h                     		;c4e7	3e 08       	>.  
	call    _blk_set_sector            		;c4e9	cd 49 c2    	.I. 
	call    _putbyte                   		;c4ec	cd 57 c6    	.W. 
	lxi     d,0d000h                   		;c4ef	11 00 d0    	... 
	mvi     a,004h                     		;c4f2	3e 04       	>.  
	call    _blk_read                  		;c4f4	cd 7c c4    	.|. 
	call    _putbyte                   		;c4f7	cd 57 c6    	.W. 
	mvi     a,01fh                     		;c4fa	3e 1f       	>.  
	call    _vid_write_c               		;c4fc	cd 44 c1    	.D. 
	lxi     h,0c5c5h                   		;c4ff	21 c5 c5    	!.. 
	call    _puts_line                 		;c502	cd 33 c6    	.3. 
	xra     a                          		;c505	af          	.   
	call    _blk_set_platter           		;c506	cd 22 c2    	.". 
	call    _putbyte                   		;c509	cd 57 c6    	.W. 
	mvi     a,016h                     		;c50c	3e 16       	>.  
	call    _blk_set_cylinder          		;c50e	cd 35 c2    	.5. 
	call    _putbyte                   		;c511	cd 57 c6    	.W. 
	mvi     a,008h                     		;c514	3e 08       	>.  
	call    _blk_set_sector            		;c516	cd 49 c2    	.I. 
	call    _putbyte                   		;c519	cd 57 c6    	.W. 
	lxi     d,0d000h                   		;c51c	11 00 d0    	... 
	mvi     a,004h                     		;c51f	3e 04       	>.  
	call    _blk_write                 		;c521	cd 8a c4    	... 
	call    _putbyte                   		;c524	cd 57 c6    	.W. 
	mvi     a,01fh                     		;c527	3e 1f       	>.  
	call    _vid_write_c               		;c529	cd 44 c1    	.D. 
	lxi     h,0c5dch                   		;c52c	21 dc c5    	!.. 
	call    _puts_line                 		;c52f	cd 33 c6    	.3. 
	xra     a                          		;c532	af          	.   
	call    _blk_set_platter           		;c533	cd 22 c2    	.". 
	call    _putbyte                   		;c536	cd 57 c6    	.W. 
	mvi     a,016h                     		;c539	3e 16       	>.  
	call    _blk_set_cylinder          		;c53b	cd 35 c2    	.5. 
	call    _putbyte                   		;c53e	cd 57 c6    	.W. 
	mvi     a,008h                     		;c541	3e 08       	>.  
	call    _blk_set_sector            		;c543	cd 49 c2    	.I. 
	call    _putbyte                   		;c546	cd 57 c6    	.W. 
	lxi     d,0d800h                   		;c549	11 00 d8    	... 
	mvi     a,004h                     		;c54c	3e 04       	>.  
	call    _blk_read                  		;c54e	cd 7c c4    	.|. 
	call    _putbyte                   		;c551	cd 57 c6    	.W. 
	lxi     h,00800h                   		;c554	21 00 08    	!.. 
	push    h                          		;c557	e5          	.   
	lxi     d,0d800h                   		;c558	11 00 d8    	... 
	mvi     h,0d0h                     		;c55b	26 d0       	&.  
	call    _memcmp                    		;c55d	cd 60 c8    	.`. 
	ora     a                          		;c560	b7          	.   
	jrnz    0c569h                     		;c561	20 08       	 .  
	lxi     h,0c5f3h                   		;c563	21 f3 c5    	!.. 
	call    _puts                      		;c566	cd 40 c6    	.@. 
	jr      0c56fh                     		;c569	18 06       	..  
	lxi     h,0c5fbh                   		;c56b	21 fb c5    	!.. 
	call    _puts                      		;c56e	cd 40 c6    	.@. 
	lxi     h,0c601h                   		;c571	21 01 c6    	!.. 
	call    _puts_line                 		;c574	cd 33 c6    	.3. 
	lxi     d,00043h                   		;c577	11 43 00    	.C. 
	lxi     h,00000h                   		;c57a	21 00 00    	!.. 
	call    _readline                  		;c57d	cd b8 c6    	... 
	push    d                          		;c580	d5          	.   
	lxi     h,0c610h                   		;c581	21 10 c6    	!.. 
	call    _puts_line                 		;c584	cd 33 c6    	.3. 
	pop     d                          		;c587	d1          	.   
	mov     a,e                        		;c588	7b          	{   
	call    _putbyte                   		;c589	cd 57 c6    	.W. 
	mvi     a,01fh                     		;c58c	3e 1f       	>.  
	call    _vid_write_c               		;c58e	cd 44 c1    	.D. 
	lxi     h,01600h                   		;c591	21 00 16    	!.. 
	call    _vid_set_cursor_position   		;c594	cd f0 c0    	... 
	lxi     h,0c61fh                   		;c597	21 1f c6    	!.. 
	call    _puts                      		;c59a	cd 40 c6    	.@. 
	mvi     a,019h                     		;c59d	3e 19       	>.  
	call    _vid_write_c               		;c59f	cd 44 c1    	.D. 
	call    _cpu_halt                  		;c5a2	cd b1 c4    	... 
	jr      0c5a0h                     		;c5a5	18 fb       	..  
	mov     l,b                        		;c5a7	68          	h   
	mov     h,l                        		;c5a8	65          	e   
	mov     l,h                        		;c5a9	6c          	l   
	mov     l,h                        		;c5aa	6c          	l   
	mov     l,a                        		;c5ab	6f          	o   
	mov     m,d                        		;c5ac	72          	r   
	mov     l,h                        		;c5ad	6c          	l   
	mov     h,h                        		;c5ae	64          	d   
	lxi     h,07200h                   		;c5af	21 00 72    	!.r 
	mov     h,l                        		;c5b2	65          	e   
	mov     h,c                        		;c5b3	61          	a   
	mov     h,h                        		;c5b4	64          	d   
	mov     l,c                        		;c5b5	69          	i   
	mov     l,m                        		;c5b6	6e          	n   
	mov     h,a                        		;c5b7	67          	g   
	jrnz    0c61eh                     		;c5b8	20 66       	 f  
	mov     m,d                        		;c5ba	72          	r   
	mov     l,a                        		;c5bb	6f          	o   
	mov     l,l                        		;c5bc	6d          	m   
	jrnz    0c621h                     		;c5bd	20 64       	 d  
	mov     l,c                        		;c5bf	69          	i   
	mov     m,e                        		;c5c0	73          	s   
	mov     l,e                        		;c5c1	6b          	k   
	lda     00020h                     		;c5c2	3a 20 00    	: . 
	mov     m,a                        		;c5c5	77          	w   
	mov     m,d                        		;c5c6	72          	r   
	mov     l,c                        		;c5c7	69          	i   
	mov     m,h                        		;c5c8	74          	t   
	mov     l,c                        		;c5c9	69          	i   
	mov     l,m                        		;c5ca	6e          	n   
	mov     h,a                        		;c5cb	67          	g   
	jrnz    _puts                      		;c5cc	20 74       	 t  
	mov     l,a                        		;c5ce	6f          	o   
	jrnz    _puts_line                 		;c5cf	20 64       	 d  
	mov     l,c                        		;c5d1	69          	i   
	mov     m,e                        		;c5d2	73          	s   
	mov     l,e                        		;c5d3	6b          	k   
	lda     02020h                     		;c5d4	3a 20 20    	:   
	jrnz    0c5f7h                     		;c5d7	20 20       	    
	jrnz    0c5f9h                     		;c5d9	20 20       	    
	nop                                		;c5db	00          	.   
	hlt                                		;c5dc	76          	v   
	mov     h,c                        		;c5dd	61          	a   
	mov     l,h                        		;c5de	6c          	l   
	mov     l,c                        		;c5df	69          	i   
	mov     h,h                        		;c5e0	64          	d   
	mov     h,c                        		;c5e1	61          	a   
	mov     m,h                        		;c5e2	74          	t   
	mov     l,c                        		;c5e3	69          	i   
	mov     l,m                        		;c5e4	6e          	n   
	mov     h,a                        		;c5e5	67          	g   
	jrnz    0c65dh                     		;c5e6	20 77       	 w  
	mov     m,d                        		;c5e8	72          	r   
	mov     l,c                        		;c5e9	69          	i   
	mov     m,h                        		;c5ea	74          	t   
	mov     h,l                        		;c5eb	65          	e   
	lda     02020h                     		;c5ec	3a 20 20    	:   
	jrnz    0c60fh                     		;c5ef	20 20       	    
	jrnz    0c5f1h                     		;c5f1	20 00       	 .  
	mov     m,e                        		;c5f3	73          	s   
	mov     m,l                        		;c5f4	75          	u   
	mov     h,e                        		;c5f5	63          	c   
	mov     h,e                        		;c5f6	63          	c   
	mov     h,l                        		;c5f7	65          	e   
	mov     m,e                        		;c5f8	73          	s   
	mov     m,e                        		;c5f9	73          	s   
	nop                                		;c5fa	00          	.   
	mov     h,l                        		;c5fb	65          	e   
	mov     m,d                        		;c5fc	72          	r   
	mov     m,d                        		;c5fd	72          	r   
	mov     l,a                        		;c5fe	6f          	o   
	mov     m,d                        		;c5ff	72          	r   
	nop                                		;c600	00          	.   
	ldax    b                          		;c601	0a          	.   
	dcr     c                          		;c602	0d          	.   
	mov     m,h                        		;c603	74          	t   
	mov     h,l                        		;c604	65          	e   
	mov     m,e                        		;c605	73          	s   
	mov     m,h                        		;c606	74          	t   
	jrnz    0c677h                     		;c607	20 70       	 p  
	mov     m,d                        		;c609	72          	r   
	mov     l,a                        		;c60a	6f          	o   
	mov     l,l                        		;c60b	6d          	m   
	mov     m,b                        		;c60c	70          	p   
	mov     m,h                        		;c60d	74          	t   
	mvi     a,000h                     		;c60e	3e 00       	>.  
	mov     l,c                        		;c610	69          	i   
	mov     l,m                        		;c611	6e          	n   
	mov     m,b                        		;c612	70          	p   
	mov     m,l                        		;c613	75          	u   
	mov     m,h                        		;c614	74          	t   
	jrnz    0c681h                     		;c615	20 6c       	 l  
	mov     h,l                        		;c617	65          	e   
	mov     l,m                        		;c618	6e          	n   
	mov     h,a                        		;c619	67          	g   
	mov     m,h                        		;c61a	74          	t   
	mov     l,b                        		;c61b	68          	h   
	lda     00020h                     		;c61c	3a 20 00    	: . 
	mov     l,b                        		;c61f	68          	h   
	mov     h,c                        		;c620	61          	a   
	mov     l,h                        		;c621	6c          	l   
	mov     m,h                        		;c622	74          	t   
	mov     l,c                        		;c623	69          	i   
	mov     l,m                        		;c624	6e          	n   
	mov     h,a                        		;c625	67          	g   
	nop                                		;c626	00          	.   
_getchar:
	call    _kb_get_keycode            		;c627	cd 88 c1    	... 
	mov     c,a                        		;c62a	4f          	O   
	push    b                          		;c62b	c5          	.   
	mov     a,c                        		;c62c	79          	y   
	call    _vid_write_c               		;c62d	cd 44 c1    	.D. 
	pop     b                          		;c630	c1          	.   
	mov     a,c                        		;c631	79          	y   
	ret                                		;c632	c9          	.   
_puts_line:
	mov     a,m                        		;c633	7e          	~   
	inx     h                          		;c634	23          	#   
	mov     c,a                        		;c635	4f          	O   
	ora     a                          		;c636	b7          	.   
	rz                                 		;c637	c8          	.   
	push    h                          		;c638	e5          	.   
	mov     a,c                        		;c639	79          	y   
	call    _vid_write_c               		;c63a	cd 44 c1    	.D. 
	pop     h                          		;c63d	e1          	.   
	jr      0c631h                     		;c63e	18 f3       	..  
_puts:
	call    _puts_line                 		;c640	cd 33 c6    	.3. 
	mvi     a,01fh                     		;c643	3e 1f       	>.  
	jmp     _vid_write_c               		;c645	c3 44 c1    	.D. 
_xtoc:
	ani     00fh                       		;c648	e6 0f       	..  
	mov     c,a                        		;c64a	4f          	O   
	sui     00ah                       		;c64b	d6 0a       	..  
	jrc     0c651h                     		;c64d	38 04       	8.  
	mov     a,c                        		;c64f	79          	y   
	adi     057h                       		;c650	c6 57       	.W  
	ret                                		;c652	c9          	.   
	mov     a,c                        		;c653	79          	y   
	adi     030h                       		;c654	c6 30       	.0  
	ret                                		;c656	c9          	.   
_putbyte:
	mov     c,a                        		;c657	4f          	O   
	mov     b,c                        		;c658	41          	A   
	srlr    b                          		;c659	cb 38       	.8  
	srlr    b                          		;c65b	cb 38       	.8  
	srlr    b                          		;c65d	cb 38       	.8  
	srlr    b                          		;c65f	cb 38       	.8  
	push    b                          		;c661	c5          	.   
	mov     a,b                        		;c662	78          	x   
	call    _xtoc                      		;c663	cd 48 c6    	.H. 
	call    _vid_write_c               		;c666	cd 44 c1    	.D. 
	pop     b                          		;c669	c1          	.   
	mov     a,c                        		;c66a	79          	y   
	call    _xtoc                      		;c66b	cd 48 c6    	.H. 
	call    _vid_write_c               		;c66e	cd 44 c1    	.D. 
	mvi     a,020h                     		;c671	3e 20       	>   
	jmp     _vid_write_c               		;c673	c3 44 c1    	.D. 
_putword:
	mov     a,h                        		;c676	7c          	|   
	rlc                                		;c677	07          	.   
	rlc                                		;c678	07          	.   
	rlc                                		;c679	07          	.   
	rlc                                		;c67a	07          	.   
	ani     00fh                       		;c67b	e6 0f       	..  
	mov     c,a                        		;c67d	4f          	O   
	push    h                          		;c67e	e5          	.   
	mov     a,c                        		;c67f	79          	y   
	call    _xtoc                      		;c680	cd 48 c6    	.H. 
	call    _vid_write_c               		;c683	cd 44 c1    	.D. 
	pop     h                          		;c686	e1          	.   
	mov     c,h                        		;c687	4c          	L   
	push    h                          		;c688	e5          	.   
	mov     a,c                        		;c689	79          	y   
	call    _xtoc                      		;c68a	cd 48 c6    	.H. 
	call    _vid_write_c               		;c68d	cd 44 c1    	.D. 
	pop     h                          		;c690	e1          	.   
	mov     c,l                        		;c691	4d          	M   
	mov     b,h                        		;c692	44          	D   
	srlr    b                          		;c693	cb 38       	.8  
	rarr    c                          		;c695	cb 19       	..  
	srlr    b                          		;c697	cb 38       	.8  
	rarr    c                          		;c699	cb 19       	..  
	srlr    b                          		;c69b	cb 38       	.8  
	rarr    c                          		;c69d	cb 19       	..  
	srlr    b                          		;c69f	cb 38       	.8  
	rarr    c                          		;c6a1	cb 19       	..  
	push    h                          		;c6a3	e5          	.   
	mov     a,c                        		;c6a4	79          	y   
	call    _xtoc                      		;c6a5	cd 48 c6    	.H. 
	call    _vid_write_c               		;c6a8	cd 44 c1    	.D. 
	pop     h                          		;c6ab	e1          	.   
	mov     a,l                        		;c6ac	7d          	}   
	call    _xtoc                      		;c6ad	cd 48 c6    	.H. 
	call    _vid_write_c               		;c6b0	cd 44 c1    	.D. 
	mvi     a,020h                     		;c6b3	3e 20       	>   
	jmp     _vid_write_c               		;c6b5	c3 44 c1    	.D. 
_readline:
	push    x                          		;c6b8	dd e5       	..  
	lxi     x,00000h                   		;c6ba	dd 21 00 00 	.!..
	dadx    sp                         		;c6be	dd 39       	.9  
	lxi     y,0fff2h  ;-14             		;c6c0	fd 21 f2 ff 	.!..
	dady    sp                         		;c6c4	fd 39       	.9  
	spiy                               		;c6c6	fd f9       	..  
	mov     [ix-2],l                   		;c6c8	dd 75 fe    	.u. 
	mov     [ix-1],h                   		;c6cb	dd 74 ff    	.t. 
	mov     [ix-4],e                   		;c6ce	dd 73 fc    	.s. 
	mov     [ix-3],d                   		;c6d1	dd 72 fd    	.r. 
	lxi     h,00000h                   		;c6d4	21 00 00    	!.. 
	xthl                               		;c6d7	e3          	.   
	xra     a                          		;c6d8	af          	.   
	mov     [ix-12],a                  		;c6d9	dd 77 f4    	.w. 
	mov     [ix-11],a                  		;c6dc	dd 77 f5    	.w. 
	mov     l,[ix-4]                   		;c6df	dd 6e fc    	.n. 
	mvi     a,02eh                     		;c6e2	3e 2e       	>.  
	call    _vid_write_c_raw           		;c6e4	cd 1f c1    	... 
	call    _vid_get_cursor_position   		;c6e7	cd 08 c1    	... 
	mov     [ix-10],e                  		;c6ea	dd 73 f6    	.s. 
	mov     [ix-9],d                   		;c6ed	dd 72 f7    	.r. 
	ld      a,[ix-10]                  		;c6f0	dd 7e f6    	.~. 
	mov     [ix-8],a                   		;c6f3	dd 77 f8    	.w. 
	ld      a,[ix-9]                   		;c6f6	dd 7e f7    	.~. 
	mov     [ix-7],a                   		;c6f9	dd 77 f9    	.w. 
	call    _kb_get_keycode            		;c6fc	cd 88 c1    	... 
	mov     [ix-6],a                   		;c6ff	dd 77 fa    	.w. 
	sui     00dh                       		;c702	d6 0d       	..  
	jrz     0c73eh                     		;c704	28 3a       	(:  
	mov     c,[ix-12]                  		;c706	dd 4e f4    	.N. 
	mov     b,[ix-11]                  		;c709	dd 46 f5    	.F. 
	dcx     b                          		;c70c	0b          	.   
	ld      a,[ix-14]                  		;c70d	dd 7e f2    	.~. 
	mov     [ix-5],a                   		;c710	dd 77 fb    	.w. 
	ld      a,[ix-6]                   		;c713	dd 7e fa    	.~. 
	sui     07fh                       		;c716	d6 7f       	..  
	jrz     0c74dh                     		;c718	28 35       	(5  
	ld      a,[ix-6]                   		;c71a	dd 7e fa    	.~. 
	sui     082h                       		;c71d	d6 82       	..  
	jz      0c7b5h                     		;c71f	ca b5 c7    	... 
	pop     h                          		;c722	e1          	.   
	pop     d                          		;c723	d1          	.   
	push    d                          		;c724	d5          	.   
	push    h                          		;c725	e5          	.   
	inx     d                          		;c726	13          	.   
	ld      a,[ix-6]                   		;c727	dd 7e fa    	.~. 
	sui     086h                       		;c72a	d6 86       	..  
	jz      0c7cdh                     		;c72c	ca cd c7    	... 
	ld      a,[ix-6]                   		;c72f	dd 7e fa    	.~. 
	sui     088h                       		;c732	d6 88       	..  
	jrz     0c787h                     		;c734	28 53       	(S  
	ld      a,[ix-6]                   		;c736	dd 7e fa    	.~. 
	sui     08ah                       		;c739	d6 8a       	..  
	jrz     0c7a0h                     		;c73b	28 65       	(e  
	jmp     0c7eeh                     		;c73d	c3 ee c7    	... 
	mvi     a,00ah                     		;c740	3e 0a       	>.  
	call    _vid_write_c               		;c742	cd 44 c1    	.D. 
	mvi     a,00dh                     		;c745	3e 0d       	>.  
	call    _vid_write_c               		;c747	cd 44 c1    	.D. 
	pop     d                          		;c74a	d1          	.   
	push    d                          		;c74b	d5          	.   
	jmp     0c85bh                     		;c74c	c3 5b c8    	.[. 
	ld      a,[ix-11]                  		;c74f	dd 7e f5    	.~. 
	ora     [ix-12]                    		;c752	dd b6 f4    	... 
	jrz     0c762h                     		;c755	28 0d       	(.  
	push    b                          		;c757	c5          	.   
	mvi     a,008h                     		;c758	3e 08       	>.  
	call    _vid_write_c               		;c75a	cd 44 c1    	.D. 
	pop     b                          		;c75d	c1          	.   
	mov     [ix-12],c                  		;c75e	dd 71 f4    	.q. 
	mov     [ix-11],b                  		;c761	dd 70 f5    	.p. 
	mov     c,[ix-12]                  		;c764	dd 4e f4    	.N. 
	ld      a,[ix-5]                   		;c767	dd 7e fb    	.~. 
	sub     c                          		;c76a	91          	.   
	mov     l,a                        		;c76b	6f          	o   
	mvi     a,02eh                     		;c76c	3e 2e       	>.  
	call    _vid_write_c_raw           		;c76e	cd 1f c1    	... 
	call    _vid_get_cursor_position   		;c771	cd 08 c1    	... 
	mov     [ix-8],e                   		;c774	dd 73 f8    	.s. 
	mov     [ix-7],d                   		;c777	dd 72 f9    	.r. 
	ld      a,[ix-12]                  		;c77a	dd 7e f4    	.~. 
	mov     [ix-14],a                  		;c77d	dd 77 f2    	.w. 
	ld      a,[ix-11]                  		;c780	dd 7e f5    	.~. 
	mov     [ix-13],a                  		;c783	dd 77 f3    	.w. 
	jmp     0c6fch                     		;c786	c3 fc c6    	... 
	ld      a,[ix-11]                  		;c789	dd 7e f5    	.~. 
	ora     [ix-12]                    		;c78c	dd b6 f4    	... 
	jz      0c6fch                     		;c78f	ca fc c6    	... 
	push    b                          		;c792	c5          	.   
	mvi     a,008h                     		;c793	3e 08       	>.  
	call    _vid_write_c               		;c795	cd 44 c1    	.D. 
	pop     b                          		;c798	c1          	.   
	mov     [ix-12],c                  		;c799	dd 71 f4    	.q. 
	mov     [ix-11],b                  		;c79c	dd 70 f5    	.p. 
	jmp     0c6fch                     		;c79f	c3 fc c6    	... 
	mov     l,[ix-10]                  		;c7a2	dd 6e f6    	.n. 
	mov     [ix-9],h                   		;c7a5	dd 66 f7    	.f. 
	call    _vid_set_cursor_position   		;c7a8	cd f0 c0    	... 
	xra     a                          		;c7ab	af          	.   
	mov     [ix-12],a                  		;c7ac	dd 77 f4    	.w. 
	mov     [ix-11],a                  		;c7af	dd 77 f5    	.w. 
	jmp     0c6fch                     		;c7b2	c3 fc c6    	... 
	mov     l,[ix-8]                   		;c7b5	dd 6e f8    	.n. 
	mov     [ix-7],h                   		;c7b8	dd 66 f9    	.f. 
	call    _vid_set_cursor_position   		;c7bb	cd f0 c0    	... 
	ld      a,[ix-14]                  		;c7be	dd 7e f2    	.~. 
	mov     [ix-12],a                  		;c7c1	dd 77 f4    	.w. 
	ld      a,[ix-13]                  		;c7c4	dd 7e f3    	.~. 
	mov     [ix-11],a                  		;c7c7	dd 77 f5    	.w. 
	jmp     0c6fch                     		;c7ca	c3 fc c6    	... 
	ld      a,[ix-12]                  		;c7cd	dd 7e f4    	.~. 
	sub     [ix-14]                    		;c7d0	dd 96 f2    	... 
	jrnz    0c7dch                     		;c7d3	20 09       	 .  
	ld      a,[ix-11]                  		;c7d5	dd 7e f5    	.~. 
	sub     [ix-13]                    		;c7d8	dd 96 f3    	... 
	jz      0c6fch                     		;c7db	ca fc c6    	... 
	push    d                          		;c7de	d5          	.   
	mvi     a,00ch                     		;c7df	3e 0c       	>.  
	call    _vid_write_c               		;c7e1	cd 44 c1    	.D. 
	pop     d                          		;c7e4	d1          	.   
	mov     [ix-12],e                  		;c7e5	dd 73 f4    	.s. 
	mov     [ix-11],d                  		;c7e8	dd 72 f5    	.r. 
	jmp     0c6fch                     		;c7eb	c3 fc c6    	... 
	ld      a,[ix-12]                  		;c7ee	dd 7e f4    	.~. 
	sub     [ix-4]                     		;c7f1	dd 96 fc    	... 
	jrnz    0c7fdh                     		;c7f4	20 09       	 .  
	ld      a,[ix-11]                  		;c7f6	dd 7e f5    	.~. 
	sub     [ix-3]                     		;c7f9	dd 96 fd    	... 
	jz      0c6fch                     		;c7fc	ca fc c6    	... 
	push    d                          		;c7ff	d5          	.   
	ld      a,[ix-6]                   		;c800	dd 7e fa    	.~. 
	call    _vid_write_c               		;c803	cd 44 c1    	.D. 
	pop     d                          		;c806	d1          	.   
	mov     [ix-12],e                  		;c807	dd 73 f4    	.s. 
	mov     [ix-11],d                  		;c80a	dd 72 f5    	.r. 
	ld      a,[ix-12]                  		;c80d	dd 7e f4    	.~. 
	sub     [ix-14]                    		;c810	dd 96 f2    	... 
	ld      a,[ix-11]                  		;c813	dd 7e f5    	.~. 
	sbb     [ix-13]                    		;c816	dd 9e f3    	... 
	jrnc    0c826h                     		;c819	30 0d       	0.  
	mov     c,[ix-12]                  		;c81b	dd 4e f4    	.N. 
	ld      a,[ix-5]                   		;c81e	dd 7e fb    	.~. 
	sub     c                          		;c821	91          	.   
	mov     l,a                        		;c822	6f          	o   
	mvi     a,02eh                     		;c823	3e 2e       	>.  
	call    _vid_write_c_raw           		;c825	cd 1f c1    	... 
	call    _vid_get_cursor_position   		;c828	cd 08 c1    	... 
	mov     [ix-8],e                   		;c82b	dd 73 f8    	.s. 
	mov     [ix-7],d                   		;c82e	dd 72 f9    	.r. 
	ld      a,[ix-12]                  		;c831	dd 7e f4    	.~. 
	mov     [ix-14],a                  		;c834	dd 77 f2    	.w. 
	ld      a,[ix-11]                  		;c837	dd 7e f5    	.~. 
	mov     [ix-13],a                  		;c83a	dd 77 f3    	.w. 
	ld      a,[ix-1]                   		;c83d	dd 7e ff    	.~. 
	ora     [ix-2]                     		;c840	dd b6 fe    	... 
	jz      0c6fch                     		;c843	ca fc c6    	... 
	ld      a,[ix-2]                   		;c846	dd 7e fe    	.~. 
	add     [ix-12]                    		;c849	dd 86 f4    	... 
	mov     c,a                        		;c84c	4f          	O   
	ld      a,[ix-1]                   		;c84d	dd 7e ff    	.~. 
	adc     [ix-11]                    		;c850	dd 8e f5    	... 
	mov     b,a                        		;c853	47          	G   
	ld      a,[ix-6]                   		;c854	dd 7e fa    	.~. 
	stax    b                          		;c857	02          	.   
	jmp     0c6fch                     		;c858	c3 fc c6    	... 
	spix                               		;c85b	dd f9       	..  
	pop     x                          		;c85d	dd e1       	..  
	ret                                		;c85f	c9          	.   
	
;DE = param_x
;HL = param_y
;[SP+2..4] = param_n
;[SP+0..2] = return_address
_memcmp: ;x_de, y_hl, n_stack
	push    x                          		;c860	dd e5       	..  	protect IX
							;				(--SP)=IXH, (--SP)=IXL
							;				[SP+4..6] = param_n
							;				[SP+2..4] = return_address
							;				[SP+0..2] = IX
	lxi     x,00000h                   		;c862	dd 21 00 00 	.!..	IX=0000
	dadx    sp                         		;c866	dd 39       	.9  	IX=SP
							;				[IX+4..6] = param_n
							;				[IX+2..4] = return_address
							;				[IX+0..2] = IX
	push    psw                        		;c868	f5          	.   	(--SP)=A, (--SP)=F
							;				[SP+6..8] = param_n
							;				[SP+4..6] = return_address
							;				[SP+2..4] = IX
							;				[SP+0..2] = AF
	mov     c,l                        		;c869	4d          	M   	BC=param_y
	mov     b,h                        		;c86a	44          	D   	
	mov     l,[ix+4]                   		;c86b	dd 6e 04    	.n. 	HL=param_n
	mov     h,[ix+5]                   		;c86e	dd 66 05    	.f. 	
_memcmp_loop:
	inx     sp                         		;c871	33          	3   	SP += 2
	inx     sp                         		;c872	33          	3   	
	push    h                          		;c873	e5          	.   	tmp = param_n
							;				[SP+6..8] = param_n
							;				[SP+4..6] = return_address
							;				[SP+2..4] = IX
							;				[SP+0..2], [IX-1..3] = tmp
	dcx     h                          		;c874	2b          	+   	param_n--
	ld      a,[ix-1]                   		;c875	dd 7e ff    	.~. 	
	ora     [ix-2]                     		;c878	dd b6 fe    	... 	
	jrz     _memcmp_ret0               	;flow	;c87b	28 19       	(.  	if tmp == 0 goto _memcmp_ret0
	ldax    b                          		;c87d	0a          	.   	tmph=(param_y)-(param_x)
	push    psw                        		;c87e	f5          	.   	
	ldax    d                          		;c87f	1a          	.   	
	mov     [ix-1],a                   		;c880	dd 77 ff    	.w. 	
	pop     psw                        		;c883	f1          	.   	
	sub     [ix-1]                     		;c884	dd 96 ff    	... 	
	mov     [ix-1],a                   		;c887	dd 77 ff    	.w. 	
	ora     a                          		;c88a	b7          	.   	
	jrz     _memcmp_step               	;flow	;c88b	28 05       	(.  	if tmph == 0 goto _memcmp_step
	ld      a,[ix-1]                   		;c88d	dd 7e ff    	.~. 	a=tmph
	jr      _memcmp_ret                	;flow	;c890	18 05       	..  	goto _memcmp_ret

_memcmp_step:
	inx     b                          		;c892	03          	.   	param_y++
	inx     d                          		;c893	13          	.   	param_x++
	jr      _memcmp_loop               	;flow	;c894	18 db       	..  	goto _memcmp_loop

_memcmp_ret0:
	xra     a                          		;c896	af          	.   	A=0
_memcmp_ret:
	spix                               		;c897	dd f9       	..  	SP=IX
	pop     x                          		;c899	dd e1       	..  	restore IX
	pop     h                          		;c89b	e1          	.   	HL=return_address
	pop     b                          		;c89c	c1          	.   	BC=pop param_n off the stack
	pchl                               	;flow	;c89d	e9          	.   	return A

	rst     7                          		;c89e	ff          	.   
	rst     7                          		;c89f	ff          	.   
	rst     7                          		;c8a0	ff          	.   
	rst     7                          		;c8a1	ff          	.   
	rst     7                          		;c8a2	ff          	.   
	rst     7                          		;c8a3	ff          	.   
	rst     7                          		;c8a4	ff          	.   
	rst     7                          		;c8a5	ff          	.   
	rst     7                          		;c8a6	ff          	.   
	rst     7                          		;c8a7	ff          	.   
	rst     7                          		;c8a8	ff          	.   
	rst     7                          		;c8a9	ff          	.   
	rst     7                          		;c8aa	ff          	.   
	rst     7                          		;c8ab	ff          	.   
	rst     7                          		;c8ac	ff          	.   
	rst     7                          		;c8ad	ff          	.   
	rst     7                          		;c8ae	ff          	.   
	rst     7                          		;c8af	ff          	.   
	rst     7                          		;c8b0	ff          	.   
	rst     7                          		;c8b1	ff          	.   
	rst     7                          		;c8b2	ff          	.   
	rst     7                          		;c8b3	ff          	.   
	rst     7                          		;c8b4	ff          	.   
	rst     7                          		;c8b5	ff          	.   
	rst     7                          		;c8b6	ff          	.   
	rst     7                          		;c8b7	ff          	.   
	rst     7                          		;c8b8	ff          	.   
	rst     7                          		;c8b9	ff          	.   
	rst     7                          		;c8ba	ff          	.   
	rst     7                          		;c8bb	ff          	.   
	rst     7                          		;c8bc	ff          	.   
	rst     7                          		;c8bd	ff          	.   
	rst     7                          		;c8be	ff          	.   
	rst     7                          		;c8bf	ff          	.   
	rst     7                          		;c8c0	ff          	.   
	rst     7                          		;c8c1	ff          	.   
	rst     7                          		;c8c2	ff          	.   
	rst     7                          		;c8c3	ff          	.   
	rst     7                          		;c8c4	ff          	.   
	rst     7                          		;c8c5	ff          	.   
	rst     7                          		;c8c6	ff          	.   
	rst     7                          		;c8c7	ff          	.   
	rst     7                          		;c8c8	ff          	.   
	rst     7                          		;c8c9	ff          	.   
	rst     7                          		;c8ca	ff          	.   
	rst     7                          		;c8cb	ff          	.   
	rst     7                          		;c8cc	ff          	.   
	rst     7                          		;c8cd	ff          	.   
	rst     7                          		;c8ce	ff          	.   
	rst     7                          		;c8cf	ff          	.   
	rst     7                          		;c8d0	ff          	.   
	rst     7                          		;c8d1	ff          	.   
	rst     7                          		;c8d2	ff          	.   
	rst     7                          		;c8d3	ff          	.   
	rst     7                          		;c8d4	ff          	.   
	rst     7                          		;c8d5	ff          	.   
	rst     7                          		;c8d6	ff          	.   
	rst     7                          		;c8d7	ff          	.   
	rst     7                          		;c8d8	ff          	.   
	rst     7                          		;c8d9	ff          	.   
	rst     7                          		;c8da	ff          	.   
	rst     7                          		;c8db	ff          	.   
	rst     7                          		;c8dc	ff          	.   
	rst     7                          		;c8dd	ff          	.   
	rst     7                          		;c8de	ff          	.   
	rst     7                          		;c8df	ff          	.   
	rst     7                          		;c8e0	ff          	.   
	rst     7                          		;c8e1	ff          	.   
	rst     7                          		;c8e2	ff          	.   
	rst     7                          		;c8e3	ff          	.   
	rst     7                          		;c8e4	ff          	.   
	rst     7                          		;c8e5	ff          	.   
	rst     7                          		;c8e6	ff          	.   
	rst     7                          		;c8e7	ff          	.   
	rst     7                          		;c8e8	ff          	.   
	rst     7                          		;c8e9	ff          	.   
	rst     7                          		;c8ea	ff          	.   
	rst     7                          		;c8eb	ff          	.   
	rst     7                          		;c8ec	ff          	.   
	rst     7                          		;c8ed	ff          	.   
	rst     7                          		;c8ee	ff          	.   
	rst     7                          		;c8ef	ff          	.   
	rst     7                          		;c8f0	ff          	.   
	rst     7                          		;c8f1	ff          	.   
	rst     7                          		;c8f2	ff          	.   
	rst     7                          		;c8f3	ff          	.   
	rst     7                          		;c8f4	ff          	.   
	rst     7                          		;c8f5	ff          	.   
	rst     7                          		;c8f6	ff          	.   
	rst     7                          		;c8f7	ff          	.   
	rst     7                          		;c8f8	ff          	.   
	rst     7                          		;c8f9	ff          	.   
	rst     7                          		;c8fa	ff          	.   
	rst     7                          		;c8fb	ff          	.   
	rst     7                          		;c8fc	ff          	.   
	rst     7                          		;c8fd	ff          	.   
	rst     7                          		;c8fe	ff          	.   
	rst     7                          		;c8ff	ff          	.   
	rst     7                          		;c900	ff          	.   
	rst     7                          		;c901	ff          	.   
	rst     7                          		;c902	ff          	.   
	rst     7                          		;c903	ff          	.   
	rst     7                          		;c904	ff          	.   
	rst     7                          		;c905	ff          	.   
	rst     7                          		;c906	ff          	.   
	rst     7                          		;c907	ff          	.   
	rst     7                          		;c908	ff          	.   
	rst     7                          		;c909	ff          	.   
	rst     7                          		;c90a	ff          	.   
	rst     7                          		;c90b	ff          	.   
	rst     7                          		;c90c	ff          	.   
	rst     7                          		;c90d	ff          	.   
	rst     7                          		;c90e	ff          	.   
	rst     7                          		;c90f	ff          	.   
	rst     7                          		;c910	ff          	.   
	rst     7                          		;c911	ff          	.   
	rst     7                          		;c912	ff          	.   
	rst     7                          		;c913	ff          	.   
	rst     7                          		;c914	ff          	.   
	rst     7                          		;c915	ff          	.   
	rst     7                          		;c916	ff          	.   
	rst     7                          		;c917	ff          	.   
	rst     7                          		;c918	ff          	.   
	rst     7                          		;c919	ff          	.   
	rst     7                          		;c91a	ff          	.   
	rst     7                          		;c91b	ff          	.   
	rst     7                          		;c91c	ff          	.   
	rst     7                          		;c91d	ff          	.   
	rst     7                          		;c91e	ff          	.   
	rst     7                          		;c91f	ff          	.   
	rst     7                          		;c920	ff          	.   
	rst     7                          		;c921	ff          	.   
	rst     7                          		;c922	ff          	.   
	rst     7                          		;c923	ff          	.   
	rst     7                          		;c924	ff          	.   
	rst     7                          		;c925	ff          	.   
	rst     7                          		;c926	ff          	.   
	rst     7                          		;c927	ff          	.   
	rst     7                          		;c928	ff          	.   
	rst     7                          		;c929	ff          	.   
	rst     7                          		;c92a	ff          	.   
	rst     7                          		;c92b	ff          	.   
	rst     7                          		;c92c	ff          	.   
	rst     7                          		;c92d	ff          	.   
	rst     7                          		;c92e	ff          	.   
	rst     7                          		;c92f	ff          	.   
	rst     7                          		;c930	ff          	.   
	rst     7                          		;c931	ff          	.   
	rst     7                          		;c932	ff          	.   
	rst     7                          		;c933	ff          	.   
	rst     7                          		;c934	ff          	.   
	rst     7                          		;c935	ff          	.   
	rst     7                          		;c936	ff          	.   
	rst     7                          		;c937	ff          	.   
	rst     7                          		;c938	ff          	.   
	rst     7                          		;c939	ff          	.   
	rst     7                          		;c93a	ff          	.   
	rst     7                          		;c93b	ff          	.   
	rst     7                          		;c93c	ff          	.   
	rst     7                          		;c93d	ff          	.   
	rst     7                          		;c93e	ff          	.   
	rst     7                          		;c93f	ff          	.   
	rst     7                          		;c940	ff          	.   
	rst     7                          		;c941	ff          	.   
	rst     7                          		;c942	ff          	.   
	rst     7                          		;c943	ff          	.   
	rst     7                          		;c944	ff          	.   
	rst     7                          		;c945	ff          	.   
	rst     7                          		;c946	ff          	.   
	rst     7                          		;c947	ff          	.   
	rst     7                          		;c948	ff          	.   
	rst     7                          		;c949	ff          	.   
	rst     7                          		;c94a	ff          	.   
	rst     7                          		;c94b	ff          	.   
	rst     7                          		;c94c	ff          	.   
	rst     7                          		;c94d	ff          	.   
	rst     7                          		;c94e	ff          	.   
	rst     7                          		;c94f	ff          	.   
	rst     7                          		;c950	ff          	.   
	rst     7                          		;c951	ff          	.   
	rst     7                          		;c952	ff          	.   
	rst     7                          		;c953	ff          	.   
	rst     7                          		;c954	ff          	.   
	rst     7                          		;c955	ff          	.   
	rst     7                          		;c956	ff          	.   
	rst     7                          		;c957	ff          	.   
	rst     7                          		;c958	ff          	.   
	rst     7                          		;c959	ff          	.   
	rst     7                          		;c95a	ff          	.   
	rst     7                          		;c95b	ff          	.   
	rst     7                          		;c95c	ff          	.   
	rst     7                          		;c95d	ff          	.   
	rst     7                          		;c95e	ff          	.   
	rst     7                          		;c95f	ff          	.   
	rst     7                          		;c960	ff          	.   
	rst     7                          		;c961	ff          	.   
	rst     7                          		;c962	ff          	.   
	rst     7                          		;c963	ff          	.   
	rst     7                          		;c964	ff          	.   
	rst     7                          		;c965	ff          	.   
	rst     7                          		;c966	ff          	.   
	rst     7                          		;c967	ff          	.   
	rst     7                          		;c968	ff          	.   
	rst     7                          		;c969	ff          	.   
	rst     7                          		;c96a	ff          	.   
	rst     7                          		;c96b	ff          	.   
	rst     7                          		;c96c	ff          	.   
	rst     7                          		;c96d	ff          	.   
	rst     7                          		;c96e	ff          	.   
	rst     7                          		;c96f	ff          	.   
	rst     7                          		;c970	ff          	.   
	rst     7                          		;c971	ff          	.   
	rst     7                          		;c972	ff          	.   
	rst     7                          		;c973	ff          	.   
	rst     7                          		;c974	ff          	.   
	rst     7                          		;c975	ff          	.   
	rst     7                          		;c976	ff          	.   
	rst     7                          		;c977	ff          	.   
	rst     7                          		;c978	ff          	.   
	rst     7                          		;c979	ff          	.   
	rst     7                          		;c97a	ff          	.   
	rst     7                          		;c97b	ff          	.   
	rst     7                          		;c97c	ff          	.   
	rst     7                          		;c97d	ff          	.   
	rst     7                          		;c97e	ff          	.   
	rst     7                          		;c97f	ff          	.   
	rst     7                          		;c980	ff          	.   
	rst     7                          		;c981	ff          	.   
	rst     7                          		;c982	ff          	.   
	rst     7                          		;c983	ff          	.   
	rst     7                          		;c984	ff          	.   
	rst     7                          		;c985	ff          	.   
	rst     7                          		;c986	ff          	.   
	rst     7                          		;c987	ff          	.   
	rst     7                          		;c988	ff          	.   
	rst     7                          		;c989	ff          	.   
	rst     7                          		;c98a	ff          	.   
	rst     7                          		;c98b	ff          	.   
	rst     7                          		;c98c	ff          	.   
	rst     7                          		;c98d	ff          	.   
	rst     7                          		;c98e	ff          	.   
	rst     7                          		;c98f	ff          	.   
	rst     7                          		;c990	ff          	.   
	rst     7                          		;c991	ff          	.   
	rst     7                          		;c992	ff          	.   
	rst     7                          		;c993	ff          	.   
	rst     7                          		;c994	ff          	.   
	rst     7                          		;c995	ff          	.   
	rst     7                          		;c996	ff          	.   
	rst     7                          		;c997	ff          	.   
	rst     7                          		;c998	ff          	.   
	rst     7                          		;c999	ff          	.   
	rst     7                          		;c99a	ff          	.   
	rst     7                          		;c99b	ff          	.   
	rst     7                          		;c99c	ff          	.   
	rst     7                          		;c99d	ff          	.   
	rst     7                          		;c99e	ff          	.   
	rst     7                          		;c99f	ff          	.   
	rst     7                          		;c9a0	ff          	.   
	rst     7                          		;c9a1	ff          	.   
	rst     7                          		;c9a2	ff          	.   
	rst     7                          		;c9a3	ff          	.   
	rst     7                          		;c9a4	ff          	.   
	rst     7                          		;c9a5	ff          	.   
	rst     7                          		;c9a6	ff          	.   
	rst     7                          		;c9a7	ff          	.   
	rst     7                          		;c9a8	ff          	.   
	rst     7                          		;c9a9	ff          	.   
	rst     7                          		;c9aa	ff          	.   
	rst     7                          		;c9ab	ff          	.   
	rst     7                          		;c9ac	ff          	.   
	rst     7                          		;c9ad	ff          	.   
	rst     7                          		;c9ae	ff          	.   
	rst     7                          		;c9af	ff          	.   
	rst     7                          		;c9b0	ff          	.   
	rst     7                          		;c9b1	ff          	.   
	rst     7                          		;c9b2	ff          	.   
	rst     7                          		;c9b3	ff          	.   
	rst     7                          		;c9b4	ff          	.   
	rst     7                          		;c9b5	ff          	.   
	rst     7                          		;c9b6	ff          	.   
	rst     7                          		;c9b7	ff          	.   
	rst     7                          		;c9b8	ff          	.   
	rst     7                          		;c9b9	ff          	.   
	rst     7                          		;c9ba	ff          	.   
	rst     7                          		;c9bb	ff          	.   
	rst     7                          		;c9bc	ff          	.   
	rst     7                          		;c9bd	ff          	.   
	rst     7                          		;c9be	ff          	.   
	rst     7                          		;c9bf	ff          	.   
	rst     7                          		;c9c0	ff          	.   
	rst     7                          		;c9c1	ff          	.   
	rst     7                          		;c9c2	ff          	.   
	rst     7                          		;c9c3	ff          	.   
	rst     7                          		;c9c4	ff          	.   
	rst     7                          		;c9c5	ff          	.   
	rst     7                          		;c9c6	ff          	.   
	rst     7                          		;c9c7	ff          	.   
	rst     7                          		;c9c8	ff          	.   
	rst     7                          		;c9c9	ff          	.   
	rst     7                          		;c9ca	ff          	.   
	rst     7                          		;c9cb	ff          	.   
	rst     7                          		;c9cc	ff          	.   
	rst     7                          		;c9cd	ff          	.   
	rst     7                          		;c9ce	ff          	.   
	rst     7                          		;c9cf	ff          	.   
	rst     7                          		;c9d0	ff          	.   
	rst     7                          		;c9d1	ff          	.   
	rst     7                          		;c9d2	ff          	.   
	rst     7                          		;c9d3	ff          	.   
	rst     7                          		;c9d4	ff          	.   
	rst     7                          		;c9d5	ff          	.   
	rst     7                          		;c9d6	ff          	.   
	rst     7                          		;c9d7	ff          	.   
	rst     7                          		;c9d8	ff          	.   
	rst     7                          		;c9d9	ff          	.   
	rst     7                          		;c9da	ff          	.   
	rst     7                          		;c9db	ff          	.   
	rst     7                          		;c9dc	ff          	.   
	rst     7                          		;c9dd	ff          	.   
	rst     7                          		;c9de	ff          	.   
	rst     7                          		;c9df	ff          	.   
	rst     7                          		;c9e0	ff          	.   
	rst     7                          		;c9e1	ff          	.   
	rst     7                          		;c9e2	ff          	.   
	rst     7                          		;c9e3	ff          	.   
	rst     7                          		;c9e4	ff          	.   
	rst     7                          		;c9e5	ff          	.   
	rst     7                          		;c9e6	ff          	.   
	rst     7                          		;c9e7	ff          	.   
	rst     7                          		;c9e8	ff          	.   
	rst     7                          		;c9e9	ff          	.   
	rst     7                          		;c9ea	ff          	.   
	rst     7                          		;c9eb	ff          	.   
	rst     7                          		;c9ec	ff          	.   
	rst     7                          		;c9ed	ff          	.   
	rst     7                          		;c9ee	ff          	.   
	rst     7                          		;c9ef	ff          	.   
	rst     7                          		;c9f0	ff          	.   
	rst     7                          		;c9f1	ff          	.   
	rst     7                          		;c9f2	ff          	.   
	rst     7                          		;c9f3	ff          	.   
	rst     7                          		;c9f4	ff          	.   
	rst     7                          		;c9f5	ff          	.   
	rst     7                          		;c9f6	ff          	.   
	rst     7                          		;c9f7	ff          	.   
	rst     7                          		;c9f8	ff          	.   
	rst     7                          		;c9f9	ff          	.   
	rst     7                          		;c9fa	ff          	.   
	rst     7                          		;c9fb	ff          	.   
	rst     7                          		;c9fc	ff          	.   
	rst     7                          		;c9fd	ff          	.   
	rst     7                          		;c9fe	ff          	.   
	rst     7                          		;c9ff	ff          	.   
	rst     7                          		;ca00	ff          	.   
	rst     7                          		;ca01	ff          	.   
	rst     7                          		;ca02	ff          	.   
	rst     7                          		;ca03	ff          	.   
	rst     7                          		;ca04	ff          	.   
	rst     7                          		;ca05	ff          	.   
	rst     7                          		;ca06	ff          	.   
	rst     7                          		;ca07	ff          	.   
	rst     7                          		;ca08	ff          	.   
	rst     7                          		;ca09	ff          	.   
	rst     7                          		;ca0a	ff          	.   
	rst     7                          		;ca0b	ff          	.   
	rst     7                          		;ca0c	ff          	.   
	rst     7                          		;ca0d	ff          	.   
	rst     7                          		;ca0e	ff          	.   
	rst     7                          		;ca0f	ff          	.   
	rst     7                          		;ca10	ff          	.   
	rst     7                          		;ca11	ff          	.   
	rst     7                          		;ca12	ff          	.   
	rst     7                          		;ca13	ff          	.   
	rst     7                          		;ca14	ff          	.   
	rst     7                          		;ca15	ff          	.   
	rst     7                          		;ca16	ff          	.   
	rst     7                          		;ca17	ff          	.   
	rst     7                          		;ca18	ff          	.   
	rst     7                          		;ca19	ff          	.   
	rst     7                          		;ca1a	ff          	.   
	rst     7                          		;ca1b	ff          	.   
	rst     7                          		;ca1c	ff          	.   
	rst     7                          		;ca1d	ff          	.   
	rst     7                          		;ca1e	ff          	.   
	rst     7                          		;ca1f	ff          	.   
	rst     7                          		;ca20	ff          	.   
	rst     7                          		;ca21	ff          	.   
	rst     7                          		;ca22	ff          	.   
	rst     7                          		;ca23	ff          	.   

; vim: ft=i8080
