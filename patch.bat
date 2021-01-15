@ECHO OFF
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /format:list') do set datetime=%%I
set datetime=%datetime:~0,8%_%datetime:~8,6%

::copy foobar.bin "./ignore/foobak_%datetime%.bin"
.\asm68k.exe /ooz-,os-,ow-,ae- /p "./asm/maten.asm","foobar.bin","symbols","listing"
py maten_dumper.py

:: any argument given to the ./patch.bat script will create an IPS patch as well.
IF [%1]==[] (GOTO :end) ELSE (GOTO :patch)
:patch
.\flips.exe -c --ips "Maten no Soumetsu (Japan).md" "foobar.bin" "./patches/bleeding_edge/maten_%datetime%.ips"
:end