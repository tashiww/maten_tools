; convert a relative LEA to absolute long LEA by first replacing the relative LEA with a
; relative BSR to somewhere with enough room to write the long LEA
; $B600 seems to have $10 empty bytes...

	incbin "hax.md"

	org $0000
	; main menu
	org $838a
	BSR main_menu_lea
	
	org $841e
; item sub-menu 
	BSR item_submenu_lea
	
	org $8abe
	BSR stat_submenu_lea
	
	org $b600
main_menu_lea:
	LEA	$20F80, a0
	RTS
item_submenu_lea:
	LEA $20F99, a0
	RTS

	org $b740
stat_submenu_lea:
	LEA $20FA7, a0
	RTS
	
