; ############################################################################
; # English Patch for maten no soumetsu
; ############################################################################
; # Created by:	tashi
; # Creation Date:	20XX
; # Re-assembled with asm68k (port of SNASM68k)
; ############################################################################

	org $0000
	incbin "Maten no Soumetsu (Japan).md"

; insert 8x8 english font to replace original menu font
	org $60000
	incbin "8x8 font.bin"
	
; insert 8x16 english font to replace original 16x16 Japanese font
	org $648e6
	incbin "8x16 font.bin"
	
; blank out the rest of the original Japanese font
	DO
	dcb.l 150,$FFFFFFFF	
	UNTIL *>$68A00

; adjust font routine for 8x16 font instead of 16x16
	include "text_engine.asm"

; changes menus to fill every row instead of every other row, shops and menus
	include "menu_item_layout.asm"

; changes behavior of name selection screen to match smaller english alphabet
	include "menu_name_selection.asm"
	
	
	;org $a45a ; hacky base item offset change ...
	; LEA $000130C6, A0
	;LEA $00041a3e, A0