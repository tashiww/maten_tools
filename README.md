# maten_tools
 Tools for hacking maten no soumetsu SMD. Patches are available in the ./patches/ folder in xdelta, ips, and bps formats. Build instructions are below the feature list.


2021-01-04	initial feature complete?
## features
fully playable in English: all strings translated from Japanese to English
* all dialogue
* all menus
* all status effects
* all enemy names, item names, skill names, playable character names*
* original font replaced with 8x16
* resized windows to accommodate longer names for items, skills, and enemies
* adjusted shop window layouts for longer names
	
## enhancements
* Stats page rearranged to allow larger font for equipment names
* Added "xp to next level" to stat page
* Added stat window to equipment menu
* Increased displayable cap on some attributes (from 999 to 9999)

## building
### Requirements:
* asm68k, an m68000 assembler
* python3
* maten no soumetsu ROM dump
### build steps
1. download repository
1. put asm68k.exe in maten_tools folder
2. dump maten no soumetsu ROM from your cartridge and save in maten_tools folder
3. run patch.bat
	* this inserts new fonts and applies asm hacks
	* then it runs a python script that inserts translated strings
 
 ## patches
 Just as a reminder, patches from the ./patches/ folder can be applied directly to your ROM. You don't need to assemble or build anything.
