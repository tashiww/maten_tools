; ########################################################################################
; # Generated by the active disassembly feature of the Exodus emulation platform
; #
; # Creation Date:   2021-1-31 10:58:05
; # Analysis Region: 0x00007DDA - 0x00007E1C
; ########################################################################################

 org $00007DDA

	MOVEA.l	$2(A0), A0
	MOVE.b	$2(A0), D1
	LSL.w	#8, D1
	MULU.w	$00FFCAB0, D1
	LSR.l	#3, D1
	CMPI.w	#8, $00FFCAB0
	BCC.b	loc_00007DFC
	ADDQ.w	#1, $00FFCAB0
loc_00007DFC:
	BSR.w	*+$2F98
	CMP.b	(A0), D4
	BLS.b	loc_00007E18
	LSR.w	#1, D1	;Predicted (Code-scan)
	SUBQ.b	#2, D4	;Predicted (Code-scan)
	CMP.b	(A0), D4	;Predicted (Code-scan)
	BLS.b	loc_00007E18	;Predicted (Code-scan)
	LSR.w	#1, D1	;Predicted (Code-scan)
	SUBQ.b	#2, D4	;Predicted (Code-scan)
	CMP.b	(A0), D4	;Predicted (Code-scan)
	BLS.b	loc_00007E18	;Predicted (Code-scan)
	BRA.w	*+$F808	;Predicted (Code-scan)
loc_00007E18:
	BSR.w	*+$A182
