; ########################################################################################
; # Generated by the active disassembly feature of the Exodus emulation platform
; #
; # Creation Date:   2020-12-31 20:43:19
; # Analysis Region: 0x0000A000 - 0x0000B000
; ########################################################################################

 org $0000A000

	dc.b	$00, $FF, $D6, $44, $41, $F9, $00, $FF, $D6, $48, $42, $58, $42, $98, $42, $98, $41, $F9, $00, $FF, $D6, $54, $70, $1F, $42, $58, $51, $C8, $FF, $FC, $41, $F9 ;0x0 (0x0000A000-0x0000A1F2, Entry count: 0x1F2) [Unknown data]
	dc.b	$00, $FF, $D6, $96, $30, $3C, $02, $05, $42, $58, $51, $C8, $FF, $FC, $4C, $DF, $01, $01, $4E, $75, $48, $E7, $80, $C0, $41, $F9, $00, $FF, $CE, $DC, $30, $3C ;0x20
	dc.b	$02, $F7, $42, $58, $51, $C8, $FF, $FC, $43, $FA, $00, $12, $30, $3C, $00, $84, $30, $D9, $51, $C8, $FF, $FC, $4C, $DF, $03, $01, $4E, $75, $2E, $30, $23, $10 ;0x40
	dc.b	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $2E, $30, $23, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $2E, $30, $23, $12, $00, $00, $00, $00 ;0x60
	dc.b	$00, $00, $00, $00, $00, $00, $2E, $30, $23, $13, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $2E, $30, $23, $14, $00, $00, $00, $00, $00, $00, $00, $00 ;0x80
	dc.b	$00, $00, $2E, $30, $23, $15, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $2E, $30, $23, $16, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $2E, $30 ;0xA0
	dc.b	$23, $17, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $2E, $30, $23, $18, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $2E, $30, $23, $19, $00, $00 ;0xC0
	dc.b	$00, $00, $00, $00, $00, $00, $00, $00, $2E, $30, $23, $11, $10, $00, $00, $00, $00, $00, $00, $00, $00, $00, $2E, $30, $23, $11, $11, $00, $00, $7B, $00, $00 ;0xE0
	dc.b	$00, $00, $00, $00, $2E, $30, $23, $11, $12, $00, $00, $00, $00, $00, $00, $00, $00, $00, $2E, $30, $23, $11, $13, $00, $00, $00, $00, $00, $00, $00, $00, $00 ;0x100
	dc.b	$2E, $30, $23, $11, $14, $00, $00, $00, $00, $00, $00, $00, $00, $00, $2E, $30, $23, $11, $15, $00, $00, $00, $00, $00, $00, $00, $00, $00, $2E, $30, $23, $11 ;0x120
	dc.b	$16, $00, $00, $00, $00, $00, $00, $00, $00, $00, $2E, $30, $23, $11, $17, $00, $00, $00, $00, $00, $00, $00, $00, $00, $2E, $30, $23, $11, $18, $00, $00, $00 ;0x140
	dc.b	$00, $00, $00, $00, $00, $00, $48, $E7, $21, $C0, $41, $F9, $00, $FF, $CE, $DC, $7E, $12, $B4, $10, $67, $38, $D0, $FC, $00, $50, $51, $CF, $FF, $F6, $41, $F9 ;0x160
	dc.b	$00, $FF, $CE, $DC, $7E, $12, $4A, $10, $67, $0A, $D0, $FC, $00, $50, $51, $CF, $FF, $F6, $60, $1A, $10, $C2, $48, $82, $53, $42, $C4, $FC, $00, $50, $43, $F9 ;0x180
	dc.b	$00, $00, $B3, $97, $D3, $C2, $74, $4E, $10, $D9, $51, $CA, $FF, $FC, $4C, $DF, $03, $84, $4E, $75, $48, $E7, $01, $80, $41, $F9, $00, $FF, $CE, $DC, $7E, $12 ;0x1A0
	dc.b	$B4, $10, $67, $0A, $D0, $FC, $00, $50, $51, $CF, $FF, $F6, $60, $08, $7E, $27, $42, $58, $51, $CF, $FF, $FC, $4C, $DF, $01, $80, $4E, $75, $2F, $02, $41, $F9 ;0x1C0
	dc.b	$00, $FF, $D4, $CC, $48, $82, $53, $42, $C4, $FC, $00, $0E, $D1, $C2, $24, $1F, $4E, $75 ;0x1E0
loc_0000A1F2:
	MOVE.l	D0, -(A7)
	LEA	$00FFCEDC, A0
	MOVEQ	#$00000012, D0
loc_0000A1FC:
	TST.b	(A0)
	BEQ.b	loc_0000A204
	CMP.b	(A0), D2
	BEQ.b	loc_0000A214
loc_0000A204:
	ADDA.w	#$0050, A0	;Predicted (Code-scan)
	DBF	D0, loc_0000A1FC	;Predicted (Code-scan)
	CLR.w	D0	;Predicted (Code-scan)
	MOVEM.l	(A7)+, D0	;Predicted (Code-scan)
	RTS	;Predicted (Code-scan)
loc_0000A214:
	MOVEQ	#1, D0
	MOVEM.l	(A7)+, D0
	RTS
	MOVE.l	A0, -(A7)
	EXT.w	D2
	LEA	$00FFCED6, A0
	MOVE.b	(A0,D2.w), D2
	MOVEA.l	(A7)+, A0
	RTS
	dc.b	$48, $E7, $00, $C0, $48, $E7, $C0, $00, $36, $02, $08, $03, $00, $01, $67, $14, $48, $E7, $C0, $00, $61, $00, $E8, $12, $5E, $40, $53, $41, $61, $00, $94, $36 ;0x0 (0x0000A22E-0x0000A384, Entry count: 0x156) [Unknown data]
	dc.b	$4C, $DF, $00, $03, $43, $F9, $00, $FF, $CE, $D6, $78, $05, $42, $45, $42, $46, $14, $31, $60, $00, $67, $00, $00, $BE, $08, $03, $00, $00, $67, $1A, $0C, $02 ;0x20
	dc.b	$00, $01, $67, $14, $0C, $02, $00, $02, $67, $0E, $0C, $02, $00, $09, $67, $08, $0C, $02, $00, $0E, $65, $00, $00, $98, $61, $00, $FF, $54, $61, $00, $93, $9C ;0x40
	dc.b	$08, $03, $00, $01, $67, $00, $00, $84, $48, $E7, $F0, $40, $61, $00, $FF, $56, $22, $48, $42, $82, $34, $29, $00, $02, $76, $03, $5E, $40, $61, $00, $94, $88 ;0x60
	dc.b	$41, $FA, $00, $92, $56, $40, $61, $00, $93, $CC, $34, $29, $00, $04, $52, $40, $61, $00, $94, $74, $34, $29, $00, $06, $58, $40, $61, $00, $94, $6A, $41, $FA ;0x80
	dc.b	$00, $74, $56, $40, $61, $00, $93, $AE, $34, $29, $00, $08, $52, $40, $61, $00, $94, $56, $58, $40, $14, $29, $00, $19, $08, $02, $00, $02, $67, $0A, $41, $FA ;0xA0
	dc.b	$00, $56, $61, $00, $93, $36, $60, $1E, $08, $02, $00, $01, $67, $0A, $41, $FA, $00, $4A, $61, $00, $93, $26, $60, $0E, $08, $02, $00, $00, $67, $08, $61, $00 ;0xC0
	dc.b	$E7, $50, $61, $00, $93, $16, $4C, $DF, $02, $0F, $54, $41, $52, $45, $52, $46, $51, $CC, $FF, $3E, $4C, $DF, $00, $03, $74, $05, $76, $00, $78, $01, $3C, $05 ;0xE0
	dc.b	$53, $46, $4C, $DF, $03, $00, $4E, $75, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $3E, $00, $81, $8B, $00, $00, $9E, $9A, $00, $00, $00, $00 ;0x100
	dc.b	$00, $00, $48, $E7, $80, $40, $43, $F9, $00, $FF, $CE, $D6, $42, $40, $10, $19, $67, $FC, $0C, $00, $00, $01, $67, $12, $0C, $00, $00, $02, $67, $0C, $0C, $00 ;0x120
	dc.b	$00, $09, $67, $06, $0C, $00, $00, $0E, $65, $E4, $51, $CA, $FF, $E2, $34, $00, $4C, $DF, $02, $01, $4E, $75 ;0x140
loc_0000A384:
	MOVEM.l	A0/D7/D5/D4/D3/D2/D1/D0, -(A7)
	MOVE.w	D2, D5
	MOVE.w	D3, D7
	MOVEQ	#5, D4
	CLR.w	D6
	CLR.w	D3
loc_0000A392:
	LEA	loc_0000A44E(PC), A0
	BSR.w	*+$9290
	TST.w	D7
	BNE.b	loc_0000A3A6
	CLR.w	D2	;Predicted (Code-scan)
	MOVE.b	(A1,D3.w), D2	;Predicted (Code-scan)
	BRA.b	loc_0000A3AA	;Predicted (Code-scan)
loc_0000A3A6:
	MOVE.w	(A1,D3.w), D2
loc_0000A3AA:
	BEQ.b	loc_0000A3DE
	MOVE.l	D2, -(A7)
	BTST.l	#$0F, D2
	BEQ.b	loc_0000A3BA
	MOVE.w	#$E56F, D2
	BRA.b	loc_0000A3BE
loc_0000A3BA:
	MOVE.w	#$E52F, D2	;Predicted (Code-scan)
loc_0000A3BE:
	MOVEA.w	#$C000, A0
	JSR	$00001DEE
	MOVE.l	(A7)+, D2
	ADDQ.w	#1, D0
	BSR.w	loc_0000A458
	BSR.w	*+$9256
	ADDQ.w	#8, D0
	ADDQ.w	#1, D6
	ADDQ.w	#1, D3
	ADD.w	D7, D3
	BRA.b	loc_0000A3E6
loc_0000A3DE:
	ADDI.w	#9, D0
	ADDQ.w	#1, D3
	ADD.w	D7, D3
loc_0000A3E6:
	TST.w	D5
	BEQ.b	loc_0000A43E
	LEA	loc_0000A44E(PC), A0
	BSR.w	*+$9238
	TST.w	D7
	BNE.b	loc_0000A3FE
	CLR.w	D2	;Predicted (Code-scan)
	MOVE.b	(A1,D3.w), D2	;Predicted (Code-scan)
	BRA.b	loc_0000A402	;Predicted (Code-scan)
loc_0000A3FE:
	MOVE.w	(A1,D3.w), D2
loc_0000A402:
	BEQ.b	loc_0000A43A
	MOVE.l	D2, -(A7)
	BTST.l	#$0F, D2
	BEQ.b	loc_0000A412
	MOVE.w	#$E56F, D2
	BRA.b	loc_0000A416
loc_0000A412:
	MOVE.w	#$E52F, D2	;Predicted (Code-scan)
loc_0000A416:
	MOVEA.w	#$C000, A0
	JSR	$00001DEE
	MOVE.l	(A7)+, D2
	ADDQ.w	#1, D0
	BSR.w	loc_0000A458
	BSR.w	*+$91FE
	SUBI.w	#$000A, D0
	ADDQ.w	#2, D1
	ADDQ.w	#1, D6
	ADDQ.w	#1, D3
	ADD.w	D7, D3
	BRA.b	loc_0000A444
loc_0000A43A:
	ADDQ.w	#1, D3
	ADD.w	D7, D3
loc_0000A43E:
	SUBI.w	#9, D0
	ADDQ.w	#2, D1
loc_0000A444:
	DBF	D4, loc_0000A392
	MOVEM.l	(A7)+, D0/D1/D2/D3/D4/D5/D7/A0	;Predicted (Code-scan)
	RTS	;Predicted (Code-scan)
loc_0000A44E:
	dc.b	$3F ;0x0 (0x0000A44E-0x0000A44F, Entry count: 0x1)
	dc.b	$3F, $3F, $3F, $3F, $3F, $3F, $3F, $3F, $00 ;0x0 (0x0000A44F-0x0000A458, Entry count: 0x9)
loc_0000A458:
	MOVE.l	D2, -(A7)
	LEA	$000130C6, A0
	ANDI.w	#$00FF, D2
	SUBQ.w	#1, D2
	MULU.w	#$0020, D2
	ADDA.l	D2, A0
	MOVE.l	(A7)+, D2
	RTS
	dc.b	$2F, $08, $61, $E4, $42, $80, $30, $28, $00, $1E, $20, $5F, $4E, $75, $2F, $08, $30, $02, $41, $F9, $00, $01, $30, $DC, $02, $40, $00, $FF, $53, $40, $C0, $FC ;0x0 (0x0000A470-0x0000A4B4, Entry count: 0x44) [Unknown data]
	dc.b	$00, $20, $D1, $C0, $20, $10, $20, $5F, $4E, $75, $2F, $08, $41, $F9, $00, $01, $30, $D8, $02, $42, $00, $FF, $53, $42, $C4, $FC, $00, $20, $D1, $C2, $24, $10 ;0x20
	dc.b	$20, $5F, $4E, $75 ;0x40
	MOVEM.l	A1/A0, -(A7)
	BSR.w	loc_0000A1F2
	MOVEA.l	A0, A1
	ADDA.w	#$001A, A1
	MOVEQ	#1, D2
	MOVEQ	#1, D3
	BSR.w	loc_0000A384
	TST.w	D6	;Predicted (Code-scan)
	BNE.b	loc_0000A4D8	;Predicted (Code-scan)
	BSR.w	*+$E596	;Predicted (Code-scan)
	ADDQ.w	#1, D0	;Predicted (Code-scan)
	BSR.w	*+$9152	;Predicted (Code-scan)
loc_0000A4D8:
	MOVEQ	#7, D2	;Predicted (Code-scan)
	MOVEQ	#0, D3	;Predicted (Code-scan)
	MOVEQ	#2, D4	;Predicted (Code-scan)
	MOVEQ	#6, D5	;Predicted (Code-scan)
	SUBQ.w	#1, D6	;Predicted (Code-scan)
	MOVEM.l	(A7)+, A0/A1	;Predicted (Code-scan)
	RTS	;Predicted (Code-scan)
	dc.b	$00, $00, $00, $00, $00, $00, $00, $00, $48, $E7, $C0, $C0, $70, $0B, $4A, $50, $66, $14, $22, $48, $22, $00, $4A, $51, $66, $08, $54, $49, $51, $C9, $FF, $F8 ;0x0 (0x0000A4E8-0x0000B000, Entry count: 0xB18) [Unknown data]
	dc.b	$60, $0A, $30, $91, $42, $51, $54, $48, $51, $C8, $FF, $E4, $4C, $DF, $03, $03, $4E, $75, $2F, $08, $61, $00, $FC, $D4, $48, $80, $E3, $48, $30, $30, $00, $1A ;0x20
	dc.b	$20, $5F, $4E, $75, $48, $E7, $40, $80, $61, $00, $FC, $C0, $D0, $FC, $00, $1A, $72, $0B, $4A, $50, $67, $0A, $54, $48, $51, $C9, $FF, $F8, $42, $40, $60, $02 ;0x40
	dc.b	$30, $80, $4C, $DF, $01, $02, $4E, $75, $48, $E7, $50, $80, $61, $00, $FC, $9C, $D0, $FC, $00, $1A, $72, $0B, $36, $10, $02, $43, $7F, $FF, $B0, $43, $67, $08 ;0x60
	dc.b	$54, $48, $51, $C9, $FF, $F2, $42, $40, $4C, $DF, $01, $0A, $4E, $75, $48, $E7, $78, $80, $38, $02, $61, $00, $FC, $74, $66, $04, $42, $40, $60, $3C, $D0, $FC ;0x80
	dc.b	$00, $1A, $72, $0B, $42, $42, $36, $30, $20, $00, $02, $43, $7F, $FF, $B0, $43, $67, $0A, $54, $42, $51, $C9, $FF, $F0, $42, $40, $60, $1E, $30, $30, $20, $00 ;0xA0
	dc.b	$08, $00, $00, $0F, $67, $0C, $C5, $44, $02, $40, $00, $FF, $61, $00, $00, $E0, $C5, $44, $42, $70, $20, $00, $61, $00, $FF, $30, $4C, $DF, $01, $1E, $4E, $75 ;0xC0
	dc.b	$48, $E7, $40, $80, $61, $00, $FC, $24, $D0, $FC, $00, $1A, $48, $80, $E3, $48, $32, $00, $30, $30, $10, $00, $08, $00, $00, $0F, $67, $08, $02, $40, $00, $FF ;0xE0
	dc.b	$61, $00, $00, $AC, $42, $70, $10, $00, $61, $00, $FE, $FE, $4C, $DF, $01, $02, $4E, $75, $48, $E7, $7E, $C0, $61, $00, $FB, $F2, $22, $48, $48, $80, $E3, $48 ;0x100
	dc.b	$3A, $00, $32, $02, $34, $31, $50, $1A, $36, $02, $61, $00, $FE, $44, $20, $28, $00, $16, $7C, $0C, $DC, $41, $0D, $00, $66, $08, $4C, $DF, $03, $7E, $42, $80 ;0x120
	dc.b	$4E, $75, $08, $00, $00, $03, $67, $04, $78, $14, $60, $20, $08, $00, $00, $04, $67, $04, $78, $15, $60, $16, $08, $00, $00, $05, $67, $04, $78, $16, $60, $0C ;0x140
	dc.b	$08, $00, $00, $06, $67, $04, $78, $17, $60, $02, $78, $18, $42, $40, $10, $31, $40, $00, $67, $06, $34, $01, $61, $00, $00, $36, $13, $83, $40, $00, $00, $71 ;0x160
	dc.b	$80, $00, $50, $1A, $42, $40, $10, $28, $00, $1A, $D1, $69, $00, $0A, $10, $28, $00, $1B, $D1, $69, $00, $0C, $10, $28, $00, $1C, $D1, $29, $00, $12, $10, $28 ;0x180
	dc.b	$00, $1D, $D1, $29, $00, $10, $10, $03, $4C, $DF, $03, $7E, $4E, $75, $48, $E7, $F0, $C0, $61, $00, $FB, $56, $22, $48, $34, $00, $08, $C0, $00, $0F, $72, $04 ;0x1A0
	dc.b	$B4, $31, $10, $14, $67, $06, $51, $C9, $FF, $F8, $60, $44, $42, $31, $10, $14, $72, $16, $36, $31, $10, $1A, $02, $43, $80, $FF, $B0, $43, $67, $06, $55, $41 ;0x1C0
	dc.b	$6A, $F0, $60, $2C, $02, $71, $7F, $FF, $10, $1A, $61, $00, $FD, $84, $42, $40, $10, $28, $00, $1A, $91, $69, $00, $0A, $10, $28, $00, $1B, $91, $69, $00, $0C ;0x1E0
	dc.b	$10, $28, $00, $1C, $91, $29, $00, $12, $10, $28, $00, $1D, $91, $29, $00, $10, $4C, $DF, $03, $0F, $4E, $75, $48, $E7, $E0, $C0, $61, $00, $FA, $EE, $22, $48 ;0x200
	dc.b	$34, $00, $42, $43, $42, $44, $42, $45, $42, $46, $72, $04, $42, $42, $14, $31, $10, $14, $67, $1A, $61, $00, $FD, $3A, $42, $40, $10, $28, $00, $1A, $D6, $40 ;0x220
	dc.b	$10, $28, $00, $1B, $D8, $40, $DA, $28, $00, $1C, $DC, $28, $00, $1D, $51, $C9, $FF, $DC, $4C, $DF, $03, $07, $4E, $75, $48, $E7, $70, $80, $41, $F9, $00, $FF ;0x240
	dc.b	$CE, $D6, $76, $05, $32, $00, $42, $42, $14, $18, $67, $26, $0C, $02, $00, $01, $67, $12, $0C, $02, $00, $02, $67, $0C, $0C, $02, $00, $09, $67, $06, $0C, $02 ;0x260
	dc.b	$00, $0E, $65, $0A, $30, $01, $61, $00, $FD, $BC, $4A, $40, $66, $06, $51, $CB, $FF, $D6, $42, $42, $30, $02, $4C, $DF, $01, $0E, $4E, $75, $48, $E7, $70, $80 ;0x280
	dc.b	$41, $F9, $00, $FF, $CE, $D6, $32, $00, $76, $05, $42, $42, $14, $18, $67, $0E, $30, $01, $61, $00, $FD, $DA, $4A, $40, $66, $06, $51, $CB, $FF, $EE, $42, $42 ;0x2A0
	dc.b	$30, $02, $4C, $DF, $01, $0E, $4E, $75, $48, $E7, $70, $00, $74, $01, $32, $00, $76, $12, $30, $01, $61, $00, $FD, $B8, $4A, $40, $66, $08, $52, $42, $51, $CB ;0x2C0
	dc.b	$FF, $F2, $42, $42, $30, $02, $4C, $DF, $00, $0E, $4E, $75, $48, $E7, $70, $80, $41, $F9, $00, $FF, $CE, $D6, $32, $00, $76, $05, $42, $42, $14, $18, $67, $0E ;0x2E0
	dc.b	$30, $01, $61, $00, $FD, $64, $4A, $40, $66, $06, $51, $CB, $FF, $EE, $42, $42, $30, $02, $4C, $DF, $01, $0E, $4E, $75, $2F, $09, $22, $7C, $00, $00, $9D, $00 ;0x300
	dc.b	$61, $00, $E2, $64, $61, $00, $8E, $E4, $74, $05, $76, $01, $78, $01, $7A, $02, $7C, $01, $22, $5F, $4E, $75, $00, $00, $00, $00, $00, $00, $00, $00, $2F, $03 ;0x320
	dc.b	$41, $F9, $00, $01, $C2, $FA, $02, $43, $00, $FF, $53, $43, $C6, $FC, $00, $40, $D1, $C3, $26, $1F, $4E, $75, $48, $E7, $30, $80, $61, $00, $F9, $AE, $53, $43 ;0x340
	dc.b	$34, $03, $02, $42, $00, $07, $E6, $4B, $02, $43, $00, $0F, $05, $F0, $30, $36, $4C, $DF, $01, $0C, $4E, $75, $48, $E7, $30, $80, $61, $C2, $42, $40, $10, $28 ;0x360
	dc.b	$00, $1B, $61, $00, $F9, $86, $53, $43, $34, $03, $02, $42, $00, $07, $E6, $4B, $02, $43, $00, $0F, $05, $30, $30, $36, $4C, $DF, $01, $0C, $4E, $75, $48, $E7 ;0x380
	dc.b	$38, $80, $61, $00, $F9, $66, $18, $28, $00, $10, $61, $92, $26, $28, $00, $16, $06, $42, $00, $0C, $05, $03, $67, $0A, $B8, $28, $00, $1A, $65, $04, $42, $40 ;0x3A0
	dc.b	$60, $02, $70, $01, $4C, $DF, $01, $1C, $4E, $75, $48, $E7, $38, $80, $61, $A6, $66, $4A, $61, $00, $F9, $36, $18, $28, $00, $10, $61, $00, $FF, $62, $26, $28 ;0x3C0
	dc.b	$00, $16, $06, $42, $00, $0C, $05, $03, $67, $32, $98, $28, $00, $1A, $65, $2C, $E4, $4C, $B8, $28, $00, $1A, $64, $20, $4E, $B9, $00, $00, $1F, $9C, $02, $40 ;0x3E0
	dc.b	$00, $FF, $E2, $4C, $B8, $28, $00, $1A, $65, $08, $0C, $40, $00, $B4, $64, $0C, $60, $06, $0C, $40, $00, $80, $64, $04, $42, $40, $60, $02, $70, $01, $4C, $DF ;0x400
	dc.b	$01, $1C, $4E, $75, $48, $E7, $30, $80, $61, $00, $FF, $14, $0C, $42, $00, $EA, $66, $06, $34, $39, $00, $FF, $DA, $B2, $08, $02, $00, $07, $66, $0E, $53, $42 ;0x420
	dc.b	$36, $02, $E6, $4A, $E3, $4A, $06, $42, $00, $1C, $60, $10, $02, $42, $00, $7F, $53, $42, $36, $02, $E6, $4A, $E3, $4A, $06, $42, $00, $22, $02, $43, $00, $07 ;0x440
	dc.b	$E3, $4B, $30, $30, $20, $00, $E6, $68, $02, $40, $00, $03, $4C, $DF, $01, $0C, $4E, $75, $48, $E7, $30, $80, $53, $43, $C6, $FC, $00, $0E, $41, $F9, $00, $FF ;0x460
	dc.b	$D6, $96, $D1, $C3, $53, $42, $36, $02, $E6, $4B, $02, $42, $00, $07, $05, $F0, $30, $00, $4C, $DF, $01, $0C, $4E, $75, $48, $E7, $30, $80, $53, $43, $C6, $FC ;0x480
	dc.b	$00, $0E, $41, $F9, $00, $FF, $D6, $96, $D1, $C3, $02, $42, $00, $7F, $53, $42, $36, $02, $E6, $4B, $02, $42, $00, $07, $42, $40, $05, $30, $30, $00, $67, $02 ;0x4A0
	dc.b	$70, $FF, $4C, $DF, $01, $0C, $4E, $75, $48, $E7, $7E, $E0, $48, $E7, $80, $80, $30, $3C, $00, $50, $61, $00, $91, $66, $24, $48, $4C, $DF, $01, $01, $23, $CA ;0x4C0
	dc.b	$00, $FF, $DA, $A2, $76, $13, $42, $9A, $51, $CB, $FF, $FC, $24, $79, $00, $FF, $DA, $A2, $61, $00, $F8, $16, $22, $48, $42, $42, $0C, $79, $00, $03, $00, $FF ;0x4E0
	dc.b	$00, $00, $66, $02, $74, $01, $76, $01, $42, $44, $42, $45, $42, $40, $7C, $42, $0B, $31, $40, $36, $67, $54, $0C, $03, $00, $07, $66, $3E, $0C, $79, $00, $03 ;0x500
	dc.b	$00, $FF, $00, $00, $66, $40, $0C, $79, $00, $01, $00, $FF, $CA, $6E, $66, $3A, $0C, $79, $00, $39, $00, $FF, $CA, $9E, $66, $30, $0C, $79, $00, $22, $00, $FF ;0x520
	dc.b	$CA, $A0, $66, $26, $0C, $79, $00, $03, $00, $FF, $CA, $A2, $67, $18, $0C, $79, $00, $07, $00, $FF, $CA, $A2, $67, $0E, $60, $10, $61, $00, $FD, $E2, $22, $28 ;0x540
	dc.b	$00, $16, $05, $01, $67, $04, $14, $C3, $52, $40, $52, $45, $0C, $45, $00, $08, $66, $04, $42, $45, $52, $44, $52, $43, $51, $CE, $FF, $96, $4C, $DF, $07, $7E ;0x560
	dc.b	$4E, $75, $2F, $08, $20, $79, $00, $FF, $DA, $A2, $61, $00, $91, $24, $20, $5F, $4E, $75, $3C, $39, $00, $FF, $DA, $A6, $60, $50, $3C, $39, $00, $FF, $DA, $A6 ;0x580
	dc.b	$5C, $46, $60, $46, $3C, $39, $00, $FF, $DA, $A6, $5D, $46, $6A, $3C, $42, $46, $60, $38, $42, $46, $42, $47, $4A, $43, $67, $30, $48, $E7, $C0, $20, $24, $79 ;0x5A0
	dc.b	$00, $FF, $DA, $A2, $70, $05, $42, $47, $32, $06, $4A, $32, $10, $00, $67, $12, $B6, $32, $10, $00, $67, $10, $52, $47, $52, $41, $51, $C8, $FF, $EE, $5C, $46 ;0x5C0
	dc.b	$60, $E2, $42, $46, $42, $47, $4C, $DF, $04, $03, $48, $E7, $C0, $A0, $24, $79, $00, $FF, $DA, $A2, $4A, $32, $60, $00, $66, $0C, $5D, $46, $6A, $F6, $4C, $DF ;0x5E0
	dc.b	$05, $03, $42, $45, $4E, $75, $33, $C6, $00, $FF, $DA, $A6, $78, $05, $42, $45, $16, $32, $60, $00, $67, $12, $61, $00, $FD, $26, $61, $00, $8B, $24, $54, $41 ;0x600
	dc.b	$52, $45, $52, $46, $51, $CC, $FF, $EA, $74, $07, $76, $00, $78, $01, $3C, $05, $53, $46, $4C, $DF, $05, $03, $4E, $75, $48, $E7, $01, $20, $24, $79, $00, $FF ;0x620
	dc.b	$DA, $A2, $DE, $79, $00, $FF, $DA, $A6, $42, $43, $16, $32, $70, $00, $4C, $DF, $04, $80, $4E, $75, $2F, $02, $48, $82, $53, $42, $C4, $FC, $00, $10, $41, $F9 ;0x640
	dc.b	$00, $00, $B9, $86, $D1, $C2, $24, $1F, $4E, $75, $48, $E7, $1F, $E0, $48, $E7, $80, $80, $30, $3C, $00, $30, $61, $00, $8F, $C4, $24, $48, $4C, $DF, $01, $01 ;0x660
	dc.b	$22, $4A, $35, $40, $00, $20, $35, $41, $00, $22, $74, $09, $76, $0E, $38, $3C, $00, $83, $61, $00, $87, $5A, $35, $40, $00, $24, $52, $6A, $00, $20, $54, $6A ;0x680
	dc.b	$00, $22, $76, $07, $42, $99, $51, $CB, $FF, $FC, $20, $39, $00, $FF, $D5, $DA, $72, $01, $42, $44, $42, $42, $76, $13, $22, $4A, $0C, $79, $00, $22, $00, $FF ;0x6A0
	dc.b	$CA, $6E, $67, $0C, $09, $00, $67, $14, $0C, $41, $00, $13, $67, $0E, $60, $06, $0C, $41, $00, $13, $66, $06, $13, $81, $20, $00, $52, $42, $52, $41, $52, $44 ;0x6C0
	dc.b	$51, $CB, $FF, $D8, $35, $42, $00, $26, $42, $6A, $00, $28, $42, $6A, $00, $2A, $30, $2A, $00, $24, $4E, $B9, $00, $00, $31, $CC, $3C, $2A, $00, $28, $30, $2A ;0x6E0
	dc.b	$00, $20, $32, $2A, $00, $22, $78, $05, $42, $45, $14, $32, $60, $00, $67, $12, $61, $00, $FF, $42, $61, $00, $8A, $2A, $54, $41, $52, $45, $52, $46, $51, $CC ;0x700
	dc.b	$FF, $EA, $30, $2A, $00, $20, $32, $2A, $00, $22, $74, $06, $76, $00, $78, $01, $3C, $05, $53, $46, $3E, $2A, $00, $2A, $4E, $B9, $00, $00, $33, $0C, $4A, $47 ;0x720
	dc.b	$6A, $42, $0C, $47, $FF, $FF, $66, $04, $74, $FF, $60, $44, $08, $07, $00, $0E, $66, $16, $02, $47, $00, $FF, $35, $47, $00, $2A, $3C, $2A, $00, $28, $67, $C2 ;0x740
	dc.b	$5D, $46, $35, $46, $00, $28, $60, $88, $02, $47, $00, $FF, $35, $47, $00, $2A, $3C, $2A, $00, $28, $5C, $46, $4A, $32, $60, $00, $67, $A6, $35, $46, $00, $28 ;0x760
	dc.b	$60, $00, $FF, $6E, $42, $42, $3C, $2A, $00, $28, $DC, $47, $14, $32, $60, $00, $30, $2A, $00, $24, $4E, $B9, $00, $00, $31, $B4, $4E, $45, $00, $01, $2F, $08 ;0x780
	dc.b	$20, $4A, $61, $00, $8F, $0C, $20, $5F, $4C, $DF, $07, $F8, $4E, $75, $48, $E7, $40, $80, $41, $F9, $00, $FF, $D5, $E4, $72, $5F, $42, $40, $4A, $18, $67, $06 ;0x7A0
	dc.b	$52, $40, $51, $C9, $FF, $F8, $4C, $DF, $01, $02, $4E, $75, $48, $E7, $1C, $40, $43, $F9, $00, $FF, $D5, $E4, $4A, $11, $66, $08, $42, $46, $42, $42, $60, $00 ;0x7C0
	dc.b	$00, $84, $42, $85, $3A, $06, $8A, $FC, $00, $06, $2E, $05, $48, $47, $43, $F9, $00, $FF, $D5, $E4, $34, $05, $C4, $FC, $00, $06, $D3, $C2, $4A, $11, $66, $04 ;0x7E0
	dc.b	$53, $45, $60, $EA, $48, $E7, $C6, $00, $42, $42, $42, $43, $61, $00, $F6, $8E, $52, $40, $74, $07, $76, $00, $78, $01, $7A, $06, $53, $46, $4E, $B9, $00, $00 ;0x800
	dc.b	$33, $0C, $4C, $DF, $00, $63, $4A, $47, $6A, $26, $0C, $47, $FF, $FF, $66, $06, $74, $FF, $60, $00, $00, $30, $08, $07, $00, $0E, $67, $08, $02, $47, $00, $FF ;0x820
	dc.b	$52, $45, $60, $AA, $02, $47, $00, $FF, $53, $45, $6A, $A2, $42, $45, $60, $9E, $3C, $05, $CC, $FC, $00, $06, $DC, $47, $43, $F9, $00, $FF, $D5, $E4, $42, $42 ;0x840
	dc.b	$14, $31, $60, $00, $4C, $DF, $02, $38, $4E, $75, $48, $E7, $40, $40, $43, $F9, $00, $FF, $D5, $E4, $72, $5F, $4A, $11, $67, $08, $52, $89, $51, $C9, $FF, $F8 ;0x860
	dc.b	$60, $02, $12, $80, $4C, $DF, $02, $02, $4E, $75, $48, $E7, $80, $40, $43, $F9, $00, $FF, $D5, $E4, $42, $31, $00, $00, $0C, $40, $00, $60, $64, $0A, $13, $B1 ;0x880
	dc.b	$00, $01, $00, $00, $52, $40, $60, $F0, $4C, $DF, $02, $01, $4E, $75, $48, $E7, $30, $C0, $43, $F9, $00, $FF, $CE, $D6, $76, $05, $42, $44, $14, $19, $67, $12 ;0x8A0
	dc.b	$61, $00, $F4, $48, $B8, $28, $00, $0E, $64, $04, $18, $28, $00, $0E, $51, $CB, $FF, $EC, $4C, $DF, $03, $0C, $4E, $75, $48, $E7, $A0, $C0, $34, $07, $61, $00 ;0x8C0
	dc.b	$F4, $2A, $30, $28, $00, $02, $67, $4A, $D0, $46, $B0, $68, $00, $04, $65, $04, $30, $28, $00, $04, $34, $00, $94, $68, $00, $02, $31, $40, $00, $02, $3C, $02 ;0x8E0
	dc.b	$67, $24, $70, $51, $4E, $B9, $00, $00, $23, $76, $43, $F9, $00, $FF, $30, $98, $48, $C2, $23, $42, $00, $04, $34, $07, $61, $00, $F3, $DA, $22, $88, $41, $F9 ;0x900
	dc.b	$00, $02, $76, $8A, $60, $20, $4A, $45, $67, $22, $41, $F9, $00, $02, $76, $9A, $60, $14, $43, $F9, $00, $FF, $30, $98, $34, $07, $61, $00, $F3, $B8, $22, $88 ;0x920
	dc.b	$41, $F9, $00, $02, $76, $B2, $42, $40, $61, $00, $8A, $1E, $4C, $DF, $03, $05, $4E, $75, $48, $E7, $A0, $C0, $34, $07, $61, $00, $F3, $B0, $30, $28, $00, $02 ;0x940
	dc.b	$67, $4A, $30, $28, $00, $06, $D0, $46, $B0, $68, $00, $08, $65, $04, $30, $28, $00, $08, $34, $00, $94, $68, $00, $06, $31, $40, $00, $06, $4A, $42, $67, $24 ;0x960
	dc.b	$70, $51, $4E, $B9, $00, $00, $23, $76, $43, $F9, $00, $FF, $30, $98, $48, $C2, $23, $42, $00, $04, $34, $07, $61, $00, $F3, $5C, $22, $88, $41, $F9, $00, $02 ;0x980
	dc.b	$76, $CA, $60, $1C, $41, $F9, $00, $02, $76, $9A, $60, $14, $43, $F9, $00, $FF, $30, $98, $34, $07, $61, $00, $F3, $3E, $22, $88, $41, $F9, $00, $02, $76, $B2 ;0x9A0
	dc.b	$42, $40, $61, $00, $89, $A4, $4C, $DF, $03, $05, $4E, $75, $48, $E7, $A0, $C0, $34, $07, $61, $00, $F3, $36, $30, $28, $00, $02, $66, $40, $30, $06, $0C, $40 ;0x9C0
	dc.b	$03, $E7, $66, $04, $30, $28, $00, $04, $31, $40, $00, $02, $10, $28, $00, $19, $02, $40, $00, $F8, $11, $40, $00, $19, $70, $51, $4E, $B9, $00, $00, $23, $76 ;0x9E0
	dc.b	$43, $F9, $00, $FF, $30, $98, $34, $07, $61, $00, $F2, $EA, $22, $C8, $41, $F9, $00, $02, $76, $E2, $42, $40, $61, $00, $89, $50, $60, $0C, $41, $F9, $00, $02 ;0xA00
	dc.b	$76, $9A, $42, $40, $61, $00, $89, $42, $4C, $DF, $03, $05, $4E, $75, $48, $E7, $A0, $C0, $34, $07, $61, $00, $F2, $D4, $30, $28, $00, $02, $67, $32, $10, $28 ;0xA20
	dc.b	$00, $19, $08, $80, $00, $00, $67, $28, $11, $40, $00, $19, $70, $51, $4E, $B9, $00, $00, $23, $76, $43, $F9, $00, $FF, $30, $98, $34, $07, $61, $00, $F2, $96 ;0xA40
	dc.b	$22, $C8, $41, $F9, $00, $02, $76, $FA, $42, $40, $61, $00, $88, $FC, $60, $0C, $41, $F9, $00, $02, $76, $9A, $42, $40, $61, $00, $88, $EE, $4C, $DF, $03, $05 ;0xA60
	dc.b	$4E, $75, $48, $E7, $A0, $C0, $34, $07, $61, $00, $F2, $80, $30, $28, $00, $02, $67, $32, $10, $28, $00, $19, $08, $80, $00, $02, $67, $28, $11, $40, $00, $19 ;0xA80
	dc.b	$70, $51, $4E, $B9, $00, $00, $23, $76, $43, $F9, $00, $FF, $30, $98, $34, $07, $61, $00, $F2, $42, $22, $C8, $41, $F9, $00, $02, $77, $16, $42, $40, $61, $00 ;0xAA0
	dc.b	$88, $A8, $60, $0C, $41, $F9, $00, $02, $76, $9A, $42, $40, $61, $00, $88, $9A, $4C, $DF, $03, $05, $4E, $75, $48, $E7, $A0, $C0, $34, $07, $61, $00, $F2, $2C ;0xAC0
	dc.b	$30, $28, $00, $02, $67, $32, $10, $28, $00, $19, $08, $80, $00, $01, $67, $28, $11, $40, $00, $19, $70, $51, $4E, $B9, $00, $00, $23, $76, $43, $F9, $00, $FF ;0xAE0
	dc.b	$30, $98, $34, $07, $61, $00, $F1, $EE, $22, $C8, $41, $F9, $00, $02, $77, $2E, $42, $40, $61, $00, $88, $54, $60, $0C ;0xB00
