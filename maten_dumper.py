from pathlib import Path
import struct
import re
import json

# maten no shoumetsu ROM
rom_filename = "Maten no Soumetsu (Japan).md"
ja_tbl_fn = "ja_tbl.tbl"
en_tbl_fn = "en_tbl.tbl"
script = "tling.txt"
tling_rom = "foobar.bin"

# place output file in current script directory
cwd = Path(__file__).resolve().parent
out = Path(str(cwd) + "/test_dump.txt")

rom_path = Path(str(cwd) + "/" + rom_filename)
ja_tbl_path = Path(str(cwd) + "/" + ja_tbl_fn)
en_tbl_path = Path(str(cwd) + "/" + en_tbl_fn)

script_path = Path(str(cwd) + "/" + script)
tling_rom_path = Path(str(cwd) + "/" + tling_rom)


class StringBlock:
	""" Basic data for script blocks: description of string block,
		start offset in ROM, end offset,
		step value to reach next string, max_len of string """
	def __init__(self, desc=None, start=None, end=None, step=None, max_len=None):
		self.desc = desc
		self.start = start
		self.end = end
		self.step = step
		self.max_len = max_len


class LEA:
	""" Basic data for LEA ops which load relative pointers:
		pc: pc offset of LEA op
		abs_offset: absolute offset loaded by the LEA
		table: type of table to parse text at the offset location """

	def __init__(self, pc=None, abs_offset=None, table=None):
		self.pc = pc
		self.pc_hex = f'0x{pc:00x}'
		self.abs_offset = abs_offset
		self.abs_offset_hex = f'0x{abs_offset:00x}'
		self.table = table


item_block = StringBlock('itm', 0x130c6, 0x14920, 0x20, 10)
monster_block = StringBlock('mon', 0x151be, 0x16c10, 0x40, 10)
npc_block = StringBlock('npc', 0xa05c, 0xa15a, 0xe, 7)
# shop strings start = 0x21000
# shop strings stop = 0x21660

fixed_len_blocks = [item_block, monster_block, npc_block]

exclusions = [(s.start, s.end) for s in fixed_len_blocks]
exclusions.append((0xb3a0, 0xbb00))


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


def tbl_read(tbl, rom, start_offset, end_offset=None):
	""" takes a dict as lookup table, rom from which to extract,
		offset to start parsing, optionally an end offset. If there is
		no end_offset, read until first string terminator (null)"""
	parsed = ''
	rom.seek(start_offset, 0)
	missing = 0
	bin_len = 0
	while True:
		# TODO: this should scan in the max length control code bytes, not 1
		# TODO: bin len is wrong sometimes.
		byte = rom.read(1).hex()
		bin_len += 1
		if byte == '00':
			if len(parsed) > 0:
				""" original game aligns on even bytes but i don't think it matters
				if rom.read(1).hex() == '00':
					parsed += '<hend>'
				else:
					parsed += '<end>'
				"""
				parsed += '<end>'
			if not end_offset:
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
		if end_offset and rom.tell() >= end_offset:
			break
	return parsed, missing, bin_len


def build_tbl(tbl_path: Path, reverse: bool = False) -> dict:
	"""build lookup dictionary from thingy table
	code=char
	"""
	tbl = {}
	with open(tbl_path, "r", encoding="utf-8") as tbl_file:
		raw_tbl = tbl_file.read().splitlines()
		for line in raw_tbl:
			split = line.split("=", 1)
			if split[1]:
				tbl[split[0].lower()] = split[1]
	if reverse:
		return {v: k for k, v in tbl.items()}
	else:
		return tbl


ja_tbl = build_tbl(ja_tbl_path)
en_tbl = build_tbl(en_tbl_path, True)
menu_tbl = build_tbl(cwd_path('menu_tbl.tbl'), reverse=True)
raw_menu_tbl = build_tbl(cwd_path('menu_tbl.tbl'))
en_menu_tbl = build_tbl(cwd_path('en_menu.tbl'), reverse=True)


def target_dump(rom, tbl, StringBlock):
	rom = rom_path.open("rb")
	i = 0
	start_offset = StringBlock.start
	stop_offset = StringBlock.stop
	rom.seek(start_offset, 0)
	while rom.tell() < stop_offset:
		ptr = None

		if ptr:
			ptr_loc = rom.tell()
			ptr = struct.unpack(">I", rom.read(4))[0]

		# print(f'{rom.tell():0x}')

		text, missing = tbl_read(tbl, rom, rom.tell())

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


def bin_len(rom_path: Path, offset: int) -> int:
	""" Return length of \x00 terminated string in
		rom_path at offset, not including terminator """

	with open(rom_path, "rb") as rom:
		rom.seek(offset)
		while nibble := rom.read(1):
			if nibble == b'\x00':
				break

		return rom.tell()-1 - offset


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
					str_info = {
							'str_num': i,
							'prefix': f'0x{prefix:00x}',
							'ptr_pos': ptr_loc,
							'str_pos': ptr,
							'ptr_pos_hex': f'0x{ptr_loc:0000x}',
							'str_pos_hex': f'0x{ptr:0000x}'
							}
					"""
					fprint(f'{{"String": {i}, ' +
												f'"prefix": 0x{prefix:00x}, ' +
												f'"ptr_pos": 0x{ptr_loc:00x}, ' +
												f'"str_pos": 0x{ptr:00x}}}')
					"""
					fprint(json.dumps(str_info))
					if missing:
						fprint(f"# WARNING: {missing} failed lookup bytes")

					fprint("#" + text)
					tags = re.findall(r'<[^sb>]+>', text)
					fprint(f'test string #{i}' + ''.join(tags))
					fprint('\n')
					i += 1
				# this should seek after the prev ptr for small optimization
				rom.seek(ptr_loc, 0)


def direct_dump(rom_path, start_offset, stop_offset=None):
	""" Dump bytes from rom_path from start_offset until
		stop_offset or first NULL """
	rom = rom_path.open("rb")
	rom.seek(start_offset)
	if stop_offset:
		bin_string = rom.read(stop_offset - start_offset)
	else:
		bin_string = bytes()
		while char := rom.read(1):
			if char == b'\x00':
				break
			bin_string += char

	# put this somewhere else?
	# text = bin_to_text(bin_string, tbl, rom_path.name, True)
	return bin_string


def bin_to_text(bin_string, tbl):
	print(type(bin_string))
	""" Parses bin_string through tbl, returning tuple
		of the string and count of failed lookups """
	missing = 0
	ret_str = ''

	# read all bytes into list
	bin_string = [x[0].hex() for x in struct.iter_unpack("1s", bin_string)]

	# loop until list is empty by parsing and removing bytes
	while len(bin_string) > 0:
		# multibyte control codes max length is 2
		nibble = ''.join(bin_string[0:2])
		if nibble in tbl.keys():
			ret_str += tbl[nibble]
			bin_string = bin_string[2:]
		else:
			nibble = bin_string.pop(0)
			try:
				ret_str += tbl[nibble]
			except KeyError:
				missing += 1
				ret_str += nibble

	return ret_str, missing


def bin_to_text_list(bin_string, tbl, name, ignore_terminators=False):
	""" Parses binary string according to tbl, splitting lines
		by \x00s """
	missing = 0
	offset = 0x8a14
	ret_list = []

	i = 0
	ret_str = f'{offset=:0x}\n'
	bin_string = [x[0].hex() for x in struct.iter_unpack("1s", bin_string)]

	ret_dict = {}
	ret_dict[name] = f'{offset:0x}'
	while len(bin_string) > 0:
		# multibyte control codes max length is 2
		nibble = ''.join(bin_string[0:2])
		if nibble in tbl.keys():
			ret_str += tbl[nibble]
			bin_string = bin_string[2:]
			offset += 2
		else:
			nibble = bin_string.pop(0)
			try:
				ret_str += tbl[nibble]
			except KeyError:
				missing += 1
				ret_str += nibble
			offset += 1
		if nibble[-2:] == '00':
			ret_dict['str_id'] = i
			# ret_dict['ja_str'] = ret_str
			# ret_list.append(json.dumps(ret_dict))
			ret_list.append(ret_dict)
			ret_dict = {}
			ret_dict[name] = f'{offset:0x}'
			ret_str = ''
			i += 1

	return ret_list


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

		if tbl[nibble] in ['00', '0000', '0d']:
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
	""" inserts script badly and should be replaced """

	""" obsoleted by find_total_freespace function
	# a list of ROM offsets and available space at each one
	spaces = [
			(0x41a40, 34208),
			(0xef310, 27872),
			(0x20300, 3000),
			(0x5f780, 2000),
			(0xdeee0, 4000),
			(0xfefe0, 4000),
			(0x65500, 0x3b90)
			]
	"""

	spaces = find_total_freespace(rom)[0:7]
	size = 0
	freespace = sum([b[1] for b in spaces])
	with open(script_path, "r", encoding='utf-8') as script:
		script_idx = 0
		i = 0
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
					size += len(bin_line)
					try:
						script_cursor, size = spaces[script_idx]
					except IndexError:
						print("no more space")
						break

				with open(rom, "rb+") as tl_rom:

					ptr_pos = str_info['ptr_pos']
					# ptr_pos = int(str_info['ptr_pos'], 16)
					i += 1

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
						tl_rom.seek(str_info['str_pos'])
						# tl_rom.seek(int(str_info['str_pos'], 16))
						tl_rom.write(bin_line)

					"""
					print(
							f"str {str_info['str_num']} " +
							f"- ptr_pos 0x{ptr_pos:0x} - " +
							f"new ptr 0x{script_cursor:0x}")
					fprint(line)
					"""
					# fprint(hex_line)
	print(f'inserted {i} script strings in {size} bytes, ' +
							f'{freespace-size} remaining')


def fixed_str_parse(rom_path, tbl, StringBlock):
	rom = rom_path.open("rb+")
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
		# print(f"wrote {debug_str} to {current_string_offset:00x}")
		i += 1
		current_string_offset = start_offset + (i * StringBlock.step)
	print(f"inserted {StringBlock.desc}")


# raw_dump(rom_path, ja_tbl)
# target_dump(rom_path, ja_tbl)

# hc_strings = cwd_path('hard_coded_strings.txt')
# script_insert(script_path, en_tbl, tling_rom_path)


def direct_insert(rom_path, bin_string, start):
	rom = open(rom_path, "rb+")
	rom.seek(start, 0)
	rom.write(bin_string)
	return f'inserted {len(bin_string):0x} bytes at {start}'


"""
for x in menu_msg_asm_offsets:
	rom = open(tling_rom_path, "rb+")
	rom.seek(x+2, 0)
	lea_offset = struct.unpack(">h", rom.read(2))[0]
	# lea_offset += 2
	lea_offset = struct.pack(">h", lea_offset)
	rom.seek(-2, 1)
	rom.write(lea_offset)
"""


# fprint(json.dumps(menu_msgs.__dict__))

menu_msgs = StringBlock('menumsg', 0x8a14, 0x8a9a)


def update_menu_msgs():
	menu_msg_asm_offsets = [
						0x855c,  # $8a14
						0x856a,  # $8a20
						0x8678,  # $8a32
						0x86a4,  # $8a3e
						0x8774,  # $8a4a
						0x877e,  # $8a58
						0x87b2,  # $8a66
						0x89e0,  # $8a76
						0x876e,  # $8a82
						0x8a02,  # $8a90
						]
	insert_path = cwd_path('menu_msgs.txt')
	insert_fh = open(insert_path, "r")
	insert_lines = insert_fh.readlines()
	insert_bin = insert_lines[1]
	menu_msg_start = json.loads(insert_lines[0])['start']
	en_txt = bytes.fromhex((text_to_hex(en_tbl, insert_bin)))
	direct_insert(tling_rom_path, en_txt, menu_msg_start)
	en_bin = bin_to_text(en_txt, en_tbl)[0].split('00')
	print(en_bin)

	ja_bin = direct_dump(rom_path, menu_msgs.start, menu_msgs.end)

	combined_list = []
	for i in range(len(en_bin)):
		combo = {}
		combo['en'] = en_bin[i]['en']
		combo['ja'] = ja_bin[i]['Maten no Soumetsu (Japan).md']
		combo['diff'] = int(combo['en'], 16) - int(combo['ja'], 16)
		print(combo)
		combined_list.append(combo)

		orig_rom = open(rom_path, "rb")
		rom = open(tling_rom_path, "rb+")
		orig_rom.seek(menu_msg_asm_offsets[i]+2, 0)
		lea_offset = struct.unpack(">h", orig_rom.read(2))[0]
		lea_offset += combo['diff']
		lea_offset = struct.pack(">h", lea_offset)
		rom.seek(menu_msg_asm_offsets[i]+2, 0)
		rom.write(lea_offset)
# i broke this :/
# update_menu_msgs()


def find_leas(rom_path: Path) -> list:
	""" Searches rom_path for any relative word-length LEAs
		and returns a list of LEA objects containing their
		offsets and PC addresses """
	lea_list = []
	pc = 0
	with rom_path.open("rb") as rom:
		for nibble in struct.iter_unpack(">H", rom.read()):
			pc += 2
			nibble = nibble[0]
			if nibble == 0x41fa:
				rom.seek(pc)
				rel_offset = struct.unpack(">H", rom.read(2))[0]
				abs_offset = pc + rel_offset

				lea_info = LEA(
						pc-2,
						abs_offset
						)
				lea_list.append(lea_info)
	return lea_list


def dump_leas(leas, normal_table, menu_table):
	""" Takes a list of LEA objects and tries to parse
		the data at each LEA offset with the given tables
		outputting successful parses
		~30% of the strings are garbage and must be
		removed manually """

	tables = {'normal': normal_table, 'menu': menu_table}
	for tbl_name, tbl in tables.items():
		for lea in leas:
			lea.table = tbl_name
			text, missing = bin_to_text(
									direct_dump(rom_path, lea.abs_offset),
									tbl)
			if len(text) > 2 and len(text) < 130 and missing == 0:
				fprint(json.dumps(lea.__dict__))
				fprint("# " + text + "\n")


def find_space(
		rom_path: Path,
		start: int = 0,
		stop: int = None,
		desired_size: int = 16) -> int:
	""" Searches rom for continguous segments of FFs or 00s
		of at least desired_size, with optional exclusion zones
		given as a list of (lower, upper) tuples.
		Returns offset of free space """

	global exclusions
	size = 0
	offset = 0
	with open(rom_path, "rb") as rom:
		rom.seek(start)
		while nibble := rom.read(1):
			if nibble in [b'\x00', b'\xff']:
				# offset is after first match in case it was a string terminator
				offset = rom.tell()

				# leave a 1 byte buffer at end of freespace
				size = -1

				# search for contiguous bytes of same value
				while rom.read(1) == nibble:
					size += 1

			if size >= desired_size and \
				not any(lower <= offset <= upper for
												(lower, upper) in exclusions):
				return(offset)
			if stop and rom.tell() > stop:
				break
	return None

def find_total_freespace(
		rom_path: Path,
		start: int = 0,
		stop: int = None,
		sortby: str = 'size',
		exclusions: list = None) -> list:
	""" Searches rom for continguous segments of FFs or 00s
		returning a list of offset and size tuples,
		sortby 'size' descending or address ascending,
		with optional exclusion zones given as a list of
		(lower, upper) tuples """

	exclusions = [] if not exclusions else exclusions
	freelist = []
	size = 0
	offset = 0
	with open(rom_path, "rb") as rom:
		rom.seek(start)
		while nibble := rom.read(1):
			if nibble in [b'\x00', b'\xff']:
				# offset is after first match in case it was a string terminator
				offset = rom.tell()

				# leave a buffer at end of freespace
				size = -1

				# search for contiguous bytes of same value
				while rom.read(1) == nibble:
					size += 1

			if size > 16 and \
				not any(lower <= offset <= upper for
												(lower, upper) in exclusions):
				freelist.append((offset, size))
				size = -1
			if stop and rom.tell() > stop:
				break

	if sortby == 'size':
		return sorted(freelist, key=lambda x: x[1], reverse=True)
	else:
		return freelist


def parse_leas(script_path: Path, tbls: dict) -> list:
	""" Parses a script file that has LEA addresses specified,
		and moves them to other free spaces and repoints them
	"""
	lea_lines = []
	with open(script_path, "r", encoding="utf-8") as script:
		for line in [
					li.strip() for li in script.readlines()
					if not li.startswith('#') and len(li) > 1]:
			if line.startswith("{"):
				str_info = json.loads(line)
			else:
				hex_line = text_to_hex(tbls[str_info['table']], line)
				bin_line = bytes.fromhex(hex_line)
				if len(bin_line) > 0:
					str_info['bin_line'] = bin_line
					lea_lines.append(str_info)
	return lea_lines


def move_leas(rom_path: Path, lea_list: list) -> int:

	# binary representations of opcodes
	bsr = b'\x61\x00'
	lea = b'\x41\xf9'
	rts = b'\x4e\x75'
	with open(rom_path, "rb+") as rom:
		for line in lea_list:
			pc = line.get('pc')
			bin_line = line.get('bin_line')
			if bin_line:
				bin_line += b'\x00'
				new_len = len(bin_line)
				orig_len = bin_len(rom_path, line['abs_offset'])

				# can we overwrite old string?
				# this should really be in an "insert_leas" function...
				if new_len <= orig_len:
					rom.seek(line['abs_offset'])
					rom.write(bin_line + b'\x00' * (orig_len - new_len))

				# can't fit in old string space
				else:
					# 16 bit relative addressing limit
					start = pc - 0x7fff if pc > 0x7fff else 0
					stop = pc + 0x7fff

					# check for freespace for string
					# minimum 16 bytes to avoid overwriting meaningful \x00s
					if string_space := find_space(rom_path, start, stop, max(20, new_len)+1):

						# if string fits somewhere nearby
						# keep lea, change address
						rom.seek(pc+2, 0)
						# print(struct.pack(">h", (string_space - pc)).hex())
						rom.write(struct.pack(">h", (string_space - pc - 2)))

						rom.seek(string_space + rom.tell() % 2)
						rom.write(bin_line)
						print(f'rewrote lea to 0x{string_space:0x}')


					# need to move lea to use absolute offset
					else:
						print(f"0x{pc=:0x}, 0x{line['abs_offset']=:0x}")
						print(f"{new_len=}, {orig_len=}")
						print(f"{bin_line.hex()=}")
						if lea_space := find_space(rom_path, start, stop, 10):
							if string_space := find_space(rom_path, 0x20000, desired_size=new_len):
								print(f"{string_space=:0x}")
								rom.seek(pc, 0)
								rom.write(bsr)
								rom.write(struct.pack(">h", (lea_space - pc - 2)))

								rom.seek(lea_space, 0)
								rom.write(lea)
								rom.write(struct.pack(">i", (string_space - pc - 2)))
								rom.write(rts)

								rom.seek(string_space, 0)
								rom.write(bin_line)
								print("i'm a hero")
								print(f'rewrote lea as bsr to {lea_space - pc}')
								print(f'rewrote lea to 0x{string_space:0x}')

							else:
								print("No space to insert string :/")
								continue

						else:
							print("No space to relocate LEA at 0x{pc:0x}:/")
							continue

	return 0


tables = {'normal': en_tbl, 'menu': en_menu_tbl}
lea_lines = parse_leas(cwd_path("lea_strings.txt"), tables)

# print(len([x for x in lea_lines if x.get('bin_line')]))
move_leas(tling_rom_path, lea_lines)

# print(lea_lines)

"""
total_space = sum(
		[x[1] for x in
			find_total_freespace(tling_rom_path, exclusions=exclusions)])
print(f'total space: {total_space/1024:.2f}KB')
"""


# these lines fill fixed length text blocks with debug strings
for block in fixed_len_blocks:
	fixed_str_parse(tling_rom_path, menu_tbl, block)

script_insert(cwd_path('debug_script.txt'), en_tbl, tling_rom_path)

"""
foo = find_total_freespace(tling_rom_path, 'x', exclusions)
for f in foo:
	print(f'0x{f[0]:0x}: {f[1]} bytes')
"""
# dump_leas(find_leas(rom_path), ja_tbl, raw_menu_tbl)
