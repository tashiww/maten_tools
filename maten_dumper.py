from pathlib import Path
import struct
import re
import json

# maten no shoumetsu ROM
rom_filename = "Maten no Soumetsu (Japan).md"
ja_tbl_fn = "ja_tbl.tbl"
en_tbl_fn = "en_tbl.tbl"
script = "tling.txt"
tling_rom = "hax.md"

# place output file in current script directory
cwd = Path(__file__).resolve().parent
out = Path(str(cwd) + "/test_dump.txt")

rom_path = Path(str(cwd) + "/" + rom_filename)
ja_tbl_path = Path(str(cwd) + "/" + ja_tbl_fn)
en_tbl_path = Path(str(cwd) + "/" + en_tbl_fn)

script_path = Path(str(cwd) + "/" + script)
tling_rom_path = Path(str(cwd) + "/" + tling_rom)


def cwd_path(name):
	return Path(str(cwd) + "/" + str(name))


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
	bin_len = 0
	while True:
		# TODO: this should scan in the max length control code bytes, not 1
		# TODO: bin len is wrong sometimes.
		byte = rom.read(1).hex()
		bin_len += 1
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
				bin_len += 1
				# print(f'2{byte=}')
				try:
					parsed += tbl[byte]
				except KeyError:
					missing += 1
					parsed += byte
	return parsed, missing, bin_len


def build_tbl(tbl_path, invert=False):
	"""build lookup dictionary from thingy table
	code=char
	"""
	tbl = {}
	with open(tbl_path, "r") as tbl_file:
		raw_tbl = tbl_file.read().splitlines()
		for line in raw_tbl:
			split = line.split("=", 1)
			if split[1]:
				tbl[split[0].lower()] = split[1]
	if invert:
		return {v: k for k, v in tbl.items()}
	else:
		return tbl


ja_tbl = build_tbl(ja_tbl_path)

en_tbl = build_tbl(en_tbl_path, True)
menu_tbl = build_tbl(cwd_path('menu_tbl.tbl'), invert=True)


def target_dump(rom, tbl):
	rom = rom_path.open("rb")
	i = 0
	start = 0x21000
	stop = 0x21660
	rom.seek(start, 0)
	while rom.tell() < stop:

		ptr_loc = rom.tell()
		ptr = struct.unpack(">I", rom.read(4))[0]

		# print(f'{rom.tell():0x}')

		text, missing = tbl_read(ja_tbl, rom, ptr)

		# if len(text) > 0 and not missing:
		if len(text) > 0:
			fprint(f"{{'String': {i}, " +
										f"'ptr_pos': 0x{ptr_loc:00x}, " +
										f"'str_pos': 0x{ptr:00x}}}")
			if missing:
				fprint(f"# WARNING: {missing} failed lookup bytes")
			fprint("#" + text)
			# tags = re.findall(r'<[^sb>]+>', text)
			# fprint(f'test string #{i}' + ''.join(tags))
			fprint('\n')
			i += 1

		# get back in position to read next ptr
		rom.seek(ptr_loc+4)


def raw_dump(rom, tbl):
	rom_size = rom_path.stat().st_size
	rom = rom_path.open("rb")
	i = 0
	while rom.tell() < rom_size:
		prefix = struct.unpack(">H", rom.read(2))[0]

		# text pointers are prefixed with certain bytes
		valid_prefix = [0x07, 0x27, 0x41f9]
		if prefix in valid_prefix:
			ptr_loc = rom.tell()
			ptr = struct.unpack(">I", rom.read(4))[0]

			# did some guessing and checking for upper/lower bounds
			# might be too strict, but only returns good strings
			if str(f'{ptr:08x}')[0:3] == '000' \
						and ptr_loc > 0x00023000 \
						and ptr_loc < 0x0045000 \
						and ptr > 0x00023000 \
						and ptr < 0x0045000:
				text, missing, bin_len = tbl_read(ja_tbl, rom, ptr)

				# if len(text) > 0 and not missing:
				if len(text) > 0 and not missing:
					# fprint(f"{ptr}\t{bin_len}\t'{ptr:00x}\t'{bin_len:00x}")
					fprint(f'{{"String": {i}, ' +
												f'"prefix": 0x{prefix:00x}, ' +
												f'"ptr_pos": 0x{ptr_loc:00x}, ' +
												f'"str_pos": 0x{ptr:00x}}}')
					if missing:
						fprint(f"# WARNING: {missing} failed lookup bytes")

					fprint("#" + text)
					tags = re.findall(r'<[^sb>]+>', text)
					fprint(f'test string #{i}' + ''.join(tags))
					fprint('\n')
					i += 1
				# this should seek after the prev ptr for small optimization
				rom.seek(ptr_loc, 0)


def text_to_hex(tbl, string):
	ret_str = ''
	longest_lookup = len(max(tbl.keys(), key=len))
	cur_len = 0
	br = '0d'
	# <scroll> is 0x0c
	space = '60'

	# TODO: make the length check add by each character, reset at 0D

	while len(string) >= 1:
		for x in range(longest_lookup, 0, -1):
			nibble = string[0:x]
			if nibble in tbl.keys():
				# print(f'{nibble=}')
				ret_str += tbl[nibble]
				string = string[x:]
				break

		# TODO: make an actual table of lengths instead of assuming 1
		cur_len += len(nibble)

		if tbl[nibble] == '0d':
			cur_len = 0

		if cur_len > 30:
			last_space = ret_str.rfind(space)
			"""
			print(f'{string=}')
			print(f'{last_space=}')
			print(f'{ret_str=}')
			"""
			ret_str = ret_str[0:last_space] + br + ret_str[last_space+2:]
			cur_len = 0

	return ret_str


def script_insert(script_path, table, rom):
	# a list of ROM offsets and available space at each one
	spaces = [
			(0x41a40, 34208),
			(0xef310, 27872),
			(0x20300, 3200),
			(0x5f780, 2000),
			(0xdeee0, 4000),
			(0xfefe0, 4000),
			(0x65500, 0x3b90)
			]

	with open(script_path, "r") as script:
		script_idx = 0
		script_cursor, size = spaces[script_idx]

		for line in [
						li[:-1] for li in script.readlines()
						if not li.startswith('#') and len(li) > 1]:
			if line.startswith("{"):
				str_info = json.loads(line)
				# print(str_info)
			else:
				hex_line = text_to_hex(table, line)
				bin_line = bytes.fromhex(hex_line)
				if len(bin_line) + script_cursor > sum(spaces[script_idx]):
					script_idx += 1
					try:
						script_cursor, size = spaces[script_idx]
					except IndexError:
						print("no more space")
						break

				with open(rom, "rb+") as tl_rom:

					ptr_pos = int(str_info['ptr_pos'], 16)

					if ptr_pos > 0:
						tl_rom.seek(ptr_pos, 0)
						script_ptr = struct.pack(">I", script_cursor)
						tl_rom.seek(ptr_pos, 0)
						tl_rom.write(script_ptr)
						tl_rom.seek(script_cursor, 0)
						tl_rom.write(bin_line)
						# script_cursor += len(bin_line)
						script_cursor = tl_rom.tell()

					else:
						tl_rom.seek(int(str_info['str_pos'], 16))
						tl_rom.write(bin_line)

					print(
							f"str {str_info['String']} " +
							f"- ptr_pos 0x{ptr_pos:0x} - " +
							f"new ptr 0x{script_cursor:0x}")
					fprint(line)
					fprint(hex_line)


class StringBlock:
	""" Basic data for script blocks: description of string block,
		start offset in ROM, end offset,
		step value to reach next string, max_len of string """

	def __init__(self, desc, start, end, step, max_len):
		self.desc = desc
		self.start = start
		self.end = end
		self.step = step
		self.max_len = max_len


def fixed_str_parse(tling_rom, tbl, StringBlock):
	rom = tling_rom.open("rb+")
	start_offset = StringBlock.start
	end_offset = StringBlock.end

	i = 0
	current_string_offset = start_offset + (i * StringBlock.step)
	while current_string_offset < end_offset:
		rom.seek(current_string_offset, 0)
		# name = rom.read(11)
		debug_str = StringBlock.desc.upper() + str(i)
		debug_hex = text_to_hex(tbl, debug_str)
		debug_bin = bytes.fromhex(debug_hex)

		# print(f'{debug_str=}')
		# print(f'{debug_hex=}')
		debug_bin += b'\0' * (StringBlock.max_len-len(debug_bin))

		# print(debug_bin)
		rom.write(debug_bin)
		print(f"wrote {debug_str} to {current_string_offset:00x}")
		i += 1
		current_string_offset = start_offset + (i * StringBlock.step)


# raw_dump(rom_path, ja_tbl)
# target_dump(rom_path, ja_tbl)

# hc_strings = cwd_path('hard_coded_strings.txt')
# script_insert(script_path, en_tbl, tling_rom_path)

item_block = StringBlock('itm', 0x130c6, 0x14920, 0x20, 10)
monster_block = StringBlock('mon', 0x151be, 0x16c10, 0x40, 10)
npc_block = StringBlock('npc', 0xa05c, 0xa15a, 0xe, 7)

# fixed_str_parse(tling_rom_path, menu_tbl, item_block)
# fixed_str_parse(tling_rom_path, menu_tbl, monster_block)
# fixed_str_parse(tling_rom_path, menu_tbl, npc_block)
