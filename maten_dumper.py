from pathlib import Path
import struct
import re
import json

# maten no shoumetsu ROM
rom_filename = "Maten no Soumetsu (Japan).md"
ja_tbl_fn = "ja_tbl.tbl"
en_tbl_fn = "en_tbl.tbl"
script = "tling.txt"
tling_rom = "tling.md"

# place output file in current script directory
cwd = Path(__file__).resolve().parent
out = Path(str(cwd) + "/test_dump.txt")

rom_path = Path(str(cwd) + "/" + rom_filename)
ja_tbl_path = Path(str(cwd) + "/" + ja_tbl_fn)
en_tbl_path = Path(str(cwd) + "/" + en_tbl_fn)

script_path = Path(str(cwd) + "/" + script)
tling_rom_path = Path(str(cwd) + "/" + tling_rom)


# empty the file before we start writing to it
out.open("w").close()
out = out.open("a")


def fprint(text, mode="both", fout=out):
	""" outputs text to modes: stdout, file, or both """

	if mode == 'stdout' or mode == 'both':
		print(text)
	if mode == 'file' or mode == 'both':
		out.write(str(text) + '\n')


def tbl_read(tbl, rom, offset):
	""" takes a dict as lookup table and bytearray as string """
	parsed = ''
	rom.seek(offset, 0)
	missing = 0
	while True:
		byte = rom.read(1).hex()
		if byte == '00':
			if len(parsed) > 0:
				if rom.read(1).hex() == '00':
					parsed += '<hend>'
				else:
					parsed += '<end>'
			break
		else:
			# print(f'1{byte=}')
			if byte in tbl.keys():
				parsed += tbl.get(byte)
			else:
				byte += rom.read(1).hex()
				# print(f'2{byte=}')
				try:
					parsed += tbl[byte]
				except KeyError:
					missing += 1
					parsed += byte
	return parsed, missing


def build_tbl(tbl_path, invert=False):
	"""build lookup dictionary from thingy table
	code=char
	"""
	tbl = {}
	with open(tbl_path, "r") as tbl_file:
		raw_tbl = tbl_file.read().splitlines()
		for line in raw_tbl:
			split = line.split("=")
			tbl[split[0].lower()] = split[1]
	if invert:
		return {v: k for k, v in tbl.items()}
	else:
		return tbl


ja_tbl = build_tbl(ja_tbl_path)

en_tbl = build_tbl(en_tbl_path, True)


def raw_dump(rom, tbl):
	rom_size = rom_path.stat().st_size
	rom = rom_path.open("rb")
	i = 0
	while rom.tell() < rom_size:
		prefix = struct.unpack(">H", rom.read(2))[0]

		# text pointers are prefixed with $0007
		if prefix == 7:
			ptr_loc = rom.tell()
			ptr = struct.unpack(">I", rom.read(4))[0]

			# did some guessing and checking for upper/lower bounds
			# might be too strict, but only returns good strings
			if str(f'{ptr:08x}')[0:3] == '000' \
						and ptr_loc > 0x00023000 \
						and ptr_loc < 0x0045000 \
						and ptr > 0x00023000 \
						and ptr < 0x0045000:
				text, missing = tbl_read(ja_tbl, rom, ptr)

				if len(text) > 0 and not missing:
					fprint(f"{{'String': {i}, " +
												f"'ptr_pos': 0x{ptr_loc:00x}, " +
												f"'str_pos': 0x{ptr:00x}}}")
					if missing:
						fprint(f"# WARNING: {missing} failed lookup bytes")
					fprint("#" + text)
					tags = re.findall(r'<[^sb>]+>', text)
					fprint(''.join(tags))
					fprint('\n')
					i += 1
				rom.seek(ptr_loc, 0)


# rom storage:
# 	0x41a40 	32KB?
# 	0xEF310 	32KB?

def text_to_bin(tbl, string):
	ret_str = ''
	longest_lookup = len(max(tbl.keys(), key=len))

	while len(string) > 1:
		for x in range(longest_lookup, 0, -1):
			nibble = string[0:x]
			if nibble in tbl.keys():
				ret_str += tbl[nibble]
				string = string[x:]

	return ret_str


with open(script_path, "r") as script:
	script_cursor = 0x41a40
	for line in [li[:-1] for li in script.readlines()[5075:5109]
									if not li.startswith('#') and len(li) > 1]:
		if line.startswith("{"):
			str_info = json.loads(line)
			# print(str_info)
		else:
			hex_line = text_to_bin(en_tbl, line)
			bin_line = bytes.fromhex(hex_line)
			with open(tling_rom_path, "rb+") as tl_rom:

				ptr_pos = int(str_info['ptr_pos'], 16)
				tl_rom.seek(ptr_pos, 0)
				print(f'ptr_pos 0x{ptr_pos:0x}')
				print(f'new ptr 0x{script_cursor:0x}')
				print(line)
				print(f'{len(line)=}')
				print(f'{len(hex_line)=}')
				print(f'{len(bin_line)=}')
				print(hex_line)
				ptr_bytes = struct.pack(">I", ptr_pos)
				script_bytes = struct.pack(">I", script_cursor)

				tl_rom.seek(ptr_pos, 0)
				tl_rom.write(script_bytes)

				tl_rom.seek(script_cursor, 0)
				tl_rom.write(bin_line)
				script_cursor = tl_rom.tell()


# raw_dump(rom_path, ja_tbl)
