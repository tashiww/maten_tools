; ########################################################################################
; # Generated by the active disassembly feature of the Exodus emulation platform
; #
; # Creation Date:   2021-1-1 13:36:35
; # Analysis Region: 0x00005C90 - 0x00005CEC
; ########################################################################################

 org $00005C90

	MOVE.w	D0, $6(A3)
	CLR.w	$8(A3)
	CLR.w	D6
	CLR.w	D5
	MOVEQ	#4, D1
loc_00005C9E:
	MOVE.w	(A4,D5.w), D2
	BEQ.w	loc_00005CD6
	MOVEQ	#$0000000B, D0
	BSR.w	*+$47AE
	BSR.w	*+$D97A
	MOVEQ	#$00000014, D0
	CLR.l	D2
	MOVE.w	$2(A4,D5.w), D2
	BNE.b	loc_00005CBE
	MOVE.w	$1E(A0), D2
loc_00005CBE:
	MOVEQ	#5, D3
	BSR.w	*+$DA72
	MOVEQ	#$00000019, D0
	LEA	*+$6024, A0
	BSR.w	*+$D9B6
	ADDQ.w	#1, D1
	ADDQ.w	#1, D6
	ADDQ.w	#4, D5
	BRA.b	loc_00005C9E
loc_00005CD6:
	SUBQ.w	#1, D6
	MOVEQ	#$0000000B, D0
	MOVEQ	#4, D1
	MOVEQ	#7, D2
	MOVEQ	#0, D3
	MOVEQ	#1, D4
	MOVEQ	#6, D5
	MOVE.w	$8(A3), D7
	BSR.w	*+$D63E
