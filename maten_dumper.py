from pathlib import Path
import struct
import re
import json
from typing import BinaryIO
from timeit import default_timer as timer

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


class FilePath:
	""" Creates .path property from a filename to return a Path
		for the filename in the current working directory """
	cwd = Path(__file__).resolve().parent

	def __init__(self, fn):
		self.fn = fn
		self.path = Path(str(cwd) + "/" + fn)


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

	def __init__(self, pc=None, abs_offset=None, table=None, redirect=False):
		self.pc = pc
		self.pc_hex = f'0x{pc:00x}'
		self.abs_offset = abs_offset
		self.abs_offset_hex = f'0x{abs_offset:00x}'
		self.table = table
		self.redirect = redirect
		"""
		self.ja_text = None
		self.ja_bin = None
		self.en_text = None
		self.ja_bin = None
		"""


def build_tbl(tbl_path: Path, reverse: bool = False) -> dict:
	"""build lookup dictionary from thingy table: code=char,
		output dict is optionally reversed as char=code """
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


class String:
	""" Basic data for Strings identified by pointers:
		ptr_loc: where the pointer itself is located
		str_loc: where the string was located
		table: type of table to parse text (normal or menu)
		redirect: whether the ptr is moved w/o re-inserting text
		ptr_type: absolute or relative pointer type """

	en_tables = {
				"normal": build_tbl(FilePath("en_tbl.tbl").path, reverse=True),
				"menu": build_tbl(FilePath('en_menu.tbl').path, reverse=True)}

	ja_tables = {
					"normal": build_tbl(FilePath("ja_tbl.tbl").path),
					"menu": build_tbl(FilePath('menu_tbl.tbl').path)}

	def __init__(
					self,
					ptr_pos=None, str_pos=None,
					table=None, repoint=False, ptr_type=None):

		self.ptr_pos = ptr_pos
		self.ptr_pos_hex = f'0x{ptr_pos:00x}'
		self.str_pos = str_pos
		self.str_pos_hex = f'0x{str_pos:00x}'
		self.table = table
		self.repoint = repoint
		self.ptr_type = ptr_type
		self.ja_text = None
		self.ja_bin = None
		self.en_text = None
		self.en_bin = None
		self.en_bin_len = None

	@property
	def en_text(self):
		return self.__dict__['en_text']

	@en_text.setter
	def en_text(self, val):
		self.__dict__['en_text'] = val
		self.en_bin = bytearray.fromhex(text_to_hex(self.en_tables[self.table], val))
		self.en_bin_len = len(self.en_bin)


original_rom = FilePath("Maten no Soumetsu (Japan).md")
ja_tbl_file = FilePath("ja_tbl.tbl")
en_tbl_file = FilePath("en_tbl.tbl")
insert_script = FilePath("foo.txt")
tling_rom = FilePath("foobar.bin")
output_file = FilePath("test_dump.txt")


item_block = StringBlock('itm', 0x130c6, 0x14920, 0x20, 10)
monster_block = StringBlock('mon', 0x151be, 0x16c10, 0x40, 10)
npc_block = StringBlock('npc', 0xa05c, 0xa15a, 0xe, 7)
# shop strings start = 0x21000
# shop strings stop = 0x21660

fixed_len_blocks = [item_block, monster_block, npc_block]

exclusions = [(s.start, s.end) for s in fixed_len_blocks]
exclusions.append((0xb3a0, 0xbb00))
exclusions = sorted(exclusions)


def cwd_path(name):
	return Path(str(cwd) + "/" + str(name))


# empty the file before we start writing to it
output_file.path.open("w").close()
out = output_file.path.open("a")


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


ja_tbl = build_tbl(ja_tbl_path)
en_tbl = build_tbl(en_tbl_path, reverse=True)
ja_menu_tbl = build_tbl(FilePath('menu_tbl.tbl').path)
en_menu_tbl = build_tbl(FilePath('en_menu.tbl').path, reverse=True)


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
		last_char = None
		# read one byte at a time
		while nibble := rom.read(1):
			if nibble == b'\x00':
				# sometimes \x00 is used in control codes, not as string terminator
				if last_char not in [b'\x04', b'\x01', b'\x02']:
					break
			last_char = nibble

		return rom.tell()-1 - offset


def raw_dump(rom_path: Path, tables: dict) -> list:
	""" Return list of Script objects dumped out of rom_path,
		parsed according to the normal/menu tables specified by tables """
	# this should return a dict like the LEA function instead of hard-printing
	rom_size = rom_path.stat().st_size
	rom = rom_path.open("rb")
	i = 0
	inserted_strings = []
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
						and ptr_loc < 0x50000 \
						and ptr < 0x50000:
				bin_string = direct_dump(rom_path, ptr)
				text, missing = bin_to_text(bin_string, tables['normal'])
				menu_text, menu_missing = bin_to_text(bin_string, tables['menu'])

				# if len(text) > 0 and not missing:
				if len(text) > 0 and not missing:
					# fprint(f"{ptr}\t{bin_len}\t'{ptr:00x}\t'{bin_len:00x}")
					str_info = {
							'str_num': i,
							'prefix': f'0x{prefix:00x}',
							'ptr_pos': ptr_loc,
							'str_pos': ptr,
							'ptr_pos_hex': f'0x{ptr_loc:0000x}',
							'str_pos_hex': f'0x{ptr:0000x}',
							'table': 'normal'
							}

					if ptr not in inserted_strings:
						fprint(json.dumps(str_info))
						fprint("#" + text)
						if not menu_missing:
							fprint(
									"# " +
									menu_text +
									" # if this line is right, "
									"change 'table' to 'menu'")
						# this copies control codes down
						tags = re.findall(r'<[^sb>]+>', text)
						fprint(f'test string #{i}' + ''.join(tags))
					else:
						str_info['repoint'] = True
						fprint(json.dumps(str_info))
						fprint('# ~~REPOINT ONLY~~')
					fprint('\n')
					inserted_strings.append(ptr)
					i += 1
				# this should seek after the prev ptr for small optimization
				rom.seek(ptr_loc, 0)
	return None


def direct_dump(rom_path, start_offset, stop_offset=None):
	""" Dump bytes from rom_path from start_offset until
		stop_offset or first NULL """
	rom = rom_path.open("rb")
	rom.seek(start_offset)
	if stop_offset:
		bin_string = rom.read(stop_offset - start_offset)
	else:
		last_char = None
		bin_string = bytes()
		while char := rom.read(1):
			if char == b'\x00':
				if last_char not in [b'\x04', b'\x01', b'\x02']:
					break

			bin_string += char
			last_char = char

	# put this somewhere else?
	# text = bin_to_text(bin_string, tbl, rom_path.name, True)
	return bin_string


def bin_to_text(bin_string, tbl):
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
				ret_str += r"\x" + nibble

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
	# scroll = '0c'
	space = '60'

	# TODO: make the length check add by each character's length, not just 1

	while string and len(string) >= 1:
		for x in range(longest_lookup, 0, -1):
			nibble = string[0:x]
			if nibble in tbl.keys():
				# print(f'{nibble=}')
				ret_str += tbl[nibble]
				string = string[x:]
				break

		# TODO: make an actual table of lengths instead of assuming 1
		cur_len += len(nibble)

		if tbl[nibble] in ['00', '0d', '0c']:
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
		# orig_str = rom.read(12)
		# itm_name = bin_to_text(orig_str, tbl)[0].rstrip("<end>")

		# fprint(f"0x{current_string_offset:0x}\t{itm_name}")
		rom.seek(current_string_offset, 0)

		# print(f'{debug_str=}')
		# print(f'{debug_hex=}')
		debug_bin += b'\0' * (StringBlock.max_len-len(debug_bin))

		# print(debug_bin)

		# uncomment THIS LATER
		rom.write(debug_bin)
		# print(f"wrote {debug_str} to {current_string_offset:00x}")
		i += 1
		current_string_offset = start_offset + (i * StringBlock.step)
	print(f"inserted {StringBlock.desc}")


def find_leas(rom_path: Path) -> list:
	""" Searches rom_path for any relative word-length LEAs
		and returns a list of LEA objects containing their
		offsets and PC addresses """
	lea_list = []
	pc = 0
	abs_offsets = []
	with rom_path.open("rb") as rom:
		for nibble in struct.iter_unpack(">H", rom.read()):
			pc += 2
			nibble = nibble[0]
			if nibble == 0x41fa:
				rom.seek(pc)
				rel_offset = struct.unpack(">h", rom.read(2))[0]

				abs_offset = pc + rel_offset
				abs_offsets.append(abs_offset)

				# check if the string has already been referenced and included
				# if yes, we don't need to re-insert/translate it
				if len([o for o in abs_offsets if o == abs_offset]) > 1:
					redirect = True
				else:
					redirect = False

				# create a LEA object for menu table and normal table
				# would like to cut out garbage but it's hard to determine
				lea_info = LEA(
						pc-2,
						abs_offset,
						"menu",
						redirect
						)
				lea_list.append(lea_info)
				lea_info = LEA(
						pc-2,
						abs_offset,
						"normal",
						redirect
						)
				lea_list.append(lea_info)
	return lea_list


def dump_leas(leas, normal_table, menu_table):
	""" Takes a list of LEA objects and tries to parse
		the data at each LEA offset with the given tables
		outputting successful parses
		~30% of the strings are garbage and must be
		removed manually """

	lea_lines = []
	tables = {'normal': normal_table, 'menu': menu_table}
	for lea in leas:
		tbl = tables[lea.table]
		text, missing = bin_to_text(
								direct_dump(rom_path, lea.abs_offset),
								tbl)
		if len(text) > 2 and not missing:
			if lea.redirect:
				lea.ja_text = "# REDIRECT ONLY" + text
			else:
				lea.ja_text = text

			lea.missing = missing
			lea_lines.append(lea)
			# fprint(json.dumps(lea.__dict__))
			# fprint("# " + text + "\n")
	return lea_lines


def word_align(offset: int) -> int:
	""" return word aligned offset """
	return (offset + 1) & ~3 | 2


def find_space(
		rom: BinaryIO,
		start: int = 0,
		stop: int = None,
		desired_size: int = 16) -> int:
	""" Searches rom for continguous segments of FFs or 00s
		of at least desired_size bytes
		Returns offset of free space """

	global exclusions
	# add space padding for word-align
	desired_size += 4
	if not stop:
		rom.seek(0, 2)
		stop = rom.tell()

	# print(f"0x{start=:00x}, 0x{stop=:00x}")
	rom.seek(0, 0)
	haystack = rom.read()
	while start < stop:
		for exclusion in exclusions:
			if exclusion[0] <= start <= exclusion[1]:
				start = exclusion[1]+1
				break
		try:
			upper_limit = min([n[0] for n in exclusions if n[0] > start])
		except ValueError:
			upper_limit = stop
		upper_limit = min(upper_limit, stop)

		# print(f"new {start=:00x}, {upper_limit=:00x}, {stop=:00x}")
		try:
			i = haystack.index(b'\x00' * desired_size, start, upper_limit)
		except ValueError:
			try:
				i = haystack.index(b'\xff' * desired_size, start, upper_limit)
			except ValueError:
				start = upper_limit
				continue

		# print(f"{word_align(i+start)=:00x}")
		return word_align(i+1)

	return None


def find_total_freespace(
		rom_path: Path,
		start: int = 0,
		stop: int = None,
		sortby: str = 'size') -> list:
	""" Searches rom for continguous segments of FFs or 00s
		returning a list of offset and size tuples,
		sortby 'size' descending or address ascending,
		with optional exclusion zones given as a list of
		(lower, upper) tuples """

	global exclusions
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


def parse_script(script_path: Path) -> list:
	""" Returns list of String objects built from script file """

	string_list = []
	tlstring = ""
	str_info = None

	with open(script_path, "r", encoding="utf-8") as script:
		for line in [
					li.strip() for li in script.readlines()
					if not li.startswith('#') and len(li) > 1]:
			if line.startswith("{"):
				if len(tlstring) > 0:
					str_info.en_text = tlstring
					string_list.append(str_info)
					tlstring = ""

				metadata = json.loads(line)
				str_info = String(
								metadata['ptr_pos'],
								metadata['str_pos'],
								metadata['table'],
								metadata['repoint'],
								metadata['ptr_type']
								)

			else:
				tlstring += line

	return string_list


def repoint_relative(rom, str_info: String, new_ptr: int) -> int:
	""" Convert relative pointer to absolute pointer
		by changing a LEA with relative pointer to a branch
		to a LEA with an absolute pointer. Return offset of
		new LEA or None if no space available """

	# binary representations of opcodes
	bsr = b'\x61\x00'
	lea = b'\x41\xf9'
	rts = b'\x4e\x75'

	pc = str_info.ptr_pos
	start = max(pc - 0x7fff, 0)
	stop = pc + 0x7fff
	lea_space = find_space(rom, start, stop, 0x16)
	# print(f"{pc=:00x}")
	# print(f"{lea_space=:00x}")
	if lea_space:
		# replace asm lea with branch to offset with free space
		rom.seek(pc, 0)
		rom.write(bsr)
		# >h is signed short (2 bytes)
		rom.write(struct.pack(">h", (lea_space - pc - 2)))

		# create new lea for absolute ptr offset
		rom.seek(lea_space, 0)
		rom.write(lea)
		rom.write(struct.pack(">I", new_ptr))
		rom.write(rts)

	return lea_space


def repoint_absolute(rom, ptr_pos: int, new_pos: int) -> int:
	rom.seek(ptr_pos, 0)
	rom.write(struct.pack(">I", new_pos))
	return new_pos


def repoint(rom: BinaryIO, str_info: String) -> int:
	""" Find free space for new string and repoint pointer """

	desired_size = max(0x40, str_info.en_bin_len)
	new_pos = find_space(rom, 0x20000, None, desired_size)
	if new_pos:
		# print(f"{new_pos=}")
		if str_info.ptr_type == 'absolute':
			if repoint_absolute(rom, str_info.ptr_pos, new_pos):
				return new_pos

		elif str_info.ptr_type == 'relative':
			if repoint_relative(rom, str_info, new_pos):
				return new_pos

	else:
		return None


def insert_string(rom: BinaryIO, str_info: String) -> int:
	""" Insert string and repoint pointer """
	if str_info.en_bin:
		# write new pointer
		new_pos = repoint(rom, str_info)
		if new_pos:
			rom.seek(new_pos)
			rom.write(str_info.en_bin + b'\x00')
			# print(f"{new_pos=:00x}")
			return new_pos
		else:
			# if can't find space for string
			return 0

	else:
		# if str_info is missing en_bin
		return 0


def make_space(rom_path: Path, strings: list) -> int:
	""" Looks for 'abs_offset' key in list of dicts, blanking out data
		until \x00 is found """
	space = 0
	with open(rom_path, "rb+") as rom:
		haystack = rom.read()
		for str_info in strings:
			try:
				index = haystack.index(b'\x00', str_info.str_pos)
				bin_len = index - str_info.str_pos
			except ValueError:
				bin_len = 0
			# print(f"{index=}, {str_info.__dict__=}, {bin_len=}")
			rom.seek(str_info.str_pos)
			rom.write(b'\x00' * bin_len)
			space += bin_len
			rom.flush()
	return space


tables = {'normal': en_tbl, 'menu': en_menu_tbl}

# fixed_str_parse(rom_path, ja_menu_tbl, monster_block)

# raw_dump(rom_path, {'normal': ja_tbl, 'menu': ja_menu_tbl})

"""
# print([x.__dict__ for x in find_leas(rom_path)])
# this dumps hard-coded ("lea") strings to fstring's out file
leas = (dump_leas(find_leas(rom_path), ja_tbl, ja_menu_tbl))
leas = sorted(leas, key=lambda x: x.abs_offset)
i = 0
for lea in leas:
	string = lea.__dict__.pop('ja_text')
	fprint(json.dumps(lea.__dict__))
	fprint("# " + string)
	# tags = re.findall(r'<[^sb>]+>', string)
	# fprint(f'lea string #{i}' + ''.join(tags))
	fprint("\n")
	i += 1
	# add flag in lea for "redirect only, no insert"
die()
"""


def insert_from_file(rom_path: Path, *filenames: str) -> None:
	""" Parses script files and inserts strings into a ROM """
	total_dur = 0
	good_lines = 0
	bad_lines = 0
	if filenames:
		for script_file in filenames:
			lines = parse_script(FilePath(script_file).path)

			with open(rom_path, "rb+") as rom:
				for line in lines:
					# print(line.__dict__)
					start = timer()
					new_pos = insert_string(rom, line)
					if new_pos > 0:
						# print(f"Repointed string from 0x{line.ptr_pos:00x} to 0x{new_pos:00x}")
						good_lines += 1
					else:
						print(f"error on {line.en_text}")
						bad_lines += 1
					end = timer()
					dur = end - start
					total_dur += dur
					# print(f"One string insertion took {dur} seconds")

		print(f"Total: {total_dur}s, {good_lines} inserted, {bad_lines} failed")
		print(f"Average time: {total_dur/(good_lines+bad_lines)} seconds")


def make_space_from_file(rom_path: Path, script_files: list) -> int:
	space = 0
	for script in script_files:
		lines = parse_script(FilePath(script).path)
		space += make_space(rom_path, lines)
	return space


script_files = ["foo.txt", "lea_strings.txt"]


free_space = make_space_from_file(tling_rom_path, script_files)
print(f"cleared {free_space} bytes")

insert_from_file(tling_rom_path, "lea_strings.txt", "foo.txt")

# print(f'freed {make_space(tling_rom_path, lea_lines)} bytes for LEAs')


# these lines fill fixed length text blocks with debug strings
for block in fixed_len_blocks:
	fixed_str_parse(tling_rom_path, en_menu_tbl, block)


"""
foo = find_total_freespace(tling_rom_path, 'x', exclusions)
for f in foo:
	print(f'0x{f[0]:0x}: {f[1]} bytes')
"""
