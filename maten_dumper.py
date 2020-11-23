from pathlib import Path
import struct
import re


# maten no shoumetsu ROM
rom_filename = "Maten no Soumetsu (Japan).md"
tbl_filename = "closer.tbl"

# place output file in current script directory
cwd = Path(__file__).resolve().parent
out = Path(str(cwd) + "/test_dump.txt")

rom_path = Path(str(cwd) + "/" + rom_filename)
tbl_path = Path(str(cwd) + "/" + tbl_filename)

# empty the file before we start writing to it
out.open("w").close()
out = out.open("a")


def fprint(text, mode="both", fout=out):
	""" outputs text to modes: stdout, file, or both """

	if mode == 'stdout' or mode == 'both':
		print(text)
	if mode == 'file' or mode == 'both':
		out.write(str(text) + '\n')


def extract_text(src_file, loc, length):
	""" return a string of length bytes from loc in src_file """

	src_file.seek(loc, 0)
	text = src_file.read(length).decode("utf-16", "ignore")
	text = re.sub(r'\x00+', '\n', text)

	return text


def read_header(src_file, file_ptr):
	""" return dict of rel_ptr, abs_ptr, script_len
		from src_file @ file_ptr location """

	# skip first four bytes of file header
	src_file.seek(file_ptr+4*4, 0)

	# relative pointers for two text blocks and their lengths
	names_ptr, names_len, script_ptr, script_len = \
		struct.unpack("<IIII", src_file.read(16))

	return {
			"rel_ptr": script_ptr,
			"script_len": script_len,
			"abs_ptr": script_ptr+file_ptr
			}


def read_script(script_path, file_ptr=0, file_name=None):
	""" parse header and output text from script files,
		starting at file_ptr offset """
	with open(script_path, 'rb') as script_file:
		header = read_header(script_file, file_ptr)
		if header['script_len'] > 0:
			# print file path / name starting from /common/
			fprint("Script File: " + "/".join(script_path.parts[3:]))

			if file_name:
				fprint(f"internal filename: {file_name}")

			fprint(f"script_location: {header['abs_ptr']}, " +
										f"script_length: {header['script_len']}")
			fprint("==="*15)
			text = extract_text(script_file, header['abs_ptr'], header['script_len'])
			fprint(text, 'file')


def tbl_parse(tbl, rom, offset):
	""" takes a dict as lookup table and bytearray as string """
	parsed = ''
	rom.seek(offset, 0)
	missing = 0
	while True:
		byte = rom.read(1).hex()
		if byte is None or byte == '00':
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


def build_tbl(tbl_path):
	"""build lookup dictionary from thingy table
	code=char
	"""
	tbl = {}
	with open(tbl_path, "r") as tbl_file:
		raw_tbl = tbl_file.read().splitlines()
		for line in raw_tbl:
			split = line.split("=")
			tbl[split[0].lower()] = split[1]
	return tbl


tbl = build_tbl(tbl_path)
rom_size = rom_path.stat().st_size
rom = rom_path.open("rb")
test_offset = 0x323B0
i = 0
while rom.tell() < rom_size:
	prefix = struct.unpack(">H", rom.read(2))[0]

	# text pointers are prefixed with $0007
	if prefix == 7:
		ptr_loc = rom.tell()
		ptr = struct.unpack(">I", rom.read(4))[0]
		# conservative bounds for text $20000 - $60000
		# but might miss some strings? $23AF0 for first ptr_loc is
		# probably too aggressive
		if str(f'{ptr:08x}')[0:3] == '000' \
					and ptr_loc > 0x00023000 \
					and ptr_loc < 0x0045000 \
					and ptr > 0x00023000 \
					and ptr < 0x0045000:
			text, missing = tbl_parse(tbl, rom, ptr)
			if len(text) > 0 and not missing:
				fprint(f"String {i}")
				fprint(f'Pointer offset: 0x{ptr_loc:00x}')
				fprint(f'String offset: 0x{ptr:00x}')
				if missing:
					fprint(f"WARNING: {missing} failed lookup bytes")
				fprint(text+"\n")
				i += 1
			rom.seek(ptr_loc, 0)
