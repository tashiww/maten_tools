; ########################################################################################
; # Generated by the active disassembly feature of the Exodus emulation platform
; #
; # Creation Date:   2020-11-28 13:15:40
; # Analysis Region: 0x00008000 - 0x00009000
; ########################################################################################

 org $00008000

loc_00008118:
	MOVEM.l	A0/D0, -(A7)	;Predicted (Code-scan)
	CLR.w	D0	;Predicted (Code-scan)
	MOVE.b	$00FFCED6, D0	;Predicted (Code-scan)
	MOVE.w	D0, $00FFCA9A	;Predicted (Code-scan)
	MOVE.w	D0, D2	;Predicted (Code-scan)
	BSR.w	*+$20C4	;Predicted (Code-scan)
	CLR.w	D0	;Predicted (Code-scan)
	MOVE.b	$1(A0), D0	;Predicted (Code-scan)
	MOVE.w	D0, $00FFCA9C	;Predicted (Code-scan)
	BSR.w	*+$CC86	;Predicted (Code-scan)
	MOVE.w	$00FFCA6E, D0	;Predicted (Code-scan)
	CMPI.w	#$00F3, D0	;Predicted (Code-scan)
	BEQ.b	loc_00008152	;Predicted (Code-scan)
	CMPI.w	#$0021, D0	;Predicted (Code-scan)
	BNE.b	loc_00008162	;Predicted (Code-scan)
loc_00008152:
	MOVEQ	#$00000016, D0	;Predicted (Code-scan)
	BSR.w	*+$BAFA	;Predicted (Code-scan)
	TST.w	D0	;Predicted (Code-scan)
	BEQ.b	loc_00008162	;Predicted (Code-scan)
	MOVEQ	#$0000002C, D0	;Predicted (Code-scan)
	BSR.w	*+$CBF8	;Predicted (Code-scan)
loc_00008162:
	MOVEM.l	(A7)+, D0/A0	;Predicted (Code-scan)
	RTS	;Predicted (Code-scan)
	dc.b	$23, $C8, $00, $FF, $CA, $C0, $42, $79, $00, $FF, $CA, $C6, $4E, $75 ;0x0 (0x00008168-0x00008176, Entry count: 0xE) [Unknown data]
	MOVEM.l	A0/D1/D0, -(A7)
	MOVE.l	$00FFCAC0, D0
	BEQ.b	loc_000081DE
	MOVEA.l	D0, A0	;Predicted (Code-scan)
	MOVE.w	$00FFCAC6, D0	;Predicted (Code-scan)
	BNE.b	loc_000081BC	;Predicted (Code-scan)
	CLR.w	D1	;Predicted (Code-scan)
	MOVE.b	(A0)+, D1	;Predicted (Code-scan)
	BNE.b	loc_000081AC	;Predicted (Code-scan)
	CLR.l	$00FFCAC0	;Predicted (Code-scan)
	CLR.w	$00FFCAAC	;Predicted (Code-scan)
	CLR.w	$00FF27DA	;Predicted (Code-scan)
	CLR.w	$00FF27D8	;Predicted (Code-scan)
	BRA.b	loc_000081DE	;Predicted (Code-scan)
loc_000081AC:
	MOVE.w	D1, D0	;Predicted (Code-scan)
	MOVE.b	(A0)+, D1	;Predicted (Code-scan)
	MOVE.l	A0, $00FFCAC0	;Predicted (Code-scan)
	MOVE.w	D1, $00FFCAC4	;Predicted (Code-scan)
loc_000081BC:
	SUBQ.w	#1, D0	;Predicted (Code-scan)
	MOVE.w	D0, $00FFCAC6	;Predicted (Code-scan)
	MOVE.w	$00FFCAC4, D0	;Predicted (Code-scan)
	LSL.w	#8, D0	;Predicted (Code-scan)
	MOVE.w	D0, $00FFCAAC	;Predicted (Code-scan)
	MOVE.w	D0, $00FF27DA	;Predicted (Code-scan)
	MOVE.w	D0, $00FF27D8	;Predicted (Code-scan)
loc_000081DE:
	MOVEM.l	(A7)+, D0/D1/A0
	RTS
	dc.b	$2F, $08, $30, $79, $00, $FF, $CA, $A4, $61, $00, $A8, $94, $20, $5F, $4E, $75, $2F, $08, $30, $79, $00, $FF, $CA, $A4, $61, $00, $A8, $9E, $20, $5F, $4E, $75 ;0x0 (0x000081E4-0x00008330, Entry count: 0x14C) [Unknown data]
	dc.b	$48, $E7, $F0, $C0, $52, $79, $00, $FF, $CA, $C8, $76, $08, $0C, $39, $00, $02, $00, $FF, $CA, $B8, $67, $0E, $76, $04, $0C, $39, $00, $01, $00, $FF, $CA, $B8 ;0x20
	dc.b	$67, $02, $76, $02, $B6, $79, $00, $FF, $CA, $C8, $62, $00, $00, $E0, $42, $79, $00, $FF, $CA, $C8, $43, $F9, $00, $FF, $CE, $D6, $76, $05, $42, $41, $42, $42 ;0x40
	dc.b	$14, $19, $67, $2A, $61, $00, $1F, $A8, $4A, $68, $00, $02, $67, $20, $08, $28, $00, $00, $00, $19, $67, $18, $53, $68, $00, $02, $6A, $04, $42, $68, $00, $02 ;0x60
	dc.b	$72, $01, $4A, $68, $00, $02, $66, $06, $08, $E8, $00, $07, $00, $19, $51, $CB, $FF, $CE, $4A, $41, $67, $00, $00, $96, $70, $5D, $61, $00, $A0, $F6, $70, $1F ;0x80
	dc.b	$72, $02, $34, $3C, $00, $08, $61, $00, $9C, $EE, $4E, $45, $00, $02, $61, $00, $C3, $3C, $4E, $45, $00, $01, $43, $F9, $00, $FF, $CE, $D6, $76, $05, $42, $41 ;0xA0
	dc.b	$42, $42, $14, $19, $67, $2A, $61, $00, $1F, $46, $08, $28, $00, $07, $00, $19, $67, $1E, $42, $28, $00, $19, $61, $00, $1F, $20, $23, $C8, $00, $FF, $30, $98 ;0xC0
	dc.b	$61, $00, $B5, $3A, $41, $FA, $00, $4C, $42, $40, $61, $00, $B5, $80, $72, $01, $51, $CB, $FF, $CE, $61, $00, $B5, $54, $4A, $41, $67, $30, $61, $00, $2E, $A2 ;0xE0
	dc.b	$4A, $40, $67, $0C, $6A, $26, $61, $00, $FE, $2C, $61, $00, $F8, $9A, $60, $1C, $61, $00, $B5, $0A, $41, $FA, $00, $2A, $42, $40, $61, $00, $B5, $50, $33, $FC ;0x100
	dc.b	$00, $03, $00, $FF, $00, $04, $4E, $45, $00, $01, $60, $FA, $4C, $DF, $03, $0F, $4E, $75, $06, $4E, $1A, $01, $08, $6F, $46, $36, $5D, $42, $3E, $1B, $00, $00 ;0x120
	dc.b	$01, $26, $01, $27, $36, $45, $36, $5D, $42, $3E, $1B, $00 ;0x140
	TRAP	#5
	ORI.b	#$B9, D1	;Predicted (Code-scan)
	ORI.b	#$C2, D0	;Predicted (Code-scan)
	MOVEQ	#$00000066, D0
	BSR.w	*+$A038
	MOVEM.l	A0/D0, -(A7)
	MOVE.w	#$0010, D0
	BSR.w	*+$B7DA
	MOVEA.l	A0, A6
	MOVEM.l	(A7)+, D0/A0
	MOVEM.l	A0/D0, -(A7)
	MOVE.w	#$0020, D0
	BSR.w	*+$B7C8
	MOVEA.l	A0, A5
	MOVEM.l	(A7)+, D0/A0
	MOVEA.l	A6, A4
	MOVEQ	#7, D0
	MOVEQ	#-1, D1
loc_0000836A:
	MOVE.w	D1, (A4)+
	DBF	D0, loc_0000836A
	CLR.w	(A5)
	MOVEQ	#2, D0
	MOVEQ	#2, D1
	MOVEQ	#8, D2
	MOVEQ	#$0000000A, D3
	MOVEQ	#3, D4
	BSR.w	*+$AF58
	MOVE.w	D0, (A6)
	MOVEA.w	#$9000, A1
	MOVEQ	#3, D0
	MOVEQ	#3, D1
; main menu strings
	LEA	loc_000083E6(PC), A0
	BSR.w	*+$B362
	MOVEQ	#3, D0
	MOVEQ	#3, D1
	MOVEQ	#5, D2
	MOVEQ	#1, D3
	MOVEQ	#1, D4
	MOVEQ	#4, D5
	MOVEQ	#3, D6
	MOVE.w	(A5), D7
	BSR.w	*+$AF84
	MOVE.w	D7, (A5)
	BMI.b	loc_000083BE
	BEQ.w	loc_00008402
	SUBQ.w	#1, D7	;Predicted (Code-scan)
	BEQ.w	loc_00008810	;Predicted (Code-scan)
	SUBQ.w	#1, D7	;Predicted (Code-scan)
	BEQ.w	loc_00008AA2	;Predicted (Code-scan)
	BRA.w	*+$FE2	;Predicted (Code-scan)
loc_000083BE:
	MOVE.w	(A6), D0	;Predicted (Code-scan)
	BSR.w	*+$ADF2	;Predicted (Code-scan)
	TRAP	#5	;Predicted (Code-scan)
	ORI.b	#8, D1	;Predicted (Code-scan)
loc_000083CA:
	MOVEA.l	A5, A0
	BSR.w	*+$B7CA
	MOVEA.l	(A7)+, A0
	MOVE.l	A0, -(A7)
	MOVEA.l	A6, A0
	BSR.w	*+$B7C0
	MOVEA.l	(A7)+, A0
	JSR	$000016E6
	BRA.w	*+$F1DE
loc_000083E6:
	dc.b	$29, $54, $4D, $0D, $25, $51, $55, $0D, $33, $54, $41, $0D, $21, $42, $49, $00 ;0x0 (0x000083E6-0x000083F6, Entry count: 0x10) [Unknown data]
loc_000083F6:
	dc.b	$35, $53, $45, $0D, $27, $49, $56, $0D, $34, $48, $52, $00 ;0x0 (0x000083F6-0x00008402, Entry count: 0xC) [Unknown data]
loc_00008402:
	MOVEQ	#3, D0
	MOVEQ	#3, D1
	MOVEQ	#8, D2
	MOVEQ	#8, D3
	MOVE.w	#$0083, D4
	BSR.w	*+$AEC6
	MOVE.w	D0, $2(A6)
	MOVE.w	A1, $2(A5)
	MOVEQ	#4, D0
	MOVEQ	#4, D1
	
; ITM sub-menu !!!!
	LEA	loc_000083F6(PC), A0
	BSR.w	*+$B2CE
	CLR.w	$4(A5)
	MOVEQ	#4, D0
	MOVEQ	#4, D1
	MOVEQ	#5, D2
	MOVEQ	#1, D3
	MOVEQ	#1, D4
	MOVEQ	#3, D5
	MOVEQ	#2, D6
	MOVE.w	$4(A5), D7
	BSR.w	*+$AEEA
	MOVE.w	D7, $4(A5)
	BPL.b	loc_00008460
	MOVE.w	$2(A6), D0	;Predicted (Code-scan)
	BSR.w	*+$AD68	;Predicted (Code-scan)
	MOVE.w	#$FFFF, $2(A6)	;Predicted (Code-scan)
	MOVEA.w	$2(A5), A1	;Predicted (Code-scan)
	TRAP	#5	;Predicted (Code-scan)
	ORI.b	#0, D1	;Predicted (Code-scan)
	dc.b	$FF, $34 ;0x0 (0x0000845E-0x00008460, Entry count: 0x2) [Unknown data]
loc_00008460:
	MOVEQ	#2, D0
	MOVEQ	#$0000000C, D1
	MOVEQ	#8, D2
	MOVEQ	#$0000000E, D3
	MOVE.w	#3, D4
	BSR.w	*+$AE68
	MOVE.w	D0, $4(A6)
	CLR.w	$6(A5)
	MOVEQ	#3, D0
	MOVEQ	#$0000000E, D1
	CLR.w	D2
	TST.w	$4(A5)
	BEQ.b	loc_00008486
	MOVEQ	#1, D2	;Predicted (Code-scan)
loc_00008486:
	BSR.w	*+$1DA6
	MOVE.w	$6(A5), D7
	BSR.w	*+$AE98
	MOVE.w	D7, $6(A5)
	BPL.b	loc_000084AE
	MOVE.w	$4(A6), D0	;Predicted (Code-scan)
	BSR.w	*+$AD16	;Predicted (Code-scan)
	MOVE.w	#$FFFF, $4(A6)	;Predicted (Code-scan)
	TRAP	#5	;Predicted (Code-scan)
	ORI.b	#0, D1	;Predicted (Code-scan)
	dc.b	$FF, $7E ;0x0 (0x000084AC-0x000084AE, Entry count: 0x2) [Unknown data]
loc_000084AE:
	MOVEQ	#$0000000A, D0
	MOVEQ	#$0000000C, D1
	MOVEQ	#$00000014, D2
	MOVEQ	#$0000000E, D3
	MOVE.w	#3, D4
	BSR.w	*+$AE1A
	MOVE.w	D0, $6(A6)
	CLR.w	$8(A5)
loc_000084C6:
	MOVE.w	$6(A5), D2
	TST.w	$4(A5)
	BEQ.b	loc_000084D6
	BSR.w	*+$1E7E
	BRA.b	loc_000084DA
loc_000084D6:
	BSR.w	*+$1D44
loc_000084DA:
	MOVEQ	#$0000000B, D0
	MOVEQ	#$0000000E, D1
	BSR.w	*+$1FD4
	ADDQ.w	#1, D0
	MOVE.w	$8(A5), D7
	BSR.w	*+$AE3E
	MOVE.w	D7, $8(A5)
	BPL.b	loc_00008508
	MOVE.w	$6(A6), D0	;Predicted (Code-scan)
	BSR.w	*+$ACBC	;Predicted (Code-scan)
	MOVE.w	#$FFFF, $6(A6)	;Predicted (Code-scan)
	TRAP	#5	;Predicted (Code-scan)
	ORI.b	#0, D1	;Predicted (Code-scan)
	dc.b	$FF, $72 ;0x0 (0x00008506-0x00008508, Entry count: 0x2) [Unknown data]
loc_00008508:
	MOVE.w	$4(A5), D0
	BEQ.w	loc_00008580
	CMPI.w	#1, D0
	BEQ.w	loc_000086B6
	BSR.w	loc_000089B2
	LEA	$00FF3098, A4
	MOVE.w	$6(A5), D2
	BSR.w	*+$1E28
	MOVE.w	$8(A5), D0
	BSR.w	*+$1FEA
	BTST.l	#$0E, D0
	BNE.b	loc_00008562
	BSR.w	*+$1CA2
	MOVE.l	A0, (A4)+
	MOVE.w	$8(A5), D0
	BSR.w	*+$2084
	MOVE.w	D0, D2
	BSR.w	*+$1F0E
	MOVE.l	A0, (A4)
	BSR.w	*+$1F2E
	BTST.l	#0, D0
	BEQ.b	loc_0000855C
	BSR.w	*+$2BAC	;Predicted (Code-scan)
loc_0000855C:

; item throw away string
	LEA	loc_00008A14(PC), A0
	BRA.b	loc_0000856E
loc_00008562:
	MOVE.w	D0, D2	;Predicted (Code-scan)
	BSR.w	*+$1EF2	;Predicted (Code-scan)
	MOVE.l	A0, (A4)	;Predicted (Code-scan)
	
; can't throw away borrowed item string
	LEA	loc_00008A20(PC), A0	;Predicted (Code-scan)
loc_0000856E:
	BSR.w	*+$B290
	CLR.w	D0
	BSR.w	*+$B2DA
	BSR.w	*+$B2B4
	BRA.w	loc_000083CA-2
loc_00008580:
	MOVE.w	$6(A5), D2
	BSR.w	*+$1C96
	BSR.w	*+$1C68
	TST.w	$2(A0)
	BEQ.w	loc_000089D0
	BTST.b	#1, $19(A0)
	BNE.w	loc_000089F2
	BTST.b	#2, $19(A0)
	BNE.w	loc_000089F2
	MOVE.w	D2, $C(A5)
	MOVE.w	$8(A5), D0
	BSR.w	*+$1F68
	MOVE.w	D0, $E(A5)
	CLR.w	$10(A5)
	MOVE.w	D0, D2
	BSR.w	*+$1EBE
	BTST.l	#1, D0
	BEQ.w	loc_00008618
	MOVEQ	#$0000001E, D0	;Predicted (Code-scan)
	MOVEQ	#$0000000C, D1	;Predicted (Code-scan)
	MOVEQ	#8, D2	;Predicted (Code-scan)
	MOVEQ	#$0000000E, D3	;Predicted (Code-scan)
	MOVE.w	#3, D4	;Predicted (Code-scan)
	BSR.w	*+$ACFE	;Predicted (Code-scan)
	MOVE.w	D0, $8(A6)	;Predicted (Code-scan)
	MOVEQ	#$0000001F, D0	;Predicted (Code-scan)
	MOVEQ	#$0000000E, D1	;Predicted (Code-scan)
	CLR.w	D2	;Predicted (Code-scan)
	BSR.w	*+$1C48	;Predicted (Code-scan)
	CLR.w	D7	;Predicted (Code-scan)
	BSR.w	*+$AD3C	;Predicted (Code-scan)
	MOVE.w	D7, $A(A5)	;Predicted (Code-scan)
	BPL.b	loc_0000860A	;Predicted (Code-scan)
	MOVE.w	$8(A6), D0	;Predicted (Code-scan)
	BSR.w	*+$ABBA	;Predicted (Code-scan)
	MOVE.w	#$FFFF, $8(A6)	;Predicted (Code-scan)
	TRAP	#5	;Predicted (Code-scan)
	ORI.b	#0, D1	;Predicted (Code-scan)
	dc.b	$FE, $BE ;0x0 (0x00008608-0x0000860A, Entry count: 0x2) [Unknown data]
loc_0000860A:
	MOVE.w	D7, D2	;Predicted (Code-scan)
	BSR.w	*+$1C0E	;Predicted (Code-scan)
	MOVE.w	D2, $10(A5)	;Predicted (Code-scan)
	BRA.w	loc_00008640	;Predicted (Code-scan)
loc_00008618:
	BTST.l	#8, D0
	BEQ.w	loc_00008640
	CLR.w	D2	;Predicted (Code-scan)
	MOVE.w	$00FF53AA, D0	;Predicted (Code-scan)
	BTST.l	#7, D0	;Predicted (Code-scan)
	BEQ.b	loc_0000863C	;Predicted (Code-scan)
	MOVEQ	#$0000001E, D0	;Predicted (Code-scan)
	MOVEQ	#$0000000C, D1	;Predicted (Code-scan)
	BSR.w	*+$251E	;Predicted (Code-scan)
	TST.w	D2	;Predicted (Code-scan)
	BMI.w	loc_000084C6	;Predicted (Code-scan)
loc_0000863C:
	MOVE.w	D2, $10(A5)	;Predicted (Code-scan)
loc_00008640:
	BSR.w	loc_000089B2
	LEA	$00FF3098, A4
	MOVE.w	$C(A5), D2
	BSR.w	*+$1B8C
	MOVE.l	A0, (A4)+
	MOVE.w	$E(A5), D2
	BSR.w	*+$1DFE
	MOVE.l	A0, (A4)
	BSR.w	*+$1E1E
	BTST.l	#2, D0
	BEQ.b	loc_00008674
	MOVE.w	$C(A5), D2	;Predicted (Code-scan)
	MOVE.w	$8(A5), D0	;Predicted (Code-scan)
	BSR.w	*+$1F56	;Predicted (Code-scan)
loc_00008674:
	BSR.w	*+$B18A
	
; use item string
	LEA	loc_00008A32(PC), A0
	CLR.w	D0
	BSR.w	*+$B1D0
	MOVE.w	$E(A5), D2
	BSR.w	*+$1E12
	TST.l	D2
	BEQ.b	loc_000086A4
	MOVEA.l	D2, A0	;Predicted (Code-scan)
	MOVE.w	$C(A5), D6	;Predicted (Code-scan)
	MOVE.w	$10(A5), D7	;Predicted (Code-scan)
	MOVEM.l	A6/A5, -(A7)	;Predicted (Code-scan)
	JSR	(A0)	;Predicted (Code-scan) (Uncertain target!)
	MOVEM.l	(A7)+, A5/A6	;Predicted (Code-scan)
	BRA.b	loc_000086B2	;Predicted (Code-scan)
loc_000086A4:

; nothing happened string
	LEA	loc_00008A3E(PC), A0
	CLR.w	D0
	BSR.w	*+$B1A4
	BSR.w	*+$B17E
loc_000086B2:
	BRA.w	loc_000083CA-2
loc_000086B6:
	MOVEQ	#$0000001E, D0	;Predicted (Code-scan)
	MOVEQ	#$0000000C, D1	;Predicted (Code-scan)
	MOVEQ	#8, D2	;Predicted (Code-scan)
	MOVEQ	#$0000000E, D3	;Predicted (Code-scan)
	MOVE.w	#3, D4	;Predicted (Code-scan)
	BSR.w	*+$AC12	;Predicted (Code-scan)
	MOVE.w	D0, $8(A6)	;Predicted (Code-scan)
	MOVEQ	#$0000001F, D0	;Predicted (Code-scan)
	MOVEQ	#$0000000E, D1	;Predicted (Code-scan)
	MOVEQ	#1, D2	;Predicted (Code-scan)
	BSR.w	*+$1B5C	;Predicted (Code-scan)
	CLR.w	D7	;Predicted (Code-scan)
	BSR.w	*+$AC50	;Predicted (Code-scan)
	MOVE.w	D7, $A(A5)	;Predicted (Code-scan)
	BPL.b	loc_000086F6	;Predicted (Code-scan)
	MOVE.w	$8(A6), D0	;Predicted (Code-scan)
	BSR.w	*+$AACE	;Predicted (Code-scan)
	MOVE.w	#$FFFF, $8(A6)	;Predicted (Code-scan)
	TRAP	#5	;Predicted (Code-scan)
	ORI.b	#0, D1	;Predicted (Code-scan)
	
; took item string
	LEA	loc_00008A82(PC), A0	;Predicted (Code-scan)
	BRA.b	loc_000087B6	;Predicted (Code-scan)
loc_00008774:

; handed itm to X string
	LEA	loc_00008A4A(PC), A0	;Predicted (Code-scan)
	BRA.b	loc_000087B6	;Predicted (Code-scan)
loc_0000877A:
	MOVE.l	$4(A4), (A4)	;Predicted (Code-scan)
; can't carry anymore string
	LEA	loc_00008A58(PC), A0	;Predicted (Code-scan)
	BRA.b	loc_000087B6	;Predicted (Code-scan)
loc_00008784:
	BSR.w	*+$1BCA	;Predicted (Code-scan)
	BSR.w	*+$1A52	;Predicted (Code-scan)
	MOVE.l	A0, (A4)+	;Predicted (Code-scan)
	MOVE.w	$8(A5), D0	;Predicted (Code-scan)
	BSR.w	*+$1D86	;Predicted (Code-scan)
	MOVE.w	D0, D3	;Predicted (Code-scan)
	MOVE.w	$8(A5), D0	;Predicted (Code-scan)
	BSR.w	*+$1E2A	;Predicted (Code-scan)
	MOVE.w	D3, D0	;Predicted (Code-scan)
	BCLR.l	#$0F, D0	;Predicted (Code-scan)
	BSR.w	*+$1D84	;Predicted (Code-scan)
	MOVE.w	D3, D2	;Predicted (Code-scan)
	BSR.w	*+$1CAA	;Predicted (Code-scan)
	MOVE.l	A0, (A4)	;Predicted (Code-scan)
; tried to take out X string
	LEA	loc_00008A66(PC), A0	;Predicted (Code-scan)
loc_000087B6:
	BSR.w	*+$B048	;Predicted (Code-scan)
	CLR.w	D0	;Predicted (Code-scan)
	BSR.w	*+$B092	;Predicted (Code-scan)
	BSR.w	*+$B06C	;Predicted (Code-scan)
	BRA.w	loc_000083CA-2	;Predicted (Code-scan)
loc_000087C8:
	dc.b	$5B, $7B, $3F, $46, $1E, $0D, $65, $6A, $41, $1E, $0D, $45, $5B, $7B, $53, $1E, $0D, $4F, $3F, $52, $1E, $00 ;0x0 (0x000087C8-0x000087DE, Entry count: 0x16) [Unknown data]
loc_000087DE:
	dc.b	$80, $81, $92, $A0, $1E, $00 ;0x0 (0x000087DE-0x000087E4, Entry count: 0x6) [Unknown data]
loc_000087E4:
	dc.b	$D1, $D2, $C3, $0D, $D4, $D5, $C3, $00 ;0x0 (0x000087E4-0x000087EC, Entry count: 0x8) [Unknown data]
loc_000087EC:
	dc.b	$3F, $3F, $3F, $3F, $3F, $3F, $3F, $3F, $00, $00 ;0x0 (0x000087EC-0x000087F6, Entry count: 0xA) [Unknown data]
loc_000087F6:
; not sure, blanks in menu_tbl, dadada in japanese table lol
	LEA	loc_000087EC(PC), A0	;Predicted (Code-scan)
	BSR.w	*+$AE2C	;Predicted (Code-scan)
	TST.b	D2	;Predicted (Code-scan)
	BEQ.b	loc_0000880E	;Predicted (Code-scan)
	ANDI.w	#$00FF, D2	;Predicted (Code-scan)
	BSR.w	*+$1C50	;Predicted (Code-scan)
	BSR.w	*+$AE1C	;Predicted (Code-scan)
loc_0000880E:
	RTS	;Predicted (Code-scan)
loc_00008810:
	MOVEQ	#2, D0	;Predicted (Code-scan)
	MOVEQ	#$0000000C, D1	;Predicted (Code-scan)
	MOVEQ	#8, D2	;Predicted (Code-scan)
	MOVEQ	#$0000000E, D3	;Predicted (Code-scan)
	MOVE.w	#3, D4	;Predicted (Code-scan)
	BSR.w	*+$AAB8	;Predicted (Code-scan)
	MOVE.w	D0, $2(A6)	;Predicted (Code-scan)
	CLR.w	$2(A5)	;Predicted (Code-scan)
	MOVEQ	#3, D0	;Predicted (Code-scan)
	MOVEQ	#$0000000E, D1	;Predicted (Code-scan)
	CLR.w	D2	;Predicted (Code-scan)
	BSR.w	*+$19FE	;Predicted (Code-scan)
	MOVE.w	$2(A5), D7	;Predicted (Code-scan)
	BSR.w	*+$AAF0	;Predicted (Code-scan)
	MOVE.w	D7, $2(A5)	;Predicted (Code-scan)
	BPL.b	loc_00008856	;Predicted (Code-scan)
	MOVE.w	$2(A6), D0	;Predicted (Code-scan)
	BSR.w	*+$A96E	;Predicted (Code-scan)
	MOVE.w	#$FFFF, $2(A6)	;Predicted (Code-scan)
	TRAP	#5	;Predicted (Code-scan)
	ORI.b	#0, D1	;Predicted (Code-scan)
	dc.b	$FB, $3E ;0x0 (0x00008854-0x00008856, Entry count: 0x2) [Unknown data]
loc_00008856:
	MOVEQ	#$0000000A, D0	;Predicted (Code-scan)
	MOVEQ	#2, D1	;Predicted (Code-scan)
	MOVEQ	#$0000001C, D2	;Predicted (Code-scan)
	MOVEQ	#$0000000A, D3	;Predicted (Code-scan)
	MOVE.w	#$0043, D4	;Predicted (Code-scan)
	BSR.w	*+$AA72	;Predicted (Code-scan)
	MOVE.w	D0, $4(A6)	;Predicted (Code-scan)
	MOVEQ	#$00000017, D0	;Predicted (Code-scan)
	MOVEQ	#6, D1	;Predicted (Code-scan)
	MOVEQ	#$0000000F, D2	;Predicted (Code-scan)
	MOVEQ	#6, D3	;Predicted (Code-scan)
	MOVEQ	#3, D4	;Predicted (Code-scan)
	BSR.w	*+$A776	;Predicted (Code-scan)
	MOVEQ	#$0000000A, D0	;Predicted (Code-scan)
	MOVEQ	#$0000000C, D1	;Predicted (Code-scan)
	MOVEQ	#$00000014, D2	;Predicted (Code-scan)
	MOVEQ	#$0000000E, D3	;Predicted (Code-scan)
	MOVE.w	#$0043, D4	;Predicted (Code-scan)
	BSR.w	*+$AA50	;Predicted (Code-scan)
	MOVE.w	D0, $6(A6)	;Predicted (Code-scan)
	MOVE.w	A1, $4(A5)	;Predicted (Code-scan)
	CLR.w	$6(A5)	;Predicted (Code-scan)
loc_00008894:
	MOVEA.w	$4(A5), A1	;Predicted (Code-scan)
	MOVEQ	#$0000000B, D0	;Predicted (Code-scan)
	MOVEQ	#4, D1	;Predicted (Code-scan)
	
; weapon, armor, helmet, shield (one string with <brs> in equip menu string
	LEA	loc_000087C8(PC), A0	;Predicted (Code-scan)
	BSR.w	*+$AD86	;Predicted (Code-scan)
	MOVEQ	#$00000018, D0	;Predicted (Code-scan)
	MOVEQ	#4, D1	;Predicted (Code-scan)
	
; "item" in equip menu string
	LEA	loc_000087DE(PC), A0	;Predicted (Code-scan)
	BSR.w	*+$AD7A	;Predicted (Code-scan)
	MOVEQ	#$00000018, D0	;Predicted (Code-scan)
	MOVEQ	#7, D1	;Predicted (Code-scan)
	
; ATK / DEF in equip menu string
	LEA	loc_000087E4(PC), A0	;Predicted (Code-scan)
	BSR.w	*+$AE38	;Predicted (Code-scan)
	MOVE.w	$2(A5), D2	;Predicted (Code-scan)
	BSR.w	*+$195A	;Predicted (Code-scan)
	BSR.w	*+$192C	;Predicted (Code-scan)
	MOVEA.l	A0, A2	;Predicted (Code-scan)
	MOVE.b	$14(A2), D2	;Predicted (Code-scan)
	MOVEQ	#$0000000F, D0	;Predicted (Code-scan)
	MOVEQ	#4, D1	;Predicted (Code-scan)
	BSR.w	loc_000087F6	;Predicted (Code-scan)
	MOVE.b	$15(A2), D2	;Predicted (Code-scan)
	MOVEQ	#$0000000F, D0	;Predicted (Code-scan)
	MOVEQ	#6, D1	;Predicted (Code-scan)
	BSR.w	loc_000087F6	;Predicted (Code-scan)
	MOVE.b	$16(A2), D2	;Predicted (Code-scan)
	MOVEQ	#$0000000F, D0	;Predicted (Code-scan)
	MOVEQ	#8, D1	;Predicted (Code-scan)
	BSR.w	loc_000087F6	;Predicted (Code-scan)
	MOVE.b	$17(A2), D2	;Predicted (Code-scan)
	MOVEQ	#$0000000F, D0	;Predicted (Code-scan)
	MOVEQ	#$0000000A, D1	;Predicted (Code-scan)
	BSR.w	loc_000087F6	;Predicted (Code-scan)
	MOVE.b	$18(A2), D2	;Predicted (Code-scan)
	MOVEQ	#$0000001D, D0	;Predicted (Code-scan)
	MOVEQ	#4, D1	;Predicted (Code-scan)
	BSR.w	loc_000087F6	;Predicted (Code-scan)
	CLR.l	D2	;Predicted (Code-scan)
	MOVE.w	$A(A2), D2	;Predicted (Code-scan)
	CMPI.w	#$03E8, D2	;Predicted (Code-scan)
	BCS.b	loc_00008916	;Predicted (Code-scan)
	MOVE.w	#$03E7, D2	;Predicted (Code-scan)
loc_00008916:
	MOVEQ	#3, D3	;Predicted (Code-scan)
	MOVEQ	#$0000001F, D0	;Predicted (Code-scan)
	MOVEQ	#7, D1	;Predicted (Code-scan)
	BSR.w	*+$AE5A	;Predicted (Code-scan)
	CLR.l	D2	;Predicted (Code-scan)
	MOVE.w	$C(A2), D2	;Predicted (Code-scan)
	CMPI.w	#$03E8, D2	;Predicted (Code-scan)
	BCS.b	loc_00008930	;Predicted (Code-scan)
	MOVE.w	#$03E7, D2	;Predicted (Code-scan)
loc_00008930:
	MOVEQ	#3, D3	;Predicted (Code-scan)
	MOVEQ	#$0000001F, D0	;Predicted (Code-scan)
	MOVEQ	#9, D1	;Predicted (Code-scan)
	BSR.w	*+$AE40	;Predicted (Code-scan)
	MOVE.w	$2(A5), D2	;Predicted (Code-scan)
	BSR.w	*+$18DC	;Predicted (Code-scan)
	MOVEQ	#$0000000B, D0	;Predicted (Code-scan)
	MOVEQ	#$0000000E, D1	;Predicted (Code-scan)
	BSR.w	*+$1B6C	;Predicted (Code-scan)
	ADDQ.w	#1, D0	;Predicted (Code-scan)
	MOVE.w	$6(A5), D7	;Predicted (Code-scan)
	BSR.w	*+$A9D6	;Predicted (Code-scan)
	MOVE.w	D7, $6(A5)	;Predicted (Code-scan)
	BPL.b	loc_00008986	;Predicted (Code-scan)
	MOVEA.w	$4(A5), A1	;Predicted (Code-scan)
	MOVE.w	$6(A6), D0	;Predicted (Code-scan)
	BSR.w	*+$A850	;Predicted (Code-scan)
	MOVE.w	#$FFFF, $6(A6)	;Predicted (Code-scan)
	TRAP	#5	;Predicted (Code-scan)
	ORI.b	#$2E, D1	;Predicted (Code-scan)
	ORI.b	#0, D4	;Predicted (Code-scan)
	dc.b	$A8, $3E, $3D, $7C, $FF, $FF, $00, $04, $4E, $45, $00, $01, $60, $00, $FE, $A4 ;0x0 (0x00008976-0x00008986, Entry count: 0x10) [Unknown data]
loc_00008986:
	MOVE.w	$2(A5), D2	;Predicted (Code-scan)
	BSR.w	*+$1890	;Predicted (Code-scan)
	MOVE.w	$6(A5), D0	;Predicted (Code-scan)
	BSR.w	*+$1B86	;Predicted (Code-scan)
	BTST.l	#$0F, D0	;Predicted (Code-scan)
	BEQ.b	loc_000089A6	;Predicted (Code-scan)
	ANDI.w	#$00FF, D0	;Predicted (Code-scan)
	BSR.w	*+$1CF4	;Predicted (Code-scan)
	BRA.b	loc_000089AE	;Predicted (Code-scan)
loc_000089A6:
	MOVE.w	$6(A5), D0	;Predicted (Code-scan)
	BSR.w	*+$1C4E	;Predicted (Code-scan)
loc_000089AE:
	BRA.w	loc_00008894	;Predicted (Code-scan)
loc_000089B2:
	MOVEM.l	A6/D7/D0, -(A7)
	MOVEQ	#$0000000E, D7
loc_000089B8:
	MOVE.w	(A6,D7.w), D0
	BMI.b	loc_000089C8-2
	BSR.w	*+$A7F4
	TRAP	#5
	ORI.b	#$47, D1	;Predicted (Code-scan)
loc_000089C8:
	BPL.b	loc_000089B8
	MOVEM.l	(A7)+, D0/D7/A6
	RTS
loc_000089D0:
	BSR.w	*+$180A	;Predicted (Code-scan)
	MOVE.l	A0, $00FF3098	;Predicted (Code-scan)
	BSR.b	loc_000089B2	;Predicted (Code-scan)
	BSR.w	*+$AE22	;Predicted (Code-scan)
	
; X is dead string (lol)
	LEA	loc_00008A76(PC), A0	;Predicted (Code-scan)
	CLR.w	D0	;Predicted (Code-scan)
	BSR.w	*+$AE68	;Predicted (Code-scan)
	BSR.w	*+$AE42	;Predicted (Code-scan)
	BRA.w	loc_000083CA-2	;Predicted (Code-scan)
loc_000089F2:
	BSR.w	*+$17E8	;Predicted (Code-scan)
	MOVE.l	A0, $00FF3098	;Predicted (Code-scan)
	BSR.b	loc_000089B2	;Predicted (Code-scan)
	BSR.w	*+$AE00	;Predicted (Code-scan)
	
; X can't move string
	LEA	loc_00008A90(PC), A0	;Predicted (Code-scan)
	CLR.w	D0	;Predicted (Code-scan)
	BSR.w	*+$AE46	;Predicted (Code-scan)
	BSR.w	*+$AE20	;Predicted (Code-scan)
	BRA.w	loc_000083CA-2	;Predicted (Code-scan)
	
; stats / order string, with <br>, from a menu
	LEA	loc_00008A9A(PC), A0	;Predicted (Code-scan)
	BSR.w	*+$AC2E	;Predicted (Code-scan)
	CLR.w	$4(A5)	;Predicted (Code-scan)
loc_00008ACA:
	MOVEQ	#4, D0	;Predicted (Code-scan)
	MOVEQ	#5, D1	;Predicted (Code-scan)
	MOVEQ	#5, D2	;Predicted (Code-scan)
	MOVEQ	#1, D3	;Predicted (Code-scan)
	MOVEQ	#1, D4	;Predicted (Code-scan)
	MOVEQ	#2, D5	;Predicted (Code-scan)
	MOVEQ	#1, D6	;Predicted (Code-scan)
	MOVE.w	$4(A5), D7	;Predicted (Code-scan)
	BSR.w	*+$A84A	;Predicted (Code-scan)
	MOVE.w	D7, $4(A5)	;Predicted (Code-scan)
	BPL.b	loc_00008B00	;Predicted (Code-scan)
	MOVE.w	$2(A6), D0	;Predicted (Code-scan)
	BSR.w	*+$A6C8	;Predicted (Code-scan)
	MOVE.w	#$FFFF, $2(A6)	;Predicted (Code-scan)
	MOVEA.w	$2(A5), A1	;Predicted (Code-scan)
	TRAP	#5	;Predicted (Code-scan)
	ORI.b	#0, D1	;Predicted (Code-scan)
	dc.b	$F8, $94 ;0x0 (0x00008AFE-0x00008B00, Entry count: 0x2) [Unknown data]
loc_00008B00:
	BEQ.w	loc_00008F18	;Predicted (Code-scan)
	MOVEM.l	A0/D0, -(A7)	;Predicted (Code-scan)
	MOVE.w	#$0030, D0	;Predicted (Code-scan)
	BSR.w	*+$B016	;Predicted (Code-scan)
	MOVEA.l	A0, A4	;Predicted (Code-scan)
	MOVEM.l	(A7)+, D0/A0	;Predicted (Code-scan)
	MOVEQ	#2, D0	;Predicted (Code-scan)
	MOVEQ	#2, D1	;Predicted (Code-scan)
	MOVEQ	#9, D2	;Predicted (Code-scan)
	MOVEQ	#$0000000A, D3	;Predicted (Code-scan)
	BSR.w	*+$A5F6	;Predicted (Code-scan)
	MOVE.l	A0, $6(A5)	;Predicted (Code-scan)
	MOVEQ	#0, D0	;Predicted (Code-scan)
	MOVEQ	#0, D1	;Predicted (Code-scan)
	MOVEQ	#$00000028, D2	;Predicted (Code-scan)
	MOVEQ	#$0000001C, D3	;Predicted (Code-scan)
	MOVE.w	#$0043, D4	;Predicted (Code-scan)
	BSR.w	*+$A7A2	;Predicted (Code-scan)
	MOVE.w	D0, $4(A6)	;Predicted (Code-scan)
	BSR.w	*+$9F8E	;Predicted (Code-scan)
	BSR.w	*+$C1E8	;Predicted (Code-scan)
	CLR.l	(A4)	;Predicted (Code-scan)
	CLR.l	$4(A4)	;Predicted (Code-scan)
	CLR.l	$8(A4)	;Predicted (Code-scan)
	CLR.w	D4	;Predicted (Code-scan)
	MOVEQ	#5, D5	;Predicted (Code-scan)
	LEA	$00FFCED6, A3	;Predicted (Code-scan)
loc_00008B56:
	CLR.w	D0	;Predicted (Code-scan)
	MOVE.b	(A3,D4.w), D0	;Predicted (Code-scan)
	BEQ.b	loc_00008B7C	;Predicted (Code-scan)
	MOVE.b	D0, (A4,D4.w)	;Predicted (Code-scan)
	MOVE.w	D0, D2	;Predicted (Code-scan)
	BSR.w	*+$168C	;Predicted (Code-scan)
	CLR.w	D0	;Predicted (Code-scan)
	MOVE.b	$1(A0), D0	;Predicted (Code-scan)
	MOVE.b	D0, $C(A4,D4.w)	;Predicted (Code-scan)
	BSR.w	*+$C1E4	;Predicted (Code-scan)
	ADDQ.w	#1, D4	;Predicted (Code-scan)
	DBF	D5, loc_00008B56	;Predicted (Code-scan)
loc_00008B7C:
	CLR.w	D4	;Predicted (Code-scan)
	CLR.w	D3	;Predicted (Code-scan)
	MOVEQ	#5, D5	;Predicted (Code-scan)
loc_00008B82:
	TST.b	(A4,D4.w)	;Predicted (Code-scan)
	BEQ.b	loc_00008BB6	;Predicted (Code-scan)
	CLR.w	D0	;Predicted (Code-scan)
	MOVE.b	$C(A4,D4.w), D0	;Predicted (Code-scan)
	MOVEQ	#2, D2	;Predicted (Code-scan)
	BSR.w	*+$C274	;Predicted (Code-scan)
	MOVEA.l	A1, A0	;Predicted (Code-scan)
	MOVEA.w	D0, A1	;Predicted (Code-scan)
	MOVEQ	#$00000018, D0	;Predicted (Code-scan)
	MULU.w	D4, D0	;Predicted (Code-scan)
	ADDI.w	#$00DC, D0	;Predicted (Code-scan)
	MOVE.w	#$00C0, D1	;Predicted (Code-scan)
	ADDQ.w	#4, D2	;Predicted (Code-scan)
	BSR.w	*+$9BC0	;Predicted (Code-scan)
	MOVE.w	A0, $12(A4,D3.w)	;Predicted (Code-scan)
	ADDQ.w	#1, D4	;Predicted (Code-scan)
	ADDQ.w	#2, D3	;Predicted (Code-scan)
	DBF	D5, loc_00008B82	;Predicted (Code-scan)
loc_00008BB6:
	MOVEQ	#2, D0	;Predicted (Code-scan)
	MOVEQ	#2, D1	;Predicted (Code-scan)
	MOVEQ	#8, D2	;Predicted (Code-scan)
	MOVEQ	#$0000000E, D3	;Predicted (Code-scan)
	MOVEQ	#$00000043, D4	;Predicted (Code-scan)
	BSR.w	*+$A714	;Predicted (Code-scan)
	MOVE.w	D0, $6(A6)	;Predicted (Code-scan)
	MOVEQ	#$0000001E, D0	;Predicted (Code-scan)
	MOVEQ	#2, D1	;Predicted (Code-scan)
	MOVEQ	#8, D2	;Predicted (Code-scan)
	MOVEQ	#$0000000E, D3	;Predicted (Code-scan)
	MOVEQ	#$00000043, D4	;Predicted (Code-scan)
	BSR.w	*+$A702	;Predicted (Code-scan)
	MOVE.w	D0, $8(A6)	;Predicted (Code-scan)
	CLR.w	$A(A5)	;Predicted (Code-scan)
	CLR.w	$C(A5)	;Predicted (Code-scan)
loc_00008BE2:
	MOVE.w	$8(A6), D0	;Predicted (Code-scan)
	BSR.w	*+$A5E4	;Predicted (Code-scan)
	MOVEQ	#$0000001F, D0	;Predicted (Code-scan)
	MOVEQ	#4, D1	;Predicted (Code-scan)
	CLR.w	D4	;Predicted (Code-scan)
	MOVEQ	#5, D5	;Predicted (Code-scan)
loc_00008BF2:
	MOVE.b	$6(A4,D4.w), D2	;Predicted (Code-scan)
	BEQ.b	loc_00008C08	;Predicted (Code-scan)
	BSR.w	*+$15E2	;Predicted (Code-scan)
	BSR.w	*+$AA2A	;Predicted (Code-scan)
	ADDQ.w	#2, D1	;Predicted (Code-scan)
	ADDQ.w	#1, D4	;Predicted (Code-scan)
	DBF	D5, loc_00008BF2	;Predicted (Code-scan)
loc_00008C08:
	MOVE.w	$6(A6), D0	;Predicted (Code-scan)
	BSR.w	*+$A5BE	;Predicted (Code-scan)
	MOVEQ	#5, D5	;Predicted (Code-scan)
	CLR.w	D3	;Predicted (Code-scan)
loc_00008C14:
	TST.b	(A3,D3.w)	;Predicted (Code-scan)
	BNE.w	loc_00008C24	;Predicted (Code-scan)
	DBF	D5, loc_00008C14	;Predicted (Code-scan)
	BRA.w	loc_00008CC4	;Predicted (Code-scan)
loc_00008C24:
	MOVEQ	#3, D0	;Predicted (Code-scan)
	MOVEQ	#4, D1	;Predicted (Code-scan)
	CLR.w	D2	;Predicted (Code-scan)
	BSR.w	*+$1602	;Predicted (Code-scan)
	MOVE.w	$C(A5), D7	;Predicted (Code-scan)
	BSR.w	*+$A6F4	;Predicted (Code-scan)
	TST.w	D7	;Predicted (Code-scan)
	BPL.b	loc_00008C82	;Predicted (Code-scan)
	MOVE.w	$A(A5), D3	;Predicted (Code-scan)
	BEQ.w	loc_00008E7C	;Predicted (Code-scan)
	SUBQ.w	#1, D3	;Predicted (Code-scan)
	MOVE.w	D3, $A(A5)	;Predicted (Code-scan)
	CLR.b	$6(A4,D3.w)	;Predicted (Code-scan)
	CLR.w	D3	;Predicted (Code-scan)
	CLR.w	D4	;Predicted (Code-scan)
loc_00008C50:
	MOVE.b	(A4,D4.w), D0	;Predicted (Code-scan)
	CLR.w	D5	;Predicted (Code-scan)
loc_00008C56:
	CMP.b	$6(A4,D5.w), D0	;Predicted (Code-scan)
	BEQ.b	loc_00008C6A	;Predicted (Code-scan)
	ADDQ.w	#1, D5	;Predicted (Code-scan)
	CMPI.w	#6, D5	;Predicted (Code-scan)
	BNE.b	loc_00008C56	;Predicted (Code-scan)
	MOVE.b	D0, (A3,D3.w)	;Predicted (Code-scan)
	ADDQ.w	#1, D3	;Predicted (Code-scan)
loc_00008C6A:
	ADDQ.w	#1, D4	;Predicted (Code-scan)
	CMPI.w	#6, D4	;Predicted (Code-scan)
	BNE.b	loc_00008C50	;Predicted (Code-scan)
loc_00008C72:
	CMPI.w	#6, D3	;Predicted (Code-scan)
	BEQ.w	loc_00008BE2	;Predicted (Code-scan)
	CLR.b	(A3,D3.w)	;Predicted (Code-scan)
	ADDQ.w	#1, D3	;Predicted (Code-scan)
	BRA.b	loc_00008C72	;Predicted (Code-scan)
loc_00008C82:
	MOVE.w	D7, $C(A5)	;Predicted (Code-scan)
	MOVE.b	(A3,D7.w), D0	;Predicted (Code-scan)
	TST.w	$A(A5)	;Predicted (Code-scan)
	BNE.b	loc_00008CA0	;Predicted (Code-scan)
	CLR.w	D2	;Predicted (Code-scan)
	MOVE.b	D0, D2	;Predicted (Code-scan)
	BSR.w	*+$155C	;Predicted (Code-scan)
	TST.w	$2(A0)	;Predicted (Code-scan)
	BNE.b	loc_00008CA0	;Predicted (Code-scan)
	BRA.b	loc_00008C24	;Predicted (Code-scan)
loc_00008CA0:
	MOVE.w	$A(A5), D3	;Predicted (Code-scan)
	MOVE.b	D0, $6(A4,D3.w)	;Predicted (Code-scan)
	ADDQ.w	#1, $A(A5)	;Predicted (Code-scan)
loc_00008CAC:
	CMPI.w	#5, D7	;Predicted (Code-scan)
	BEQ.b	loc_00008CBC	;Predicted (Code-scan)
	MOVE.b	$1(A3,D7.w), (A3,D7.w)	;Predicted (Code-scan)
	ADDQ.w	#1, D7	;Predicted (Code-scan)
	BRA.b	loc_00008CAC	;Predicted (Code-scan)
loc_00008CBC:
	CLR.b	(A3,D7.w)	;Predicted (Code-scan)
	BRA.w	loc_00008BE2	;Predicted (Code-scan)
loc_00008CC4:
	CLR.w	D6	;Predicted (Code-scan)
	CLR.w	D4	;Predicted (Code-scan)
loc_00008CC8:
	MOVE.w	D4, D3	;Predicted (Code-scan)
	MOVE.b	(A4,D4.w), D0	;Predicted (Code-scan)
	BEQ.b	loc_00008CDC	;Predicted (Code-scan)
	CLR.w	D3	;Predicted (Code-scan)
loc_00008CD2:
	CMP.b	$6(A4,D3.w), D0	;Predicted (Code-scan)
	BEQ.b	loc_00008CDC	;Predicted (Code-scan)
	ADDQ.w	#1, D3	;Predicted (Code-scan)
	BRA.b	loc_00008CD2	;Predicted (Code-scan)
loc_00008CDC:
	SUB.w	D4, D3	;Predicted (Code-scan)
	MULS.w	#$000C, D3	;Predicted (Code-scan)
	BEQ.b	loc_00008CFC	;Predicted (Code-scan)
	BPL.b	loc_00008CF2	;Predicted (Code-scan)
	NEG.l	D3	;Predicted (Code-scan)
	MOVE.b	#1, $24(A4,D4.w)	;Predicted (Code-scan)
	ADDQ.w	#1, D6	;Predicted (Code-scan)
	BRA.b	loc_00008D00	;Predicted (Code-scan)
loc_00008CF2:
	MOVE.b	#4, $24(A4,D4.w)	;Predicted (Code-scan)
	ADDQ.w	#1, D6	;Predicted (Code-scan)
	BRA.b	loc_00008D00	;Predicted (Code-scan)
loc_00008CFC:
	CLR.b	$24(A4,D4.w)	;Predicted (Code-scan)
loc_00008D00:
	MOVE.b	D3, $1E(A4,D4.w)	;Predicted (Code-scan)
	CLR.b	$2A(A4,D4.w)	;Predicted (Code-scan)
	ADDQ.w	#1, D4	;Predicted (Code-scan)
	CMPI.w	#6, D4	;Predicted (Code-scan)
	BNE.b	loc_00008CC8	;Predicted (Code-scan)
	TST.w	D6	;Predicted (Code-scan)
	BEQ.w	loc_00008E54	;Predicted (Code-scan)
	CLR.w	D4	;Predicted (Code-scan)
	CLR.w	D5	;Predicted (Code-scan)
loc_00008D1A:
	TST.b	(A4,D4.w)	;Predicted (Code-scan)
	BEQ.w	loc_00008E4C	;Predicted (Code-scan)
	MOVE.b	$24(A4,D4.w), D0	;Predicted (Code-scan)
	BEQ.w	loc_00008E40	;Predicted (Code-scan)
	CMPI.b	#1, D0	;Predicted (Code-scan)
	BEQ.b	loc_00008D54	;Predicted (Code-scan)
	CMPI.b	#2, D0	;Predicted (Code-scan)
	BEQ.w	loc_00008DE0	;Predicted (Code-scan)
	CMPI.b	#3, D0	;Predicted (Code-scan)
	BEQ.b	loc_00008D76	;Predicted (Code-scan)
	CMPI.b	#4, D0	;Predicted (Code-scan)
	BEQ.b	loc_00008D76	;Predicted (Code-scan)
	CMPI.b	#5, D0	;Predicted (Code-scan)
	BEQ.w	loc_00008E02	;Predicted (Code-scan)
	CMPI.b	#6, D0	;Predicted (Code-scan)
	BEQ.b	loc_00008D54	;Predicted (Code-scan)
loc_00008D52:
	BRA.b	loc_00008D52	;Predicted (Code-scan)
loc_00008D54:
	TST.b	$2A(A4,D4.w)	;Predicted (Code-scan)
	BNE.b	loc_00008D6E	;Predicted (Code-scan)
	CLR.w	D0	;Predicted (Code-scan)
	MOVE.b	$C(A4,D4.w), D0	;Predicted (Code-scan)
	MOVEQ	#1, D2	;Predicted (Code-scan)
	BSR.w	*+$C0A2	;Predicted (Code-scan)
	MOVEA.w	$12(A4,D5.w), A0	;Predicted (Code-scan)
	BSR.w	*+$9CE8	;Predicted (Code-scan)
loc_00008D6E:
	CLR.w	D0	;Predicted (Code-scan)
	MOVE.w	#$FF80, D1	;Predicted (Code-scan)
	BRA.b	loc_00008D96	;Predicted (Code-scan)
loc_00008D76:
	TST.b	$2A(A4,D4.w)	;Predicted (Code-scan)
	BNE.b	loc_00008D90	;Predicted (Code-scan)
	CLR.w	D0	;Predicted (Code-scan)
	MOVE.b	$C(A4,D4.w), D0	;Predicted (Code-scan)
	MOVEQ	#0, D2	;Predicted (Code-scan)
	BSR.w	*+$C080	;Predicted (Code-scan)
	MOVEA.w	$12(A4,D5.w), A0	;Predicted (Code-scan)
	BSR.w	*+$9CC6	;Predicted (Code-scan)
loc_00008D90:
	CLR.w	D0	;Predicted (Code-scan)
	MOVE.w	#$0080, D1	;Predicted (Code-scan)
loc_00008D96:
	MOVEA.w	$12(A4,D5.w), A0	;Predicted (Code-scan)
	BSR.w	*+$9A42	;Predicted (Code-scan)
	ADDQ.b	#1, $2A(A4,D4.w)	;Predicted (Code-scan)
	CMPI.b	#$0C, $2A(A4,D4.w)	;Predicted (Code-scan)
	BNE.w	loc_00008E40	;Predicted (Code-scan)
	CLR.b	$2A(A4,D4.w)	;Predicted (Code-scan)
	ADDQ.b	#1, $24(A4,D4.w)	;Predicted (Code-scan)
	CMPI.b	#4, $24(A4,D4.w)	;Predicted (Code-scan)
	BEQ.b	loc_00008DC4	;Predicted (Code-scan)
	CMPI.b	#7, $24(A4,D4.w)	;Predicted (Code-scan)
	BNE.b	loc_00008E40	;Predicted (Code-scan)
loc_00008DC4:
	CLR.b	$24(A4,D4.w)	;Predicted (Code-scan)
	SUBQ.w	#1, D6	;Predicted (Code-scan)
	CLR.w	D0	;Predicted (Code-scan)
	MOVE.b	$C(A4,D4.w), D0	;Predicted (Code-scan)
	MOVEQ	#2, D2	;Predicted (Code-scan)
	BSR.w	*+$C032	;Predicted (Code-scan)
	MOVEA.w	$12(A4,D5.w), A0	;Predicted (Code-scan)
	BSR.w	*+$9C78	;Predicted (Code-scan)
	BRA.b	loc_00008E40	;Predicted (Code-scan)
loc_00008DE0:
	TST.b	$2A(A4,D4.w)	;Predicted (Code-scan)
	BNE.b	loc_00008DFA	;Predicted (Code-scan)
	CLR.w	D0	;Predicted (Code-scan)
	MOVE.b	$C(A4,D4.w), D0	;Predicted (Code-scan)
	MOVEQ	#2, D2	;Predicted (Code-scan)
	BSR.w	*+$C016	;Predicted (Code-scan)
	MOVEA.w	$12(A4,D5.w), A0	;Predicted (Code-scan)
	BSR.w	*+$9C5C	;Predicted (Code-scan)
loc_00008DFA:
	MOVE.w	#$FF80, D0	;Predicted (Code-scan)
	CLR.w	D1	;Predicted (Code-scan)
	BRA.b	loc_00008E22	;Predicted (Code-scan)
loc_00008E02:
	TST.b	$2A(A4,D4.w)	;Predicted (Code-scan)
	BNE.b	loc_00008E1C	;Predicted (Code-scan)
	CLR.w	D0	;Predicted (Code-scan)
	MOVE.b	$C(A4,D4.w), D0	;Predicted (Code-scan)
	MOVEQ	#3, D2	;Predicted (Code-scan)
	BSR.w	*+$BFF4	;Predicted (Code-scan)
	MOVEA.w	$12(A4,D5.w), A0	;Predicted (Code-scan)
	BSR.w	*+$9C3A	;Predicted (Code-scan)
loc_00008E1C:
	MOVE.w	#$0080, D0	;Predicted (Code-scan)
	CLR.w	D1	;Predicted (Code-scan)
loc_00008E22:
	MOVEA.w	$12(A4,D5.w), A0	;Predicted (Code-scan)
	BSR.w	*+$99B6	;Predicted (Code-scan)
	ADDQ.b	#1, $2A(A4,D4.w)	;Predicted (Code-scan)
	MOVE.b	$2A(A4,D4.w), D0	;Predicted (Code-scan)
	CMP.b	$1E(A4,D4.w), D0	;Predicted (Code-scan)
	BNE.b	loc_00008E40	;Predicted (Code-scan)
	CLR.b	$2A(A4,D4.w)	;Predicted (Code-scan)
	ADDQ.b	#1, $24(A4,D4.w)	;Predicted (Code-scan)
loc_00008E40:
	ADDQ.w	#1, D4	;Predicted (Code-scan)
	ADDQ.w	#2, D5	;Predicted (Code-scan)
	CMPI.w	#6, D4	;Predicted (Code-scan)
	BNE.w	loc_00008D1A	;Predicted (Code-scan)
loc_00008E4C:
	TRAP	#5	;Predicted (Code-scan)
	ORI.b	#0, D1	;Predicted (Code-scan)
	dc.b	$FE, $BE ;0x0 (0x00008E52-0x00008E54, Entry count: 0x2) [Unknown data]
loc_00008E54:
	TRAP	#5	;Predicted (Code-scan)
	ORI.b	#$39, D1	;Predicted (Code-scan)
	dc.b	$00, $FF, $27, $DA, $02, $00, $00, $70, $67, $F0, $42, $44, $7A, $05, $17, $B4, $40, $06, $40, $00, $52, $44, $51, $CD, $FF, $F6, $30, $3C, $00, $68, $61, $00 ;0x0 (0x00008E5A-0x00008E7C, Entry count: 0x22) [Unknown data]
	dc.b	$94, $FC ;0x20
loc_00008E7C:
	CLR.w	D4	;Predicted (Code-scan)
	CLR.w	D3	;Predicted (Code-scan)
	MOVEQ	#5, D5	;Predicted (Code-scan)
loc_00008E82:
	TST.b	(A4,D4.w)	;Predicted (Code-scan)
	BEQ.b	loc_00008E98	;Predicted (Code-scan)
	MOVEA.w	$12(A4,D3.w), A0	;Predicted (Code-scan)
	BSR.w	*+$9932	;Predicted (Code-scan)
	ADDQ.w	#1, D4	;Predicted (Code-scan)
	ADDQ.w	#2, D3	;Predicted (Code-scan)
	DBF	D5, loc_00008E82	;Predicted (Code-scan)
loc_00008E98:
	TRAP	#5	;Predicted (Code-scan)
	ORI.b	#0, D1	;Predicted (Code-scan)
	CMP.l	A2, D7	;Predicted (Code-scan)
	BSR.w	loc_00008118	;Predicted (Code-scan)
	BSR.w	*+$F30	;Predicted (Code-scan)
	BSR.w	*+$67D8	;Predicted (Code-scan)
	BSR.w	*+$ECDC	;Predicted (Code-scan)
	BSR.w	*+$9C4C	;Predicted (Code-scan)
	CMPI.b	#1, $00FFCAB8	;Predicted (Code-scan)
	BNE.b	loc_00008EC8	;Predicted (Code-scan)
	MOVEA.w	$00FFCABA, A0	;Predicted (Code-scan)
	BSR.w	*+$9BBC	;Predicted (Code-scan)
loc_00008EC8:
	MOVE.w	$8(A6), D0	;Predicted (Code-scan)
	BSR.w	*+$A2E6	;Predicted (Code-scan)
	MOVE.w	#$FFFF, $8(A6)	;Predicted (Code-scan)
	MOVE.w	$6(A6), D0	;Predicted (Code-scan)
	BSR.w	*+$A2D8	;Predicted (Code-scan)
	MOVE.w	#$FFFF, $6(A6)	;Predicted (Code-scan)
	MOVE.w	$4(A6), D0	;Predicted (Code-scan)
	BSR.w	*+$A2CA	;Predicted (Code-scan)
	MOVE.w	#$FFFF, $4(A6)	;Predicted (Code-scan)
	TRAP	#5	;Predicted (Code-scan)
	ORI.b	#2, D1	;Predicted (Code-scan)
	MOVEQ	#2, D1	;Predicted (Code-scan)
	MOVEQ	#9, D2	;Predicted (Code-scan)
	MOVEQ	#$0000000A, D3	;Predicted (Code-scan)
	MOVEA.l	$6(A5), A0	;Predicted (Code-scan)
	BSR.w	*+$A242	;Predicted (Code-scan)
	TRAP	#5	;Predicted (Code-scan)
	ORI.b	#8, D1	;Predicted (Code-scan)
	MOVEA.l	A4, A0	;Predicted (Code-scan)
	BSR.w	*+$AC88	;Predicted (Code-scan)
	MOVEA.l	(A7)+, A0	;Predicted (Code-scan)
	BRA.w	loc_00008ACA	;Predicted (Code-scan)
loc_00008F18:
	MOVEQ	#$0000000B, D0	;Predicted (Code-scan)
	MOVEQ	#2, D1	;Predicted (Code-scan)
	MOVEQ	#$0000001B, D2	;Predicted (Code-scan)
	MOVEQ	#$0000000E, D3	;Predicted (Code-scan)
	MOVEQ	#$00000043, D4	;Predicted (Code-scan)
	BSR.w	*+$A3B2	;Predicted (Code-scan)
	MOVE.w	D0, $4(A6)	;Predicted (Code-scan)
	CLR.w	$6(A5)	;Predicted (Code-scan)
	MOVEQ	#$0000000C, D0	;Predicted (Code-scan)
	MOVEQ	#4, D1	;Predicted (Code-scan)
	MOVEQ	#2, D2	;Predicted (Code-scan)
	BSR.w	*+$12F8	;Predicted (Code-scan)
	MOVE.w	$6(A5), D7	;Predicted (Code-scan)
	BSR.w	*+$A3EA	;Predicted (Code-scan)
	TST.w	D7	;Predicted (Code-scan)
	BPL.b	loc_00008F5A	;Predicted (Code-scan)
	MOVE.w	$4(A6), D0	;Predicted (Code-scan)
	BSR.w	*+$A26A	;Predicted (Code-scan)
	MOVE.w	#$FFFF, $4(A6)	;Predicted (Code-scan)
	TRAP	#5	;Predicted (Code-scan)
	ORI.b	#0, D1	;Predicted (Code-scan)
	dc.b	$FB, $72 ;0x0 (0x00008F58-0x00008F5A, Entry count: 0x2) [Unknown data]
loc_00008F5A:
	MOVE.w	D7, $6(A5)	;Predicted (Code-scan)
	MOVE.w	A1, $8(A5)	;Predicted (Code-scan)
	MOVEQ	#2, D0	;Predicted (Code-scan)
	MOVEQ	#2, D1	;Predicted (Code-scan)
	MOVEQ	#$00000024, D2	;Predicted (Code-scan)
	MOVEQ	#$0000000E, D3	;Predicted (Code-scan)
	BSR.w	*+$A1AA	;Predicted (Code-scan)
	MOVE.l	A0, $A(A5)	;Predicted (Code-scan)
	MOVEQ	#0, D0	;Predicted (Code-scan)
	MOVEQ	#0, D1	;Predicted (Code-scan)
	MOVEQ	#$00000028, D2	;Predicted (Code-scan)
	MOVEQ	#$0000001C, D3	;Predicted (Code-scan)
	MOVE.w	#$0043, D4	;Predicted (Code-scan)
	BSR.w	*+$A356	;Predicted (Code-scan)
	MOVE.w	D0, $6(A6)	;Predicted (Code-scan)
	MOVEQ	#$0000001A, D0	;Predicted (Code-scan)
	MOVEQ	#0, D1	;Predicted (Code-scan)
	MOVEQ	#$0000000E, D2	;Predicted (Code-scan)
	MOVEQ	#4, D3	;Predicted (Code-scan)
	MOVEQ	#3, D4	;Predicted (Code-scan)
	BSR.w	*+$A05A	;Predicted (Code-scan)
	BSR.w	*+$9B34	;Predicted (Code-scan)
	MOVE.w	$6(A5), D2	;Predicted (Code-scan)
	BSR.w	*+$127E	;Predicted (Code-scan)
	MOVE.w	D2, $E(A5)	;Predicted (Code-scan)
	BSR.w	*+$124C	;Predicted (Code-scan)
	MOVEA.l	A0, A4	;Predicted (Code-scan)
	SUBQ.b	#1, D2	;Predicted (Code-scan)
	EXT.w	D2	;Predicted (Code-scan)
	MULU.w	#$000C, D2	;Predicted (Code-scan)
; end of stats effect page strings ?
	LEA	*+$92A8, A3	;Predicted (Code-scan)
	ADDA.l	D2, A3	;Predicted (Code-scan)
	MOVEM.l	A6/A5, -(A7)	;Predicted (Code-scan)
	MOVEA.l	(A3), A6	;Predicted (Code-scan)
	MOVEA.l	#$00005000, A5	;Predicted (Code-scan)
	BSR.w	*+$93BE	;Predicted (Code-scan)
	MOVEM.l	(A7)+, A5/A6	;Predicted (Code-scan)
	MOVEA.l	$4(A3), A0	;Predicted (Code-scan)
	MOVEQ	#$0000000F, D0	;Predicted (Code-scan)
	MOVEQ	#2, D1	;Predicted (Code-scan)
	BSR.w	*+$8F82	;Predicted (Code-scan)
	MOVEA.l	$8(A3), A0	;Predicted (Code-scan)
	MOVEA.w	#$5000, A1	;Predicted (Code-scan)
	MOVE.w	#$0098, D0	;Predicted (Code-scan)
	MOVE.w	#$0098, D1	;Predicted (Code-scan)
	MOVEQ	#4, D2	;Predicted (Code-scan)
	BSR.w	*+$977C	;Predicted (Code-scan)
	MOVE.w	A0, $10(A5)	;Predicted (Code-scan)
	TRAP	#5	;Predicted (Code-scan)
	ORI.b	#$7C, D1	;Predicted (Code-scan)
	ADDQ.b	#4, D0	;Predicted (Code-scan)
	MOVE.w	$E(A5), D2	;Predicted (Code-scan)
	dc.b	$61, $00 ;0x0 (0x00008FFE-0x00009000, Entry count: 0x2) [Unknown data]
