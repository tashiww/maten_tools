from pathlib import Path
import struct
import json
from typing import BinaryIO


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


class FilePath:
	""" Creates .path property from a filename to return a Path
		for the filename in the current working directory """
	cwd = Path(__file__).resolve().parent

	def __init__(self, fn):
		self.fn = fn
		self.path = Path(str(self.cwd) + "/" + fn)


class StringBlock:
	""" Basic data for fixed size script blocks: (items, skills, enemies, etc)
		description of string block,
		start offset in ROM, end offset,
		step value to reach next string, max_len of string """
	def __init__(self, desc=None, start=None, end=None, step=None, max_len=None):
		self.desc = desc
		self.start = start
		self.start_hex = f'0x{start:00x}'
		self.end = end
		self.end_hex = f'0x{end:00x}'
		self.step = step
		self.max_len = max_len


ja_tbl = build_tbl(FilePath("tables/ja_tbl.tbl").path)
en_tbl = build_tbl(FilePath("tables/en_tbl.tbl").path, reverse=True)
ja_menu_tbl = build_tbl(FilePath('tables/menu_tbl.tbl').path)
en_menu_tbl = build_tbl(FilePath('tables/en_menu.tbl').path, reverse=True)

tables = {'normal': en_tbl, 'menu': en_menu_tbl}
ja_tables = {'normal': ja_tbl, 'menu': ja_menu_tbl}


original_rom = FilePath("Maten no Soumetsu (Japan).md")

script_files = [
				"translations/relative_strings.txt",
				"translations/main_script.txt"
				]

fixed_len_strings = [
					'translations/item_list.txt',
					'translations/enemy_list.txt',
					'translations/skill_list.txt',
					'translations/npc_list.txt',
					'translations/battle_status_list.txt',
					'translations/town_list.txt'
					]

# asm hacks should be applied to this file before inserting strings
tling_rom = FilePath("foobar.bin")

# place output file in current directory (only if dumping functions
# are uncommented)
output_file = FilePath("test_dump.txt")
# empty the file before we start writing to it
output_file.path.open("w").close()
out = output_file.path.open("a")


item_block = StringBlock('itm', 0x130c6, 0x14920, 0x20, 10)
# monster block really starts $1519a but string starts at $151be i guess
monster_block = StringBlock('mon', 0x151be, 0x16c10, 0x40, 10)
npc_block = StringBlock('npc', 0xa05c, 0xa15a, 0xe, 7)
skill_block = StringBlock('skl', 0x1c2fa, 0x1d45c, 0x40, 0x10)
town_block = StringBlock('town', 0xb986, 0xbac6, 0x10, 0xa)

fixed_len_blocks = [item_block, monster_block, npc_block, skill_block]

# make sure we don't try inserting strings in this juicy blank space
exclusions = [(s.start, s.end) for s in fixed_len_blocks]
exclusions.append((0xb3a0, 0xbb00))
exclusions.append((0xf4480, 0xf5e00))
exclusions = sorted(exclusions)


class String:
	""" Basic data for Strings identified by pointers:
		ptr_loc: where the pointer itself is located
		str_loc: where the string was located
		table: type of table to parse text (normal or menu)
		redirect: whether the ptr is moved w/o re-inserting text
		ptr_type: absolute or relative pointer type """
	# i could probably declare these as Nones and move the code above back to
	# the bottom
	en_tables = {"normal": en_tbl, "menu": en_menu_tbl}
	ja_tables = {"normal": ja_tbl, "menu": ja_menu_tbl}

	def __init__(
					self,
					ptr_pos=None, str_pos=None,
					table=None, repoint=False, ptr_type=None,
					prefix=None):

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
		self.prefix = prefix
		self.step = None

	@property
	def en_text(self):
		return self.__dict__['en_text']

	@en_text.setter
	def en_text(self, val):
		self.__dict__['en_text'] = val
		self.en_bin = bytearray.fromhex(text_to_hex(self.en_tables[self.table], val))
		self.en_bin_len = len(self.en_bin)


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


def sloppy_strings(rom_path: Path, tables: dict) -> list:
	string_list = []
	repoint_list = []
	valid_prefix = [b'\x00\x07', b'\x00\x27', b'\x41\xf9']
	with rom_path.open("rb") as rom:
		haystack = rom.read()
		start = 0x21000
		stop = len(haystack)
		for ptr_pos in range(start, stop-4, 2):
			prefix = haystack[ptr_pos-2:ptr_pos]
			if prefix in valid_prefix:
				continue
			str_pos = struct.unpack(">I", haystack[ptr_pos:ptr_pos+4])[0]
			if str_pos < stop:
				# print(f'{ptr_pos=:00x}, {str_pos=:00x}')
				bin_str = binary_dump(rom, str_pos)
				if len(bin_str) > 2 and len(bin_str) < 200:
					if str_pos in repoint_list:
						repoint = True
					else:
						repoint = False

					for name, tbl in tables.items():
						text, missing = bin_to_text(bin_str, tbl)
						if len(text) > 0 and missing == 0:
							# print(f'{text=}, {missing=}')
							str_info = String(ptr_pos, str_pos, name, repoint, 'absolute')
							str_info.prefix = '0x' + prefix.hex()
							str_info.ja_text = text

							string_list.append(str_info)
							repoint_list.append(str_pos)

	return string_list


def find_strings(rom_path: Path, tables: dict) -> list:
	""" Return list of String objects dumped out of rom_path,
		parsed according to the normal/menu tables specified by tables """

	string_list = []
	valid_prefix = [b'\x00\x07', b'\x00\x27', b'\x41\xf9']
	# valid_prefix = [b'\x41\xf9']

	rom_size = rom_path.stat().st_size
	with rom_path.open("rb") as rom:
		haystack = rom.read()
		stop = len(haystack)-4

		for prefix in valid_prefix:
			start = 0
			inserted_strings = []

			while True:
				try:
					match = haystack.index(prefix, start, stop)
				except ValueError:
					break

				ptr_pos = match + len(prefix)
				if ptr_pos > rom_size:
					break
				else:
					str_pos = struct.unpack(">I", haystack[ptr_pos:ptr_pos+4])[0]

				bin_str = binary_dump(rom, str_pos)

				if len(bin_str) > 0:

					if str_pos in inserted_strings:
						repoint = True
					else:
						repoint = False

					# print(f'{ptr_pos=:00x}, {str_pos=:00x}, {bin_str=}')
					for name, tbl in tables.items():
						text, missing = bin_to_text(bin_str, tbl)
						# print(f'{text=}, {missing=}')
						if len(text) > 0 and missing == 0:
							str_info = String(ptr_pos, str_pos, 'normal', repoint, 'absolute')
							str_info.ja_text = text
							str_info.table = name
							str_info.prefix = prefix.hex()
							# print(str_info.__dict__)

							string_list.append(str_info)
							inserted_strings.append(str_pos)
							# fprint(json.dumps(str_info), 'stdout')

				start = ptr_pos+1

	return string_list


def binary_dump(rom: BinaryIO, start_offset, stop_offset=None):
	""" Dump bytes from rom_path from start_offset until
		stop_offset or first NULL """
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
		if tbl[nibble] in ['0501', '0502', '0509']:
			cur_len += 5

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


def fixed_str_parse(rom_path, tbl, string_block):
	rom = rom_path.open("rb+")
	start_offset = string_block.start
	end_offset = string_block.end

	i = 0
	current_string_offset = start_offset + (i * string_block.step)
	while current_string_offset < end_offset:
		rom.seek(current_string_offset, 0)
		# name = rom.read(11)
		debug_str = string_block.desc.upper() + f'{i+1:00x}'
		debug_hex = text_to_hex(tbl, debug_str)
		debug_bin = bytes.fromhex(debug_hex)
		# orig_str = rom.read(12)
		# itm_name = bin_to_text(orig_str, tbl)[0].rstrip("<end>")

		# fprint(f"0x{current_string_offset:0x}\t{itm_name}")
		rom.seek(current_string_offset, 0)

		# print(f'{debug_str=}')
		# print(f'{debug_hex=}')
		debug_bin += b'\0' * (string_block.max_len-len(debug_bin))

		# print(debug_bin)

		# uncomment THIS LATER
		rom.write(debug_bin)
		# print(f"wrote {debug_str} to {current_string_offset:00x}")
		i += 1
		current_string_offset = start_offset + (i * string_block.step)
	print(f"inserted {string_block.desc}")


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
			# 0x41fa is LEA to a0, but you can LEA to anything....
			if nibble == 0x41fa:
				rom.seek(pc)
				rel_offset = struct.unpack(">h", rom.read(2))[0]

				abs_offset = pc + rel_offset
				abs_offsets.append(abs_offset)

				# check if the string has already been referenced and included
				# if yes, we don't need to re-insert/translate it
				if abs_offsets.count(abs_offset) > 1:
					redirect = True
				else:
					redirect = False

				# create a LEA object for menu table and normal table
				# would like to cut out garbage but it's hard to determine
				lea_info = String(
						pc-2,
						abs_offset,
						"menu",
						redirect,
						'relative',
						f'0x{nibble:00x}'
						)
				lea_list.append(lea_info)
				lea_info = String(
						pc-2,
						abs_offset,
						"normal",
						redirect,
						'relative',
						f'0x{nibble:00x}'
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
	rom = open(original_rom.path, "rb+")
	for lea in leas:
		tbl = tables[lea.table]

		text, missing = bin_to_text(binary_dump(rom, lea.str_pos), tbl)
		if len(text) > 0 and not missing:
			if lea.repoint:
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
		desired_size: int = 16,
		tight: bool = False) -> int:
	""" Searches rom for continguous segments of FFs or 00s
		of at least desired_size bytes
		Returns offset of free space """

	global exclusions
	# add space padding for word-align
	desired_size += 4
	if not stop:
		rom.seek(0, 2)
		stop = rom.tell()

	pad = 1 - tight
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
		return word_align(i+pad)

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
		# i think this is actually cutting off trailing r's ???
		for line in [
					li.strip('\r').strip('\n') for li in script.readlines()
					if not li.startswith('#') and len(li) > 1]:
			if line.startswith("{"):
				if len(tlstring) > 0 or (str_info and str_info.repoint):
					# remove trailing <br>? this removes letters b, r, etc...
					# str_info.en_text = tlstring.rstrip("<br>")
					if tlstring.endswith("<br>"):
						tlstring = tlstring[0:-4]

					str_info.en_text = tlstring
					string_list.append(str_info)
					tlstring = ""

				metadata = json.loads(line)
				str_info = String(
								metadata['ptr_pos'],
								metadata['str_pos'],
								metadata['table'],
								metadata.get('repoint'),
								metadata['ptr_type'],
								metadata.get('prefix')
								)
				if str_info.ptr_type == 'fixed':
					str_info.id = metadata.get('id')
					str_info.step = metadata.get('step')

			else:
				tlstring += line
				if tlstring[-4:] not in ["oll>", "<br>"]:
					tlstring += "<br>"

	if len(tlstring) > 0 or (str_info and str_info.repoint):
		# remove trailing <br>? this removes letters b, r, etc...
		# str_info.en_text = tlstring.rstrip("<br>")
		if tlstring.endswith("<br>"):
			tlstring = tlstring[0:-4]

		str_info.en_text = tlstring
		string_list.append(str_info)

	return string_list


def repoint_relative(rom: BinaryIO, str_info: String, new_ptr: int) -> int:
	""" Convert relative pointer to absolute pointer
		by changing a LEA with relative pointer to a branch
		to a LEA with an absolute pointer. Return offset of
		new LEA or None if no space available """

	# binary representations of opcodes
	bsr = b'\x61\x00'
	rts = b'\x4e\x75'
	# lea to a0 is 41f9, but sometimes lea to a1 has text
	# lea = b'\x41\xf9'
	# the first byte of the lea contains register information
	# the second byte is addressing mode (rel / abs), $f9 is abs
	lea = int(str_info.prefix, 16).to_bytes(2, 'big')[0:1] + b'\xf9'

	pc = str_info.ptr_pos
	# only have 2 bytes for the relative jump so +- half of 0xFFFF
	start = max(pc - 0x7fff, 0)
	stop = pc + 0x7fff
	lea_space = find_space(rom, start, stop, 0x14, True)
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

	desired_size = max(0x80, str_info.en_bin_len)
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
			# if not hasattr(str_info, 'dont_blank'):
			try:
				index = haystack.index(b'\x00', str_info.str_pos)
				bin_len = index - str_info.str_pos
			except ValueError:
				continue
			# print(f"{index=}, {str_info.__dict__=}, {bin_len=}")
			rom.seek(str_info.str_pos)
			rom.write(b'\x00' * bin_len)
			space += bin_len
	return space


def dump_leas_to_file():
	# print([x.__dict__ for x in find_leas(rom_path)])
	# this dumps hard-coded ("lea") strings to fstring's out file
	leas = dump_leas(find_leas(original_rom.path), ja_tbl, ja_menu_tbl)
	leas = sorted(leas, key=lambda x: (x.repoint, x.str_pos))
	i = 0
	for lea in leas:
		string = lea.__dict__.pop('ja_text')
		fprint(json.dumps(lea.__dict__))
		fprint("# " + string)
		# tags = re.findall(r'<[^sb>]+>', string)
		# fprint(f'lea string #{i}' + ''.join(tags))
		fprint("\n")
		i += 1


def insert_from_file(rom_path: Path, *filenames: str) -> None:
	""" Parses script files and inserts strings into a ROM """
	good_lines = 0
	bad_lines = 0
	repoints = 0
	new_ptrs = {}
	inserted_size = 0
	if filenames:
		for script_file in filenames:
			lines = parse_script(FilePath(script_file).path)

			with open(rom_path, "rb+") as rom:
				for line in lines:
					if line.repoint:
						new_pos = new_ptrs.get(line.str_pos)
						try:
							if line.ptr_type == "absolute":
								repoint_absolute(rom, line.ptr_pos, int(new_pos))
							elif line.ptr_type == "relative":
								repoint_relative(rom, line, int(new_pos))

							repoints += 1
						except TypeError:
							print(f"failed to repoint {line.__dict__}")

					else:
						new_pos = insert_string(rom, line)
						if new_pos > 0:
							new_ptrs[line.str_pos] = new_pos
							inserted_size += line.en_bin_len
							good_lines += 1
						else:
							print(f"error on {line.en_text}")
							bad_lines += 1

		print(f"{good_lines} inserted, {repoints} repointed, ", end="")
		print(f"{bad_lines} failed. Size: {inserted_size}B from {script_file}")


def make_space_from_file(rom_path: Path, script_files: list) -> int:
	space = 0
	for script in script_files:
		lines = parse_script(FilePath(script).path)
		space += make_space(rom_path, lines)
	return space


def insert_fixed_str(rom_path: Path, script_name: str) -> int:

	# TODO: check if this needs to pad to max_len to avoid leftover jp chars
	lines = parse_script(FilePath(script_name).path)
	step = lines[0].step
	new_pos = lines[0].str_pos
	with open(rom_path, "rb+") as rom:
		# new_pos = find_space(rom, 0x20000, None, len(lines) * step)
		for line in lines:
			if isinstance(line.id, str):
				line.id = int(line.id, 16)
			rom.seek(new_pos + (line.id * step))
			# this should be truncated to block max_len
			rom.write(line.en_bin[0:16] + b'\x00')


def dump_fixed_str(rom_path: Path, tbl: dict, block_info: StringBlock) -> list:
	# TODO: make this dump proper json...
	start_offset = block_info.start
	end_offset = block_info.end

	i = 0
	current_string_offset = start_offset
	with rom_path.open("rb+") as rom:
		while current_string_offset < end_offset:
			rom.seek(current_string_offset, 0)
			orig_str = rom.read(block_info.max_len)
			itm_name = bin_to_text(orig_str, tbl)[0].rstrip("<end>")
			block_info.id = i
			block_info.ptr_type = "fixed"
			block_info.table = "menu"
			block_info.ptr_pos = 0
			block_info.repoint = False
			block_info.str_pos = block_info.start
			json_block = json.dumps(block_info.__dict__)
			fprint(f'{json_block}')
			fprint(f"# {itm_name}\n\n")

			i += 1
			current_string_offset = start_offset + (i * block_info.step)

	return None


class Enemy:

	def __init__(self, id: int, data=None):

		self.id = f'0x{id+1:00x}'
		# size related?
		self.unk1, self.unk2, self.unk3 = struct.unpack(">BBH", data[0:4])

		self.ptr1,\
			self.ptr2, \
			self.ptr3, \
			self.ptr4 = [f'0x{p:00x}' for p in struct.unpack(">IIII", data[4:0x14])]

		stats = data[0x14:0x24]
		self.hp, \
			self.mp, \
			self.attack, \
			self.defense, \
			self.strength, \
			self.mind, \
			self.vitality, \
			self.speed = struct.unpack(">"+"H"*8, stats)

		end_of_string = data.index(b'\x00', 0x24)
		name_bin = data[0x24:end_of_string]
		self.name = bin_to_text(name_bin, ja_menu_tbl)[0]

		self.unk4, self.xp, self.gold = struct.unpack(">HHH", data[0x34:0x3a])
		self.bonus_action1,	self.bonus_action2,	self.bonus_action3 = \
			struct.unpack(">BBB", data[0x3a:0x3d])


party = [
		'Arnath', 'Lilith', 'Lichel', 'Cline', 'Isaiah', 'Abel',
		'Nana', 'Slay', 'Kamil', 'Cynak', 'Zafan', 'Brigit',
		'Satan', 'Slime', 'Nightmare', 'Kirikaze', 'White Tiger', 'Nebulous',
		'Swordman']


class Item:
	def __init__(self, id: int, data=None):

		self.id = f'0x{id+1:00x}'
		end_of_string = data.index(b'\x00')
		name_bin = data[0:end_of_string]
		self.name = bin_to_text(name_bin, ja_menu_tbl)[0]

		stats = data[0x16:]

		self.attack, \
			self.defense, \
			self.speed, \
			self.mind = struct.unpack(">"+"BBbb", stats[4:8])

		self.buy_price = struct.unpack(">"+"H", stats[8:10])[0]
		self.sell_price = int(self.buy_price * .75)

		self.property_byte = f'0x{struct.unpack(">I", stats[0:4])[0]:00x}'

		property_bits = f'{struct.unpack(">I", stats[0:4])[0]:0=32b}'[::-1]

		# reverse bits to use descending order, spaces every 4 bits
		self.property_bits = " ".join(
						[property_bits[::-1][i:i+4] for i in range(0, 32, 4)])

		equip_bits = [int(bit) for bit in property_bits[0xd:]]
		slot_bits = [int(bit) for bit in property_bits[3:8]]
		slots = ['Weapon', 'Head', 'Armor', 'Shield', 'Accessory']

		if 1 in equip_bits:
			try:
				self.slot = slots[slot_bits.index(1)]
			except ValueError:
				self.slot = slots[-1]
		else:
			self.slot = 'Other'

		for i in range(len(party)):
			setattr(self, party[i], equip_bits[i])

		# self.unk1, self.unk2, self.unk3 = struct.unpack(">BBH", data[0:4])


def dump_data_blocks(rom_path: Path, block_info: StringBlock) -> list:
	item_count = (block_info.end - block_info.start) // block_info.step
	with open(rom_path, "rb") as rom:
		data = rom.read()

	for i in range(item_count):
		start = block_info.start + (i * block_info.step)
		stop = start + block_info.step
		# obj = Enemy(i, data[start:stop])
		obj = Item(i, data[start:stop])

		if i == 0:
			print("\t".join(obj.__dict__.keys()))
		print("\t".join([str(x) for x in obj.__dict__.values()]))


def dump_encounter_info(rom_path: Path) -> str:
	# TODO this should return a string instead of just printing it
	print('enc_ptr', 'enc_id', 'enc_lvl',
							'enc_qty', 'enc_rate', 'enemy_id', sep='\t')
	with open(rom_path, "rb") as rom:
		encounter_pointer_base = 0x21c24
		for i in range(16):
			rom.seek(encounter_pointer_base + (i * 6))
			enc_id, enc_ptr = struct.unpack(">HI", rom.read(6))
			rom.seek(enc_ptr)
			enc_lvl, enc_qty, enc_rate = struct.unpack(">BBH", rom.read(4))
			for j in range(enc_qty):
				enemy_id = f'0x{struct.unpack(">H", rom.read(2))[0]:0x}'
				print(f'0x{enc_ptr:0x}', enc_id, enc_lvl, enc_qty,
										f'{enc_rate/65535:.0%}', enemy_id, sep="\t")
	# skip null bytes
		while True:
			enc_id, enc_ptr = struct.unpack(">HI", rom.read(6))
			# print(f'{rom.tell()=:0x}, {enc_ptr=:0x}, {enc_id=:0x}')
			if enc_ptr > rom.tell() + 2:
				break
			rom.seek(enc_ptr)
			enc_lvl, enc_qty, enc_rate = struct.unpack(">BBH", rom.read(4))
			for j in range(enc_qty):
				enemy_id = f'0x{struct.unpack(">H", rom.read(2))[0]:0x}'
				print(f'0x{enc_ptr:0x}', enc_id, enc_lvl, enc_qty,
										f'{enc_rate/65535:.0%}', enemy_id, sep="\t")

		encounter_pointer_base = rom.tell()
		rom.seek(enc_ptr)
		enc_lvl, enc_qty, enc_rate = struct.unpack(">BBH", rom.read(4))
		for j in range(enc_qty):
			enemy_id = f'0x{struct.unpack(">H", rom.read(2))[0]:0x}'
			print(f'0x{enc_ptr:0x}', enc_id, enc_lvl, enc_qty,
									f'{enc_rate/65535:.0%}', enemy_id, sep="\t")

		for i in range(14):
			rom.seek(encounter_pointer_base + (i * 6))
			enc_id, enc_ptr = struct.unpack(">HI", rom.read(6))
			rom.seek(enc_ptr)
			enc_lvl, enc_qty, enc_rate = struct.unpack(">BBH", rom.read(4))
			for j in range(enc_qty):
				enemy_id = f'0x{struct.unpack(">H", rom.read(2))[0]:0x}'
				print(f'0x{enc_ptr:0x}', enc_id, enc_lvl, enc_qty,
										f'{enc_rate/65535:.0%}', enemy_id, sep="\t")

		while True:
			enc_id, enc_ptr = struct.unpack(">HI", rom.read(6))
			if enc_ptr > rom.tell() + 2:
				break
			rom.seek(enc_ptr)
			enc_lvl, enc_qty, enc_rate = struct.unpack(">BBH", rom.read(4))
			for j in range(enc_qty):
				enemy_id = f'0x{struct.unpack(">H", rom.read(2))[0]:0x}'
				print(f'0x{enc_ptr:0x}', enc_id, enc_lvl, enc_qty,
										f'{enc_rate/65535:.0%}', enemy_id, sep="\t")


def dump_level_growth(rom_path: Path, party: list) -> str:
	# TODO this should return a string instead of just printing it
	ptr_pos = 0x1d47a
	# tbl_pos = 0x1d4c6
	print("name", "level", "stamina", "mind",
							"vitality", "speed", "hp", "mp", sep="\t")
	with open(rom_path, "rb") as rom:
		rom.seek(ptr_pos)
		# pointers are 4 bytes
		ptr_data = struct.unpack(
									">" + "I"*len(party),
									rom.read(len(party) * struct.calcsize("I")))

		# each party member has a growth table
		# level up growth data contains 8 bytes
		# max level is 54, so 53 level ups from 1-53
		# tbl_data = rom.read(len(party) * struct.calcsize("II") * 53)

		for member, tbl_ptr in zip(party, ptr_data):
			rom.seek(tbl_ptr)
			for i in range(53):
				stats = "\t".join([str(x) for x in struct.unpack(">BBBBHH", rom.read(8))])
				print(member, i+2, stats, sep="\t")

	# tbl_ptrs = struct.unpack(">"+"I"*len(party), ptr_data)


# real_monster_block = StringBlock('mon', 0x1519a, 0x16c30, 0x40, 10)
# dump_data_blocks(original_rom.path, real_monster_block)
# dump_data_blocks(original_rom.path, item_block)
# dump_level_growth(original_rom.path, party)
# print(dump_fixed_str(original_rom.path, ja_menu_tbl, town_block))
# dump_encounter_info(original_rom.path)


free_space = make_space_from_file(tling_rom.path, script_files)
print(f"cleared {free_space} bytes")

for script_file in script_files:
	insert_from_file(tling_rom.path, script_file)

# these lines fill fixed length text blocks with debug strings
for block in fixed_len_strings:
	insert_fixed_str(tling_rom.path, block)

print("Inserted fixed length strings")
