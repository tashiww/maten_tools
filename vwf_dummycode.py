from pathlib import Path

class FilePath:
	""" Creates .path property from a filename to return a Path
		for the filename in the current working directory """
	cwd = Path(__file__).resolve().parent

	def __init__(self, fn):
		self.fn = fn
		self.path = Path(str(self.cwd) + "/" + fn)


def fill_tile(rom, old_tile, overflow, old_size, iteration):
	print(f'{iteration=}')
	iteration += 1
	if iteration > 30:
		return
	tile = []
	if overflow:
		old_tile = overflow
		print('overflow')
		overflow = []

	filled_px = 0
	letter = rom.read(0x10)
	print(f'{letter=}')
	for byte in letter:
		# print(f'{byte=}')
		# print(f'{bin(byte)=}')
		row = ''
		for bit in bin(byte)[2:]:
			# print(f'{bit=}')
			if bit == '0':
				row += 'E'
			else:
				row += 'F'
		row = row.rjust(8, 'E')
		try:
			filled_px = max(filled_px, row.rindex('F')+2)
		except ValueError:
			pass
		tile.append(row)

	print(f'{filled_px=}')
	if len(old_tile) > 0:
		for i in range(16):
			if filled_px + old_size >= 8:
				overflow.append(tile[i][8-old_size:].ljust(8, 'E'))
			tile[i] = old_tile[i][0:old_size] + tile[i][0:8-old_size]
	print('\n'.join(tile))
	print("=" * 5 + "overflow")
	print('\n'.join(overflow))
	print("=" * 5 + "end overflow")
	print(f'{filled_px=}')
	filled_px += old_size
	print(f'with old_size {filled_px=}')
	if filled_px > 8:
		filled_px = filled_px - 8
	print(f'with trim {filled_px=}')
	# filling same tile?
	fill_tile(rom, tile, overflow, filled_px, iteration)

# original_rom = FilePath("Maten no Soumetsu (Japan).md")
original_rom = FilePath("foobar.bin")

with open(original_rom.path, 'rb') as rom:
	rom.seek(0x64c76)
	tile = []
	overflow = []
	iteration = 0
	fill_tile(rom, tile, overflow, 0, iteration)
