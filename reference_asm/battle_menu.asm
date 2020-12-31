; move battle menu references

	org $0000
	incbin "foobar.bin"

	org $ce1a 
	BSR battle_submenu

	org $be5e
	BSR battle_menu
	
	org $b748
battle_submenu:
	LEA $20FB3, a0
	RTS

	org $b7c0
battle_menu:
	LEA $20fe2, a0
	RTS	