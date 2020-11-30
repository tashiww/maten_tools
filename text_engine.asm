; ############################################################################
; # English Patch for maten no soumetsu
; ############################################################################
; # Created by:	tashi
; # Creation Date:	20XX
; # Re-assembled with asm68k (port of SNASM68k)
; # Summary:
; # 	Modify text engine for 8x16 font
; #			- Change VRAM increments
; #			- Change font tile lookup
; ############################################################################

FontTileOffset	equr	d0
BaseFontOffset	equr	a0

 org $00001FE8

	MOVEM.l	A1/A0/D2/D1/D0, -(A7)
	MOVE.w	A1, D2
	SUBI.w	#$0010, FontTileOffset	; $00-$0F are control codes (non-printable)
	BMI.b	$203a	
	EXT.l	FontTileOffset	
	LSL.w	#4, FontTileOffset	; multiply by $20 for 8x16 font
	LEA	$000648E6, BaseFontOffset	; base font address in ROM
	ADDA.l	FontTileOffset, BaseFontOffset	; font tile offset for current character
	MOVEM.l	BaseFontOffset/FontTileOffset, -(A7)
	MOVE.w	#$0080, D0
	BSR.w	$3b24	; vdp stuff?


Xoffset	equr	d0	; X offset to draw letter (3 is left-most column)
Yoffset	equr	d1	; Y offset (15 is top row)
VramTile	equr	d2	; vram tile offset
DrawFontTile	equ	$1dee

 org $00002068

	MOVEA.w	#$C000, A0
	MOVE.w	D6, Xoffset 
	MOVE.w	D7, Yoffset	
	BSR.w	DrawFontTile	; draw font tile to VRAM routine
	addq.w #1, Yoffset
	ADDQ.w	#1, VramTile ;increment tile offset
	BSR.w	DrawFontTile
	addq.w	#1,	d6
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	movem.l	(a7)+,d0/d1/d2/a0/a1
	RTS

NextVRAMTile	equr	a2	; Offset for next VRAM tile to fill
VRAMBaseOffset	equ	$F000	
VRAMUpperBound	equ	$FFC0	; don't write to VRAM if we hit this offset
VRAMOffsetStep	equ	$0040	; step value for incrementing VRAM offset, $40 is suitable for 8x16 font

 org $000038BE
	ADDA.w	#VRAMOffsetStep, NextVRAMTile	
	CMPA.w	#VRAMUpperBound, NextVRAMTile	
	BNE.b	Done
	MOVEA.w	#VRAMBaseOffset, NextVRAMTile

Done:
	MOVE.w	D4, D0	; this is critical, if you skip it it takes FOREVER to render text...
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP

;	vram fix for "choose a name" start screen
	org $3726
;;	ADDQ.w	#2, D6
	NOP
	ADDA.w	#$0040, A1

; menu text table is converted to japanese table but i'd rather leave it alone...
 org $359a
	NOP
	NOP