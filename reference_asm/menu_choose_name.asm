; ########################################################################################
; # Generated by the active disassembly feature of the Exodus emulation platform
; #
; # Creation Date:   2021-1-2 18:25:04
; # Analysis Region: 0x00003F88 - 0x0000403C
; ########################################################################################

 org $00003F88

	MOVEQ	#1, D0
	MOVEQ	#1, D1
	MOVEQ	#$00000026, D2
	MOVEQ	#$0000001A, D3
	MOVE.w	#$0043, D4
	BSR.w	*+$F340
	MOVE.w	D0, $1E(A1)
	MOVEQ	#$0000001D, D0
	MOVEQ	#$00000016, D1
	MOVEQ	#8, D2
	MOVEQ	#4, D3
	MOVEQ	#3, D4
	BSR.w	*+$F044
	MOVEQ	#4, D0
	MOVEQ	#3, D1
	BSR.w	*+$F5EE
	BSR.w	*+$F674
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	MOVEQ	#$0000001C, D0
	MOVEQ	#3, D1
	BSR.w	*+$F5DE
	BSR.w	*+$F65C
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	CLR.w	$14(A1)
	CLR.w	$16(A1)
	CLR.w	$18(A1)
	MOVE.w	#3, $1A(A1)
	MOVE.w	#3, $1C(A1)
	BSR.w	*+$D868
	MOVEQ	#$0000001E, D0
	MOVEQ	#$00000018, D1
	LEA	$00004428, A0
	BSR.w	*+$F61A
	MOVEA.l	A1, A0
	BSR.w	*+$F614
	MOVE.w	$1A(A1), D0
	MOVE.w	$1C(A1), D1
	MOVE.w	$18(A1), D2
	BTST.l	#4, D2
	BNE.b	loc_0000402E
	MOVE.w	#$E5A7, D2
	BRA.b	loc_00004032
loc_0000402E:
	MOVE.w	#$E52F, D2
loc_00004032:
	MOVEA.w	#$C000, A0
	BSR.w	*+$DDB6
	TRAP	#5
