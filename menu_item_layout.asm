; ########################################################################################
; # Generated by the active disassembly feature of the Exodus emulation platform
; #
; # Description: item menu layout subroutines
; # Creation Date:   2020-12-31 18:39:43
; # Analysis Region: 0x0000A000 - 0x0000B000
; ########################################################################################

; PC $84BE sets some initial values from RAM at $FF32C8, jumping to $a21c

PartyList	equ	$00FFCED6	; used for getting selected party member, whose inventory will be displayed
PlayerRAMOffset	equ	$00FFCEDC	; start of player data block in RAM
Stack	equr	a7 
 
; org $0000
; incbin "foobar.bin"

 org $a1f2

get_player_ram_offset:
	MOVE.l	D0, -(Stack)
	LEA	PlayerRAMOffset, A0
	MOVEQ	#$00000012, D0
loop_for_current_player:
	TST.b	(A0)	; first byte of player id might be $00 if dead or something?
	BEQ.b	player_dead	
	CMP.b	(A0), D2	; d2 has selected player id
	BEQ.b	found_player_offset
player_dead:
	ADDA.w	#$0050, A0	; party member data is $50 bytes so increment by $50 until match found
	DBF	D0, loop_for_current_player	;Predicted (Code-scan)
	CLR.w	D0	;Predicted (Code-scan)
	MOVEM.l	(Stack)+, D0	;Predicted (Code-scan)
	RTS	;Predicted (Code-scan)
found_player_offset:
	MOVEQ	#1, D0
	MOVEM.l	(Stack)+, D0	; one d0 value was $b
	RTS		; $a4bc
	
start_item_writing:
	MOVE.l	A0, -(Stack)	; put previous string pointer on stack (the use/give/drop submenu, for example)
	EXT.w	D2	; d2 was loaded from RAM $ff32ce , around PC $84BE, has selected party member index
	LEA	PartyList, A0	
	MOVE.b	(A0,D2.w), D2	; this put $01 in D2, selected party member's ID
	MOVEA.l	(Stack)+, A0	; puts old string pointer back in a0
	RTS		; returns to $84DA sometimes. sets d0 = $b, d1 = $e, then branch to $a4b4
	
 org $a384
menu_draw_setup:
	MOVEM.l	A0/D7/D5/D4/D3/D2/D1/D0, -(Stack)	
	MOVE.w	D2, D5	
	MOVE.w	D3, D7	; d2 and d3 were set to $1 previously...
	MOVEQ	#5, D4	; number of loops / rows of items
	CLR.w	D6
	CLR.w	D3
	
start_drawing_row:

	;LEA	blank_spaces_x9(PC), A0	; contains a string of 9 $3F bytes, empty spaces, to blank areas before writing to it
	;BSR.w	write_label_8x8	; $3628 , checks for linebreak / dakutens.. 
			; branch to $367c if null byte, $3652 for either dakuten, $3664 if not <br>, 
			; then $1dee to print to vdp. going into $1dee, d1 is y offset, d0 is x offset probably
	NOP
	NOP
	NOP
	NOP
	NOP
	TST.w	D7	; d7 was 1
	BNE.b	store_item_id_leftside
	CLR.w	D2	;Predicted (Code-scan)
	MOVE.b	(A1,D3.w), D2	;Predicted (Code-scan)
	BRA.b	check_equipped_leftside	;Predicted (Code-scan)
	
store_item_id_leftside:
	MOVE.w	(A1,D3.w), D2	; d3 is item index, gets item id into d2
	
check_equipped_leftside:
	BEQ.b	no_more_items_leftside	; if no more items maybe?
	MOVE.l	D2, -(Stack)	; item id to stack
	BTST.l	#$0F, D2	; check if item currently equipped ($80xx)
	BEQ.b	item_not_equipped_leftside	
	MOVE.w	#$E56F, D2	; $E56F is small E for "equipped" items
	BRA.b	draw_e_or_not_leftside
item_not_equipped_leftside:
	MOVE.w	#$E52F, D2	; $E52F is vram offset for empty space
	
draw_e_or_not_leftside:
	MOVEA.w	#$C000, A0
	JSR	write_to_vdp	; $1dee draws to vdp
	MOVE.l	(Stack)+, D2	
	ADDQ.w	#1, D0	; increment x offset
	BSR.w	get_item_offset	
	BSR.w	write_label_8x8	; $3628 again, this time with $c and $e as x and y (d0, d1)
			; and writing item name instead of spaces!
	;ADDQ.w	#8, D0	; move over for second column, maybe?
	ADDQ.w	#1, d1	; go down instead of over
	ADDQ.w	#1, D6	; printed item counter maybe?
	ADDQ.w	#1, D3	; ?? both these went from $0 to $1, adding d3 to a1 gets next item in RAM
	ADD.w	D7, D3	; new d3 == $2 after first item printed, d3 is $6 after the third item printed ..
	BRA.b	draw_rightside
no_more_items_leftside:
	; ADDI.w	#9, D0
	ADDQ.w	#1, D3
	ADD.w	D7, D3
	
draw_rightside:
	TST.w	D5
	BEQ.b	back_to_leftside
	; LEA	blank_spaces_x9(PC), A0
	; BSR.w	write_label_8x8	
	
	NOP
	NOP
	NOP
	NOP
	SUBQ.w	#1, d0	; scoot back after the "e" offset
	
	TST.w	D7	; seems to be $01 all the time?
	BNE.b	loc_0000A3FE
	CLR.w	D2	;Predicted (Code-scan)
	MOVE.b	(A1,D3.w), D2	;Predicted (Code-scan)
	BRA.b	loc_0000A402	;Predicted (Code-scan)
	
loc_0000A3FE:
	MOVE.w	(A1,D3.w), D2	; puts new item id in d2
	
loc_0000A402:
	BEQ.b	no_more_items	; maybe different for left/right columns??
	MOVE.l	D2, -(Stack)
	BTST.l	#$0F, D2	; check if item currently equipped ($80xx)
	BEQ.b	not_equipped_rightside
	MOVE.w	#$E56F, D2	; vram offset for 'E' equipped mark
	BRA.b	loc_0000A416
not_equipped_rightside:
	MOVE.w	#$E52F, D2	;Predicted (Code-scan)
loc_0000A416:
	MOVEA.w	#$C000, A0
	JSR	write_to_vdp
	MOVE.l	(Stack)+, D2	; gets item id back into d2
	ADDQ.w	#1, D0	; increment x offset
	BSR.w	get_item_offset
	BSR.w	write_label_8x8
	;SUBI.w	#$000A, D0	; x offset had gone up to $15, drop back to $b
	;NOP
	ADDQ.w	#1, D1	; go down two rows (one for dakuten, one for next row of items)
	ADDQ.w	#1, D6	; item counter or..?
	ADDQ.w	#1, D3
	ADD.w	D7, D3
	SUBI.w	#1, D0
	BRA.b	loop_print_rows
no_more_items:
	ADDQ.w	#1, D3
	ADD.w	D7, D3
back_to_leftside:
	 SUBI.w	#1, D0
	; ADDQ.w	#2, D1

	;NOP
	;ADDQ.w	#1,	d1
loop_print_rows:
	DBF	D4, start_drawing_row	; d4 was set to 5 a very long time ago ... 6 rows of items? probably
	MOVEM.l	(Stack)+, D0/D1/D2/D3/D4/D5/D7/A0
	RTS
	
	
blank_spaces_x9:
	WHILE *<$a458
		dc.b $3f
	ENDW
;	dc.b	$3F ;0x0 (0x0000A44E-0x0000A44F, Entry count: 0x1)
;	dc.b	$3F, $3F, $3F, $3F, $3F, $3F, $3F, $3F, $00 ;0x0 (0x0000A44F-0x0000A458, Entry count: 0x9)

; org $a450
;get_item_offset:
; bsr new_item_offset
; rts
 
 org $a458
 ;org $68000
get_item_offset:
	MOVE.l	D2, -(Stack)	; item id to stack
	LEA	$000130C6, A0	; item data base offset
	;LEA	$000f000e, A0	; item data base offset
	ANDI.w	#$00FF, D2	; mask out rental / equip status of item
	SUBQ.w	#1, D2	
	MULU.w	#$0020, D2	; each item block is $20 bytes of data
	;MULU.w	#$0010, D2	
	ADDA.l	D2, A0	; gets offset of current item name
	MOVE.l	(Stack)+, D2	
	RTS		; $a3d0
	
	
	
 org $a4b4
start_drawing_item_window:
	MOVEM.l	A1/A0, -(Stack)
	BSR.w	get_player_ram_offset	
	MOVEA.l	A0, A1	; copy player ram offset to a1
	ADDA.w	#$001A, A1	; list of inventory items starts $1a after player data block start
	MOVEQ	#1, D2
	MOVEQ	#1, D3
	BSR.w	menu_draw_setup
	TST.w	D6
	BNE.b	setup_item_window
	BSR.w	mystery_label	;Predicted (Code-scan)
	;ADDQ.w	#1, D0	;Predicted (Code-scan)
	NOP
	BSR.w	write_label_8x8	;Predicted (Code-scan)
	
setup_item_window:
	MOVEQ	#$e, D2	; highlight width
	MOVEQ	#0,  D3	; highlight height
	MOVEQ	#1,  D4	; column count
	MOVEQ	#$b, D5	; row count
	SUBQ.w	#1,  D6	; ???
	MOVEM.l	(Stack)+, A0/A1
	RTS


 org $3628
write_label_8x8:
	MOVEM.l	A1/A0/D3/D2/D1/D0, -(A7)
	MOVEA.l	A0, A1
	MOVEA.w	#$C000, A0
	MOVE.w	D0, D3
loc_00003634:
	CLR.w	D2
	MOVE.b	(A1)+, D2
	BEQ.b	loc_0000367C
	CMPI.b	#$7B, D2
	BEQ.b	loc_00003652
	CMPI.b	#$7C, D2
	BEQ.b	loc_00003652
	CMPI.b	#$0D, D2
	BNE.b	loc_00003664
	ADDQ.w	#1, D1	; single space, not double, affects choose name menu, maybe others?
	MOVE.w	D3, D0	;Predicted (Code-scan)
	BRA.b	loc_00003634	;Predicted (Code-scan)
loc_00003652:
	SUBQ.w	#1, D0	;Predicted (Code-scan)
	SUBQ.w	#1, D1	;Predicted (Code-scan)
	ADDI.w	#$E4F0, D2	;Predicted (Code-scan)
	BSR.w	write_to_vdp	;Predicted (Code-scan)
	ADDQ.w	#1, D0	;Predicted (Code-scan)
	ADDQ.w	#1, D1	;Predicted (Code-scan)
	BRA.b	loc_00003634	;Predicted (Code-scan)
loc_00003664:
	ADDI.w	#$E4F0, D2
	BSR.w	write_to_vdp
	;SUBQ.w	#1, D1
	;MOVE.w	#$E52F, D2
	;BSR.w	write_to_vdp
	;ADDQ.w	#1, D1
	ADDQ.w	#1, D0
	BRA.b	loc_00003634
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP

 org $367c
loc_0000367C:
	MOVEM.l	(A7)+, D0/D1/D2/D3/A0/A1
	RTS

 org $32d6
draw_background_window:

 org $3734
draw_price:

 org $3682
draw_G_after_price:

 org $34ba
	NOP	; this was double incrementing row offset, but i don't want to skip rows so NOP

; ########################################################################################
;	item shop window hack - print on every row instead of every other row
; ########################################################################################

 ;org $00005C90	; item shop subroutine
 org $00005C80
	moveq #$0A, d0	; left-padding
	moveq #$2, d1	; top padding
	moveq #$13, d2	; width - increased from 11 to 13
	moveq #$e, d3	; height
	moveq #$43, d4
	bsr.w	draw_background_window

item_shop_subroutine:
	MOVE.w	D0, $6(A3)
	CLR.w	$8(A3)
	
item_shop_insertion_point:
	CLR.w	D6
	CLR.w	D5
	MOVEQ	#4, D1
loc_00005C9E:
	MOVE.w	(A4,D5.w), D2
	BEQ.w	loc_00005CD6
	MOVEQ	#$0000000B, D0
	BSR.w	get_item_offset
	BSR.w	write_label_8x8
	MOVEQ	#$00000016, D0 ; probably x offset of price?
	CLR.l	D2
	MOVE.w	$2(A4,D5.w), D2
	BNE.b	loc_00005CBE
	MOVE.w	$1E(A0), D2
loc_00005CBE:
	MOVEQ	#5, D3
	ADDQ.w	#1, D1	; i changed this to 1 instead of 2 so it wouldn't leave empty rows
	BSR.w	draw_price
	addq #5, D0 ; price seems to be 5 digits
	;LEA	*+$6024, A0
	LEA	$6024.w, a0	; hopefully my assembler translates this correctly
	
	BSR.w	draw_G_after_price
	ADDQ.w	#1, D1	; i changed this to 1 instead of 2 so it wouldn't leave empty rows
	ADDQ.w	#1, D6
	ADDQ.w	#4, D5
	BRA.b	loc_00005C9E
loc_00005CD6:
	SUBQ.w	#1, D6
	MOVEQ	#$0000000B, D0	
	MOVEQ	#4, D1	
	MOVEQ	#$10, D2	; highlight width
	MOVEQ	#1, D3
	MOVEQ	#1, D4
	MOVEQ	#6, D5
	MOVE.w	$8(A3), D7
	;BSR.w	*+$D63E	; goes to $3328
	BSR.w	$3328	; goes to $3328

; item shop "give to npc" window
 org $00005D46

give_to_npc_window:
; setting window parameters
	MOVEQ	#$0000001d, D0	; x offset to draw window
	MOVEQ	#2, D1	; y offset
	MOVEQ	#8, D2	; width
	MOVEQ	#$0000000E, D3	; height
	MOVE.w	#$0043, D4	; palette , not sure exactly how to set it...
	BSR.w	draw_background_window
	MOVE.w	D0, $C(A3)
	CLR.w	$E(A3)
	
	; setting text list position
	MOVEQ	#$0000001e, D0	
	MOVEQ	#4, D1	
	MOVEQ	#1, D2	
	BSR.w	$a22e	; no idea
	MOVE.w	$E(A3), D7
	BSR.w	$3328




 org $5e6a
	bra.w item_shop_insertion_point
	
	
	
	
	
; ########################################################################################
; rental shop window hack - print every row instead of every other row
;	full routine $6d88 - $6dfc, bsr to $3328
; ########################################################################################
  org $00006D88
  
; window positioning things..
	MOVEQ	#$0000000A, D0	; x offset
	MOVEQ	#2, D1	; y offset
	MOVEQ	#$00000013, D2	; window width, bumped it to 11 to match item shop
	MOVEQ	#$0000000E, D3 ; window height probably
	MOVE.w	#$00C3, D4	
	;MOVEQ 	#$43, d4	; need to save 2 bytes to squeeze in addq below
	BSR.w	draw_background_window	; draws window background
	MOVE.w	D0, $4(A3)
	CLR.w	$12(A3)
	CLR.w	D5
	TST.w	$10(A3)
	BEQ.b	loc_00006DAA
	MOVEQ	#$00000010, D5
loc_00006DAA:
	CLR.w	D6
	MOVEQ	#4, D1
loc_00006DAE:
	MOVE.w	(A4,D5.w), D2
	BEQ.w	loc_00006DEA
	MOVEQ	#$0000000B, D0
	BSR.w	get_item_offset
	BSR.w	write_label_8x8	
	BSR.w	$a470	; gets price $1E(item offset)? $2710
	MOVE.l	D0, D2
	MULU.w	#$000C, D2	
	LSR.l	#8, D2	; converted $2710 to $1d4 - rental price?
	;BNE.b	loc_00006DD0
	;MOVEQ	#1, D2	; price should never be 0 anyway right
	NOP
loc_00006DD0:
	MOVEQ	#$00000017, D0	; x offset of price probably
	MOVEQ	#4, D3	; oh maybe this is digit padding
	addq.w	 #1, d1	; draw price on second line
	BSR.w	draw_price
	addq	#$4, D0	; maybe the max rental price is only 4 digits
	LEA	$6024.w, A0
	BSR.w	draw_G_after_price
	ADDQ.w	#1, D1	; row incrementer
	ADDQ.w	#1, D6
	ADDQ.w	#2, D5
	BRA.b	loc_00006DAE
loc_00006DEA:
	SUBQ.w	#1, D6
	MOVEQ	#$0000000B, D0
	MOVEQ	#4, D1
	MOVEQ	#$10, D2	; highlight width
	MOVEQ	#1, D3	; highlight height (0 is 1 tile)
	MOVEQ	#1, D4
	MOVEQ	#6, D5
	MOVE.w	$12(A3), D7
	BSR.w	$3328

; rental shop "hand to x" menu window
  org $00006E44
; keep this aligned with above window...
	MOVEQ	#$0000001d, D0
	MOVEQ	#2, D1
	MOVEQ	#8, D2
	MOVEQ	#$0000000E, D3
	MOVE.w	#$0043, D4
	BSR.w	draw_background_window
	MOVE.w	D0, $6(A3)	; these a3 offsets are different from the item shop routine...
	CLR.w	$16(A3)
	
	MOVEQ	#$0000001e, D0
	MOVEQ	#4, D1
	MOVEQ	#1, D2
	BSR.w	$a22e
	MOVE.w	$16(A3), D7
	BSR.w	$3328

; ########################################################################################
; equipment menu adjustments (moving atk/def window, spacing)
;
; ########################################################################################

 org $3778
draw_stat_value:

 org $87f6
draw_equipped_item:

 org $00008856
	WHILE *<$8950
		NOP
	ENDW
 org $00008856
draw_equipment_backgrounds:
	MOVEQ	#$0000000A, D0	; x offset for current equipment
	MOVEQ	#2, D1        	; y offset
	MOVEQ	#$0000001C, D2	; width 
	MOVEQ	#$0000000A, D3	; height
	MOVE.w	#$0043, D4	; palette info maybe?
	BSR.w	draw_background_window	; the currently equipped item window
 org $8866
	MOVE.w	D0, $4(A6)

; this could all be nopped out really
			; using equipment window, no longer need a separate one.. unless i show all stats! spd/vit etc
	
	MOVEQ	#$0000000A, D0
	MOVEQ	#$0000000C, D1
	MOVEQ	#$0000001c, D2
	MOVEQ	#$0000000E, D3
	MOVE.w	#$0043, D4
	BSR.w	draw_background_window	; draw item window
	MOVE.w	D0, $6(A6)	; this might have something to do with destroying the window later?

	MOVEQ	#$0000001e, D0	; same as above, but for atk/def smaller window
	MOVEQ	#$c, D1	
	MOVEQ	#$00000008, D2	
	MOVEQ	#$e, D3	
	MOVEQ	#$3, D4	
	BSR.w	$2fec	; draw smaller atk/def window
	; this window wasn't disappearing so i stacked it on top of the other one...
	MOVE.w	A1, $4(A5)
	CLR.w	$6(A5)
 org $8894
	MOVEA.w	$4(A5), A1
	MOVEQ	#$0000000B, D0	; x offset for text
	MOVEQ	#3, D1	; y offset

 org $889c
	LEA	$FFFF87C8.w, A0	; this line will be automatically overwritten by my python script..
	BSR.w	write_label_8x8	; writes wpn/arm/hlm etc
	
	MOVEQ	#$0000000b, D0	; reposition for "item" label
	addQ	#4, D1	; draw under the wpn/arm etc
	LEA	$FFFF87DE.w, A0	; another automated python line...
	BSR.w	write_label_8x8
	
	MOVEQ	#$0000000b, D0	; offsets for atk/def text
	MOVEQ	#$9, D1	
	LEA	$FFFF87E4.w, A0	
	BSR.w	write_label_8x16	; different string writing subroutine
	MOVE.w	$2(A5), D2
	BSR.w	start_item_writing
	BSR.w	get_player_ram_offset
	MOVEA.l	A0, A2
	MOVE.b	$14(A2), D2
	MOVEQ	#$00000013, D0	; position for weapon
	MOVEQ	#3, D1	
	BSR.w	draw_equipped_item	; weap
	MOVE.b	$15(A2), D2	; loading equipped gear into d2
	MOVEQ	#$00000013, D0	; could maybe delete this unless d0 gets messed up by the drawing sr
	addq	#1, D1	; increment by 1 instead of 2!
	BSR.w	draw_equipped_item	; armor
	MOVE.b	$16(A2), D2	
	MOVEQ	#$00000013, D0	
	addq	#1, D1
	BSR.w	draw_equipped_item	; helmet
	MOVE.b	$17(A2), D2
	MOVEQ	#$00000013, D0
	addq	#1, D1
	BSR.w	draw_equipped_item	; shield
	MOVE.b	$18(A2), D2	
	MOVEQ	#$00000013, D0	; x offset for equipped item
	addq	#1, D1
	BSR.w	draw_equipped_item	; item
	CLR.l	D2
	MOVE.w	$A(A2), D2	; get atk stat into d2
	;CMPI.w	#$03E8, D2	; compare to 1k
	;CMPI.w	#$2710, D2	; compare to 10k :D
	;BCS.b	loc_00008916
	;MOVE.w	#$270f, D2	; cap display at 9999 

loc_00008916:
	MOVEQ	#4, D3	; digit padding? in VRAM, space to reserve
	MOVEQ	#$00000013, D0	; x offset
	MOVEQ	#$9, D1	; y offset
	BSR.w	draw_stat_value	; draw atk/def number
	CLR.l	D2	
	jsr draw_substats
	
	MOVE.w	$C(A2), D2	; same as above but for defense
	;CMPI.w	#$03E8, D2
	
 org $8926
	CMPI.w	#$2710, D2	; compare to 10k :D
	BCS.b	loc_00008930
	MOVE.w	#$270f, D2	; set at 9999
loc_00008930:
	MOVEQ	#4, D3
	MOVEQ	#$00000021, D0
	MOVEQ	#$9, D1
	BSR.w	draw_stat_value
	MOVE.w	$2(A5), D2
	BSR.w	start_item_writing	; item writing routine
	MOVEQ	#$0000000B, D0	; maybe highlight parameters?
	MOVEQ	#$0000000E, D1	
	BSR.w	start_drawing_item_window	; draw items
	ADDQ.w	#1, D0
	MOVE.w	$6(A5), D7	
	BSR.w	$3328	; maybe branch to idle / highlighting,this is at pc $8950, might be important for spacing?
	
	

; ########################################################################################
; # Full page stat screen!!
; # layout adjustments to avoid abbreviations
; #
; # Generated by the active disassembly feature of the Exodus emulation platform
; # Creation Date:   2021-1-2 10:22:43
; # Analysis Region: 0x00009002 - 0x000091C4
; ########################################################################################

 org $00009002
 	WHILE *<$91c4 ; blank whole section so old code isn't leftover
		NOP
	ENDW
 org $00009002

x_tile_offset	equr	d0	; most drawing routines use d0 as left padding
y_tile_offset	equr	d1	; same but for y offset from top
value_to_write	equr	d2	; stat value to write
player_ram_offset	equr	a4	; starting with $ffcedc, incrementing $50ish? for each subsequent party member

	MOVEQ	#$0000000B, x_tile_offset	; x offset
	MOVEQ	#3, D1
	;BSR.w	*+$A6B6
	BSR.w	$36be	; draw npc name
	LEA	$FFFF9254.w, A0	; gets lvl/xp labels
	MOVEQ	#$0000000B, x_tile_offset	
	MOVEQ	#5, D1
	BSR.w	write_label_8x16	; draws lvl/xp labels
	CLR.l	D2
	MOVE.b	$E(A4), D2	; lvl value
	MOVEQ	#$00000011, x_tile_offset	
	MOVEQ	#5, y_tile_offset
	MOVEQ	#2, D3	; was 0?
	BSR.w	draw_stat_value	
	MOVE.l	$32(A4), D2	; exp value
	MOVEQ	#$00000019, x_tile_offset
	MOVEQ	#5, y_tile_offset
	MOVEQ	#0, D3
	BSR.w	draw_stat_value
	MOVEQ	#$00000015, x_tile_offset
	MOVEQ	#5, y_tile_offset
	TST.w	$2(A4)	; check if hp is 0
	BNE.b	not_dead	
	LEA	$FFFF9294.w, A0	; dead string
	BSR.w	write_label_8x16	;Predicted (Code-scan)
	BRA.b	not_poisoned	;Predicted (Code-scan)

; $9048 , checks status effects
not_dead:
	MOVE.b	$19(A4), D4	; status effects?
	BTST.l	#2, D4
	BEQ.b	not_petrified
	LEA	$FFFF929A.w, A0	; petrifed string
	BSR.w	write_label_8x16	;Predicted (Code-scan)
	ADDQ.w	#5, D0	;Predicted (Code-scan)
	BRA.b	not_paralyzed	;Predicted (Code-scan)
	
not_petrified:
	BTST.l	#1, D4
	BEQ.b	not_paralyzed
	LEA	$FFFF92A0.w, A0	; paralyzed string
	BSR.w	write_label_8x16	;
	ADDQ.w	#5, D0	;
not_paralyzed:
	BTST.l	#0, D4
	BEQ.b	not_poisoned
	LEA	$FFFF92A4.w, A0	; poisoned string
	BSR.w	write_label_8x16	;Predicted (Code-scan)
	
; finished stat checks, start with hp/mp
not_poisoned:
	LEA	$FFFF925C.w, A0	; hp / mp labels
	MOVEQ	#$4, x_tile_offset
	MOVEQ	#$0000000a, y_tile_offset
	BSR.w	write_label_8x16	
	LEA	$FFFF9262.w, A0	; slashes between current and max hp (23 / 50)
	MOVEQ	#$0000000b, x_tile_offset
	MOVEQ	#$0000000a, y_tile_offset
	BSR.w	write_label_8x16
	CLR.l	D2
	
	MOVE.w	$2(A4), D2	; current hp
	MOVEQ	#0, D3	; i think this is digit padding? bumped to 4... doesn't seem to do anything tbh
	jsr	small_number_indenter
	;moveq	#$7, x_tile_offset
	MOVEQ	#$a, y_tile_offset
	BSR.w	draw_stat_value
	CLR.l	D2	; this probably isn't necessary? current hp can't exceed max hp
	MOVE.w	$4(A4), D2	; max hp
	MOVEQ	#$c, x_tile_offset
	BSR.w	draw_stat_value	; draw max hp
	
	CLR.l	D2
	MOVE.w	$6(A4), D2	; current mp
	;MOVEQ	#4, D3
	jsr small_number_indenter
	MOVEQ	#$c, y_tile_offset
	BSR.w	draw_stat_value	
	CLR.l	D2	
	MOVE.w	$8(A4), D2	; max mp
	MOVEQ	#$c, x_tile_offset
	BSR.w	draw_stat_value
	
 org $90d4
	; this might need an org or something
	LEA	$FFFF9266.w, A0	; strings for stat labels (str, vit, etc)
	MOVEQ	#3, x_tile_offset
	MOVEQ	#$12, y_tile_offset
	BSR.w	write_label_8x16
	
	CLR.l	D2
	MOVE.b	$F(A4), D2	; str value
	MOVEQ	#3, D3
	MOVEQ	#$0000000d, x_tile_offset	; set x offset for str / int stat values
	;MOVEQ	#$0000000f, y_tile_offset
	BSR.w	draw_stat_value
	CLR.l	D2
	MOVE.b	$10(A4), D2	; intelligence value
	addq	#2, y_tile_offset
	BSR.w	draw_stat_value
	CLR.l	D2
	MOVE.b	$11(A4), D2	; vitality
	addq	#2, y_tile_offset
	BSR.w	draw_stat_value
	CLR.l	D2
	MOVE.b	$12(A4), D2	; speed
	addq	#2, y_tile_offset
	BSR.w	draw_stat_value
	
	; lots of blank space here..
	jsr get_xp_to_next_level
	
 org $9120 ; need this for lea string redirect
	LEA	$FFFF87E4.w, A0	; atk / def labels
	MOVEQ	#$00000003, x_tile_offset	
	MOVEQ	#$0000000e, y_tile_offset
	BSR.w	write_label_8x16
	CLR.l	D2
	
	MOVE.w	$A(A4), D2	; atk stat
	;CMPI.w	#$03E8, D2	; check for > 1k
	;BCS.b	draw_atk_value
	;MOVE.w	#$03E7, D2	; cap atk display at 999
draw_atk_value:
	MOVEQ	#3, D3
	MOVEQ	#$0000000d, x_tile_offset
	;MOVEQ	#$0000000f, y_tile_offset
	BSR.w	draw_stat_value
	CLR.l	D2
	MOVE.w	$C(A4), D2	; def stat
	;CMPI.w	#$03E8, D2	; check for > 1k
	;BCS.b	draw_def_value
	;MOVE.w	#$03E7, D2	; cap def display at 999
draw_def_value:
	addq	#2, y_tile_offset
	BSR.w	draw_stat_value


draw_gear_labels:	
 org $9160 ; a lea string points here :/
	LEA	$FFFF927C.w, A0	; gear labels (wpn, helm, etc)
	MOVEQ	#$00000013, x_tile_offset
	MOVEQ	#$0000000a, y_tile_offset
	BSR.w	write_label_8x8

	MOVEQ	#$00000014, x_tile_offset	;
	MOVEQ	#$0000000b, y_tile_offset	
	
	MOVE.b	$14(A4), D2	; currently equipped weapon
	jsr	write_equipment_8x16	
	addq	#$1, d1
	MOVE.b	$15(A4), D2	; equipped armor
	jsr	write_equipment_8x16	
	MOVE.b	$16(A4), D2	; equipped helm
	jsr	write_equipment_8x16	
	MOVE.b	$17(A4), D2	; equipped shield
	jsr	write_equipment_8x16	
	MOVE.b	$18(A4), D2	; equipped item
	jsr	write_equipment_8x16	
	
	MOVE.l	$00FFD5D6, D2	; gold amount
	MOVEQ	#7, D3
	MOVEQ	#$0000001d, x_tile_offset
	MOVEQ	#1, y_tile_offset
;	jsr small_number_indenter ; this overwrites important stuff :/
	BSR.w	draw_stat_value	

 org $91b8	; needed for lea string
 
	LEA	$FFFF927A.w, A0	; 'G' for gold label
	MOVEQ	#$00000025, x_tile_offset
	MOVEQ	#1, y_tile_offset
	BSR.w	write_label_8x16

 org $91c4
	TRAP	#5

 org $68800
write_equipment_8x16:
	beq increment_row_counter
	jsr	get_item_offset
	jsr write_label_8x16
increment_row_counter:
	addq	#$3, y_tile_offset	; go down two for 8x16 tiles
	rts
	
 org $68880
current_value	equr	d2
small_number_indenter:
	MOVEQ	#$7, x_tile_offset
	CMP	#10, current_value ; this blanks out the slash for some reason.
	bcc	*+6
	addq	#1, x_tile_offset	
	CMP	#100, current_value
	bcc	*+6
	addq	#1, x_tile_offset
	CMP	#1000, current_value
	bcc	*+6
	addq	#1, x_tile_offset
	rts

; ########################################################################################
; # fully original asm!! display "experience to next level"
; # 
; #
; ########################################################################################
 org $68900	
get_xp_to_next_level:
	MOVE.w	$4A(A4), D2	; get player level up table!
	LSL.l	#2, D2	; level table pointers are stored as longs so * 4
	LEA	$0001F758, A2	; offset for level up table is stored here!!!! there are 4 of them
	ADDA.l	D2, A2	; 
	MOVEA.l	(A2), A2	; offset for active xp table
	CLR.w	D3	;
	MOVE.b	$E(A4), D3	; this was $01, current level perhaps?
	SUBQ.w	#1, D3	;
	LSL.w	#2, D3	;
	MOVE.l	(A2,D3.w), D2	; get xp required for next level up
	sub.l	$32(A4), d2	; subtract current xp
	moveq	#$1e, x_tile_offset
	moveq	#$7, y_tile_offset
	jsr draw_stat_value

	rts
	
; ########################################################################################
; # fully original asm!! display str/int/spd etc stats on equip menu
; # 
; #
; ########################################################################################
	
 org $68980
 ; window is offset $1e, $c  x,y
draw_substats:
	LEA	$1234.w, A0	; strings for stat labels (str, vit, etc) ; my python script will redirect this...
	MOVEQ	#$1f, x_tile_offset
	MOVEQ	#$d, y_tile_offset
	JSR	write_label_8x8

	CLR.l	D2
	MOVE.b	$F(A2), D2	; str value
	MOVEQ	#3, D3
	MOVEQ	#$22, x_tile_offset	; set x offset for str / int stat values
	addq	#$1, y_tile_offset
	JSR	draw_stat_value

	CLR.l	D2
	MOVE.b	$10(A2), D2	; intelligence value
	addq	#3, y_tile_offset
	JSR	draw_stat_value
	CLR.l	D2
	MOVE.b	$11(A2), D2	; vitality
	addq	#3, y_tile_offset
	JSR	draw_stat_value
	CLR.l	D2
	MOVE.b	$12(A2), D2	; speed
	addq	#3, y_tile_offset
	JSR	draw_stat_value
	RTS


 org $1dee
write_to_vdp:

 org $36f2
write_label_8x16:

 org $8a66
mystery_label: