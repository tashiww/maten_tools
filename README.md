# maten_tools
 Tools for hacking maten no soumetsu SMD. Patches are available in the ./patches/ folder in xdelta, ips, and bps formats. Build instructions are below the feature list.

|released date|version|notes|
|---|---|---|
|2021-01-05|	ver 01a|	fixed vram overflow (text being overwritten) and made line breaks more aggressive to prevent words being split. added max level patch|
|2021-01-04|	ver 00a|	initial feature complete?|
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
 
 ## screenshots
 new font for dialogue:
 ![foobar-210104-190332](https://user-images.githubusercontent.com/44418517/103598015-3b94d480-4ec7-11eb-93f0-b01040f8cf30.png)
![Maten no Soumetsu (Japan)-210104-190956](https://user-images.githubusercontent.com/44418517/103598018-3b94d480-4ec7-11eb-8851-b307e36764a3.png)

equipment screen redesign:

![foobar-210104-190405](https://user-images.githubusercontent.com/44418517/103598113-6c750980-4ec7-11eb-82fb-1ecf9c2903d8.png)
![Maten no Soumetsu (Japan)-210104-191106](https://user-images.githubusercontent.com/44418517/103598114-6c750980-4ec7-11eb-99ce-c9d6978d8d29.png)

stat page redesign:

![foobar-210104-191326](https://user-images.githubusercontent.com/44418517/103598143-7f87d980-4ec7-11eb-9d6b-4fbcc4c0b03c.png)
![Maten no Soumetsu (Japan)-210104-190902](https://user-images.githubusercontent.com/44418517/103598145-7f87d980-4ec7-11eb-90b8-1b7c2e0caa20.png)
