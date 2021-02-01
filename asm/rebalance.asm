; ############################################################################
; # Created by:	tashi
; # Creation Date:	20XX
; # Re-assembled with asm68k (port of SNASM68k)
; # don't move any ops within original routine!
; # Summary:
; # 	Make game easier / less punishing
; #			- lower encounter rate
; #			- increase gold / xp rewards
; #			- increase HP cap and give more HP on level-up
; ############################################################################

StepCount equ	$00FFCAB0

; random encounter chance routine	
 org $00007DDA
	MOVEA.l	$2(A0), A0	; puts encounter pointer in a0 (encounter info is: level, # enemies, enc rate, then list of enemy IDs)
	MOVE.b	$2(A0), D1	; puts encounter rate in d1
	LSL.w	#8, D1	; $19 -> $1900
	JMP reduce_encounters
	; MULU.w	StepCount, D1	; steps since leaving town / last encounter, caps at 8
	LSR.l	#4, D1	; increased from 3 to 4 to reduce encounter rate 50% ?
	CMPI.w	#8, StepCount
	BCC.b	level_modifier
	ADDQ.w	#1, StepCount
 org $7dfc
level_modifier:
; reduces encounter chance if max player level exceeds encounter base level, > 4 skips encounters entirely
	BSR.w	$ad96	; gets party max level into d4 maybe
	CMP.b	(A0), D4	; checks encounter base level against max party level
	BLS.b	check_encounter_chance	
	LSR.w	#1, D1	;
	SUBQ.b	#3, D4	; increased to 3 and 3 so you can level up a bit more before going to harder areas?
	CMP.b	(A0), D4	;
	BLS.b	check_encounter_chance	;
	LSR.w	#1, D1	; need to modify the encounter table so the last area isn't such a slough
	SUBQ.b	#3, D4	;
	CMP.b	(A0), D4	;
	BLS.b	check_encounter_chance	;
	BRA.w	skip_combat	; avoid combat
check_encounter_chance:
	BSR.w	get_rng
	cmp.w	d1, d0
	bcc.w	skip_combat

	
 org $1f9c
get_rng:

 org $761e
skip_combat:	

 org $68480	; prevent encounters for 6 steps, then increase encounter rate gradually for 8 steps...
reduce_encounters:
	MULU.w	StepCount, D1	; steps since leaving town / last encounter, caps at 8
	LSR.l	#4, D1	; increased from 3 to 4 to reduce encounter rate
	CMPI.w	#6, StepCount	
	bcc.b	increment_stepcount	
	moveq	#$0, d1	; should set encounter chance to 0% i think
increment_stepcount:
	CMPI.w	#$c, StepCount	; increased from $8 to increase encounter rate from 50% original to 75% original
	BCC.b	exit_reduce_encounters
	ADDQ.w	#1, StepCount
exit_reduce_encounters:
	JMP	level_modifier
	
	
; ############################################################################
; # increase xp / gold rewards from battle
; #	
; ############################################################################

 org $dafa
tally_rewards:
	MOVEM.l	A0/D0, -(A7)
	BSR.w	get_enemy_rom_offset
	CLR.l	D0
	MOVE.w	$36(A0), D0	; enemy xp reward
	JSR	double_rewards
	MOVEM.l	(A7)+, D0/A0
	RTS

 org $db48
get_enemy_rom_offset:
	MOVE.l	D2, -(A7)
	SUBQ.w	#1, D2
	MULU.w	#$0040, D2
	LEA	$0001519A, A0
	ADDA.l	D2, A0
	MOVE.l	(A7)+, D2
	RTS
	
 org $684d0
double_rewards:
	lsl.l	#$1, d0
	ADD.l	D0, $00FFDACA	; ram xp sum
	MOVE.w	$38(A0), D0	; enemy gold reward
	lsl.l	#$1, d0
	ADD.l	D0, $00FFDACE	; ram gold sum
	RTS

; ############################################################################
; # increase gold cap (for battle rewards and selling at shops)
; #	
; ############################################################################

 org $CA90
check_gold_cap_battle:
	MOVE.l	$00FFDACE, D0	; battle reward gold location
	ADD.l	$00FFD5D6, D0	; normal gold ram location
	CMPI.l	#$000f4240, D0	; cmp to 1,000,000
	BCS.b	no_cap_battle	; skip next op
	MOVE.l	#$000f423f, D0
no_cap_battle:

 org $5fbc
selling_gold_cap:
	CMPI.l	#$000f4240, D0	; cmp to 1,000,000
	BLS.b	no_cap_shop	; skip next op
	MOVE.l	#$000f423f, D0
no_cap_shop:

; ############################################################################
; # increase hp/mp cap, and hp/mp/atk/def growth per level
; #	
; ############################################################################

 org $cc56
add_vit_bonus_to_hp:
	CLR.l	D0	;
	MOVE.b	$11(A1), D0	; get vit
	LSL.l	#1, D0	; double it
	CLR.l	D1	;
	MOVE.b	$F(A1), D1	; str ??
	ADD.l	D1, D0	;
	DIVU.w	#$0005, D0	; divide by $14 -> $a , double hp growth? -> $5 , 4x? arnath had 750hp at lvl 46 originally -> 1400 at 2x, 2870 at 4x
	MOVE.w	D0, D2	;
	ADD.w	$4(A1), D2	; max hp
	CMPI.w	#$2710, D2	; cap at 999 -> 9,999
	BCS.b	loc_0000CC80	;
	MOVE.w	#$270f, D2	;
	MOVE.w	D2, D0	;
	SUB.w	$4(A1), D0	;
loc_0000CC80:
	MOVE.w	D2, $4(A1)	;
	ADD.w	D0, $2(A1)	;
	CLR.l	D0	;
	MOVE.b	$10(A1), D0	; get mind
	LSL.l	#1, D0	; double
	CLR.l	D1	;
	MOVE.b	$11(A1), D1	; get vit
	ADD.l	D1, D0	;
	DIVU.w	#$000a, D0	; double mnd growth
	MOVE.w	D0, D2	;
	ADD.w	$8(A1), D2	;
	CMPI.w	#$2710, D2	;
	BCS.b	loc_0000CCB2	;
	MOVE.w	#$270f, D2	;
	MOVE.w	D2, D0	;
	SUB.w	$8(A1), D0	;
loc_0000CCB2:

 org $cc2e
	lsl.w	#1, d1	; double atk growth .. arnath gets 1500 at max level
 org $cc48
	lsl.w	#1, d1	; double def growth?
	
	
; ############################################################################
; # change shop items / prices
; #	
; ############################################################################
	
 org $265fa
	dc.l	$86	; add "miracle of love" revive item to leam item shop
	dc.l	$00
	dc.l	$006e000c	; needed at end of shop inventory? i guess?
 org $14184
	dc.w	$0096	; change miracle of love price from 350g to 150g
	