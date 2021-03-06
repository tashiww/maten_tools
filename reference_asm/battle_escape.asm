; ########################################################################################
; # Generated by the active disassembly feature of the Exodus emulation platform
;
; # escape from battle routine
;
; # Creation Date:   2021-1-5 19:29:40
; # Analysis Region: 0x0000BED2 - 0x0000C0xx
; ########################################################################################

 org $0000BED2

	MOVE.w	$00FFDAC4, D0	; it's after ram ptrs for enemy and player, not sure.. always $0?
	BTST.l	#0, D0	; maybe boss flag for inescapable battles
	BNE.w	EscapeFail
	BTST.l	#$0E, D0
	BNE.w	loc_0000BF9C
	MOVEA.l	$00FFDAB8, A5
	
	MOVEQ	#5, D6	; loop through full party
	CLR.w	D5	; starting with first member
	MOVEQ	#-1, D4	; max speed in party
	CLR.w	D7
	
GetPartySpeed:
	TST.w	(A5,D5.w)	; check if member present
	BEQ.b	SetupForEnemyCheck	
	MOVE.w	$14(A5,D5.w), D3	; speed
	TST.w	$2(A5,D5.w)	; check current hp (dead lol)
	BEQ.b	HalveDeadSpeed
	MOVE.w	$16(A5,D5.w), D0	; status debuffs
	ANDI.w	#$30A6, D0	; stone, paralyze, hold i think
	BEQ.b	PlayerNotDisabled
	
HalveDeadSpeed:
	LSR.w	#1, D3	;
	BRA.b	CheckHighestSpeed	;
	
PlayerNotDisabled:
	MOVEQ	#-1, D7	; autofail if this isn't set
	
CheckHighestSpeed:
	CMP.w	D3, D4
	BCS.b	NextMember
	MOVE.w	D3, D4
NextMember:
	ADDI.w	#$0030, D5
	DBF	D6, GetPartySpeed
	
SetupForEnemyCheck:
	TST.w	D7
	BEQ.w	EscapeFail
	MOVEA.l	$00FFDAB4, A5	
	MOVEQ	#8, D6	; can there be 8 enemies????
	CLR.w	D5
	MOVEQ	#1, D3
	CLR.w	D7
	
GetEnemySpeed:
	TST.w	(A5,D5.w)	; check if present
	BEQ.b	NextEnemy	
	TST.w	$2(A5,D5.w)	; curent hp
	BEQ.b	NextEnemy	
	MOVE.w	$16(A5,D5.w), D0	; debuffs
	ANDI.w	#$3066, D0	; adds sleep and fear i think?
	BNE.b	NextEnemy	
	MOVEQ	#-1, D7	; valid enemy
	CMP.w	$14(A5,D5.w), D3	; check against max speed so far
	BCC.b	NextEnemy
	MOVE.w	$14(A5,D5.w), D3	; set as highest speed
NextEnemy:
	ADDI.w	#$0030, D5	; data for enemies is $30 bytes
	DBF	D6, GetEnemySpeed	

EscapeOdds	equr	d5
	TST.w	D7
	BEQ.w	loc_0000BF9C	; if no valid enemy speeds
	MOVEQ	#7, EscapeOdds
	CMP.w	D3, D4
	BCS.b	PlayerSlower
	LSR.w	#1, D4	;
	CMP.w	D3, D4	;
	BCS.b	EscapeRNG	;
	MOVEQ	#$0000000B, EscapeOdds	; if player 2x faster
	LSR.w	#1, D4	;
	CMP.w	D3, D4	;
	BCS.b	EscapeRNG	;
	MOVEQ	#$0000000F, EscapeOdds	; if player 4x faster
	BRA.b	EscapeRNG	;
	
PlayerSlower:
	MOVEQ	#2, EscapeOdds
	LSR.w	#1, D3
	CMP.w	D3, D4
	BCC.b	EscapeRNG
	BRA.w	EscapeFail	;Predicted (Code-scan)
EscapeRNG:
	JSR	$00001F9C	; rng routine
	ANDI.w	#$000F, D0
	CMP.w	D0, EscapeOdds
	BCS.w	EscapeFail
	
loc_0000BF9C:
	MOVE.w	#$00FD, D0
	JSR	$00002376
	MOVEA.l	$00FFDAB8, A5
	MOVEQ	#5, D7
	CLR.w	D6

BattleWrapup:
	CLR.w	D2
	MOVE.b	(A5), D2
	BEQ.b	loc_0000C01A
	BSR.w	$E23A	
	MOVE.w	$2(A5), $2(A0)	; update hp (copy battle status to game status)
	MOVE.w	$6(A5), $6(A0)	; update mp
	MOVE.w	$16(A5), D0	; debuffs
	ANDI.w	#7, D0
	MOVE.b	D0, $19(A0)
	MOVE.w	$24(A5), $40(A0)
	MOVE.w	$26(A5), $42(A0)
	MOVE.w	$2E(A5), $4E(A0)
	MOVE.w	$00FFDAC4, D0
	BTST.l	#$0C, D0
	BEQ.b	loc_0000C00E
	CMPI.b	#1, (A0)	;Predicted (Code-scan)
	BEQ.b	loc_0000C002	;Predicted (Code-scan)
	CMPI.b	#2, (A0)	;Predicted (Code-scan)
	BEQ.b	loc_0000C002	;Predicted (Code-scan)
	CMPI.b	#9, (A0)	;Predicted (Code-scan)
	BNE.b	loc_0000C00E	;Predicted (Code-scan)
loc_0000C002:
	TST.w	$2(A0)	;Predicted (Code-scan)
	BNE.b	loc_0000C00E	;Predicted (Code-scan)
	MOVE.w	#1, $2(A0)	; gives 1 hp to dead people?
loc_0000C00E:
	ADDQ.w	#1, D6
	ADDA.l	#$00000030, A5
	DBF	D7, BattleWrapup
loc_0000C01A:
	JSR	$0000B184
	MOVE.w	#1, $00FF0004
	TRAP	#5
	ORI.b	#$FA, D1	;Predicted (Code-scan)
EscapeFail:
	MOVEQ	#6, D0
	LEA	$CD48, A0	; asm68k might mangle this 
	JSR	$00003850
	JSR	$0000382E
	TRAP	#5
