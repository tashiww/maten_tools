; ############################################################################
; # English Patch for maten no soumetsu
; ############################################################################
; # Created by:	tashi
; # Creation Date:	20XX
; # Re-assembled with asm68k (port of SNASM68k)
; ############################################################################

	org $0000
	incbin "Maten no Soumetsu (Japan).md"

; insert 8x16 english font to replace original 16x16 Japanese font
	org $648e6
	incbin "8x16 font.bin"
	
; adjust font routine for 8x16 font instead of 16x16
	include "text_engine.asm"