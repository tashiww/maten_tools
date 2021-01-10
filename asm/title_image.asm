ImageSource	equr	a0	; ram.. rom?
ImageDestination	equr	a5	; vram
Length	equr	d0	; $314 maybe

; $21BC is vram copy subroutine?

 org $1158
title_screen:
 	MOVE.w	#$c90, d1	; size of DMA copy, long to include "press start"
	JSR new_title
		
 org $68a00
new_title:
	MOVE.l	#$1411, d0
	LEA $FF3ce0, a1
	MOVEm.l	a1/d0, -(a7)
	LEA	$f4480, a0
	LEA	$F5FFE, a1
	MOVE	#$6000, a1
	move.w	d1, d2
	;subi.w	#$200, d2
	move.w	d2, d0
	move.l #$1, d3
	JSR $21bc
	MOVEm.l	(a7)+, d0/a1
	;LEA $FF32B8, a0
	;LEA $FF3ccc, a3
	;LEA $60e2c, a4
	MOVE.l #$6000, a5	; most of this probably isn't necessary.. just trying to set it back to intended state?
	move.l #$41421000, d0
	clr	d1
	clr	d2
	clr	d3
	LEA	$605ea, a6
	RTS

 org $19b30
prologue_title:
	MOVE.w	#$9a0, d1
	JSR new_title
	WHILE *<$19b42
		NOP
	ENDW
; trying not to step on next LEA at $19b42
 org $f4480
	incbin "./images/new_title_samurai.bin"
 org $f57c0
	incbin	"./images/press_start.bin"