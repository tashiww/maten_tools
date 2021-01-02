; ########################################################################################
; # Full page stat screen!!
; # layout adjustments to avoid abbreviations
; #
; # Generated by the active disassembly feature of the Exodus emulation platform
; # Creation Date:   2021-1-2 10:22:43
; # Analysis Region: 0x00009002 - 0x000091C4
; ########################################################################################

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
	MOVEQ	#$00000010, x_tile_offset	
	MOVEQ	#5, y_tile_offset
	MOVEQ	#0, D3
	BSR.w	draw_stat_value	
	MOVE.l	$32(A4), D2	; exp value
	MOVEQ	#$00000010, x_tile_offset
	MOVEQ	#7, y_tile_offset
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
	MOVEQ	#3, x_tile_offset
	MOVEQ	#$0000000B, y_tile_offset
	BSR.w	write_label_8x16	
	LEA	$FFFF9262.w, A0	; slashes between current and max hp (23 / 50)
	MOVEQ	#$0000000E, x_tile_offset
	MOVEQ	#$0000000B, y_tile_offset
	BSR.w	write_label_8x16
	CLR.l	D2
	
	MOVE.w	$2(A4), D2	; current hp
	MOVEQ	#3, D3
	MOVEQ	#8, x_tile_offset
	MOVEQ	#$0000000B, y_tile_offset
	BSR.w	draw_stat_value
	CLR.l	D2	; this probably isn't necessary? current hp can't exceed max hp
	MOVE.w	$4(A4), D2	; max hp
	MOVEQ	#3, D3
	MOVEQ	#$00000010, x_tile_offset
	MOVEQ	#$0000000B, y_tile_offset
	BSR.w	draw_stat_value	; draw max hp
	
	CLR.l	D2
	MOVE.w	$6(A4), D2	; current mp
	MOVEQ	#3, D3
	MOVEQ	#8, x_tile_offset
	MOVEQ	#$0000000D, y_tile_offset
	BSR.w	draw_stat_value	
	CLR.l	D2	
	MOVE.w	$8(A4), D2	; max mp
	MOVEQ	#3, D3
	MOVEQ	#$00000010, x_tile_offset
	MOVEQ	#$0000000D, y_tile_offset
	BSR.w	draw_stat_value
	
	LEA	$FFFF9266.w, A0	; strings for stat labels (str, vit, etc)
	MOVEQ	#3, x_tile_offset
	MOVEQ	#$00000011, y_tile_offset
	BSR.w	write_label_8x16
	
	CLR.l	D2
	MOVE.b	$F(A4), D2	; str value
	MOVEQ	#3, D3
	MOVEQ	#$0000000A, x_tile_offset
	MOVEQ	#$00000011, y_tile_offset
	BSR.w	draw_stat_value
	CLR.l	D2
	MOVE.b	$10(A4), D2	; intelligence value
	MOVEQ	#3, D3
	MOVEQ	#$0000000A, x_tile_offset
	MOVEQ	#$00000013, y_tile_offset
	BSR.w	draw_stat_value
	CLR.l	D2
	MOVE.b	$11(A4), D2	; vitality
	MOVEQ	#3, D3
	MOVEQ	#$0000000A, x_tile_offset
	MOVEQ	#$00000015, y_tile_offset
	BSR.w	draw_stat_value
	CLR.l	D2
	MOVE.b	$12(A4), D2	; speed
	MOVEQ	#3, D3
	MOVEQ	#$0000000A, x_tile_offset
	MOVEQ	#$00000017, y_tile_offset
	BSR.w	draw_stat_value
	
	LEA	$FFFF87E4.w, A0	; atk / def labels
	MOVEQ	#$00000019, x_tile_offset	
	MOVEQ	#$0000000B, y_tile_offset
	BSR.w	write_label_8x16
	CLR.l	D2
	
	MOVE.w	$A(A4), D2	; atk stat
	CMPI.w	#$03E8, D2	; check for > 1k
	BCS.b	dont_clip_atk
	MOVE.w	#$03E7, D2	; cap atk display at 999
dont_clip_atk:
	MOVEQ	#3, D3
	MOVEQ	#$00000020, x_tile_offset
	MOVEQ	#$0000000B, y_tile_offset
	BSR.w	draw_stat_value
	CLR.l	D2
	MOVE.w	$C(A4), D2	; def stat
	CMPI.w	#$03E8, D2	; check for > 1k
	BCS.b	dont_clip_def
	MOVE.w	#$03E7, D2	; cap def display at 999
dont_clip_def:
	MOVEQ	#3, D3
	MOVEQ	#$00000020, x_tile_offset
	MOVEQ	#$0000000D, y_tile_offset
	BSR.w	draw_stat_value

draw_gear_labels:	

	LEA	$FFFF927C.w, A0	; gear labels (wpn, helm, etc)
	MOVEQ	#$00000019, x_tile_offset
	MOVEQ	#$00000011, y_tile_offset
	BSR.w	write_label_8x8
	
	MOVE.b	$14(A4), D2	; currently equipped weapon
	MOVEQ	#$0000001E, x_tile_offset	;
	MOVEQ	#$00000011, y_tile_offset	
	BSR.w	draw_equipped_item	
	MOVE.b	$15(A4), D2	; equipped armor
	MOVEQ	#$0000001E, x_tile_offset
	MOVEQ	#$00000013, y_tile_offset
	BSR.w	draw_equipped_item	
	MOVE.b	$16(A4), D2	; equipped helm
	MOVEQ	#$0000001E, x_tile_offset	
	MOVEQ	#$00000015, y_tile_offset	;
	BSR.w	draw_equipped_item	
	MOVE.b	$17(A4), D2	; equipped shield
	MOVEQ	#$0000001E, x_tile_offset
	MOVEQ	#$00000017, y_tile_offset
	BSR.w	draw_equipped_item	
	MOVE.b	$18(A4), D2	; equipped item
	MOVEQ	#$0000001E, x_tile_offset
	MOVEQ	#$00000019, y_tile_offset
	BSR.w	draw_equipped_item
	
	MOVE.l	$00FFD5D6, D2	; gold amount
	MOVEQ	#5, D3
	MOVEQ	#$0000001B, x_tile_offset
	MOVEQ	#1, y_tile_offset
	BSR.w	draw_stat_value	
	LEA	$FFFF927A.w, A0	; 'G' for gold label
	MOVEQ	#$00000025, x_tile_offset
	MOVEQ	#1, y_tile_offset
	BSR.w	write_label_8x16

