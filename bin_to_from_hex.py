from pathlib import Path
import struct


def cwd_path(name: str) -> Path:
	cwd = Path(__file__).resolve().parent
	return Path(str(cwd) + "/" + str(name))


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


def text_to_hex(string: str, tbl: dict) -> str:
	""" Convert string into hex by looking for matches in tbl,
		returning a string of hex codes """
	ret_str = ''
	longest_lookup = len(max(tbl.keys(), key=len))

	while len(string) >= 1:
		# grab longest possible match, reducing the size until
		# a match is found
		for x in range(longest_lookup, 0, -1):
			nibble = string[0:x]
			if nibble in tbl.keys():
				ret_str += tbl[nibble]
				string = string[x:]
				break

	return ret_str


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

	return bin_string


# change these filenames
extract_table = build_tbl(cwd_path("en_tbl.tbl"))
insert_table = build_tbl(cwd_path("en_tbl.tbl"), reverse=True)
rom = cwd_path("foobar.bin")

# change the offsets
bin_string = direct_dump(rom, 0x41a40, 0x41a80)

text, missing = bin_to_text(bin_string, extract_table)
print(text)

bin_string = text_to_hex(text, insert_table)
print(bin_string)
