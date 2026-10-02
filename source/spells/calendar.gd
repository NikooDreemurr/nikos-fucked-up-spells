extends Spell


const MIN_TILES: = 1
const MAX_TILES: = 1 # adjustable for some stuff in the future


func set_status_tooltips():
	status_tooltips = [TileEffect.SLASHED, {status = "wildcard", wildcard_letter = "*"}]


func _number_to_face(number: int) -> String:
	var face: = ""
	for digit in str(number):
		if digit == "0" or digit == "1": # hazel please i need this
			face += "*"
		else:
			face += digit

	return face


func _use():
	var date: Dictionary = Time.get_date_dict_from_system()
	var slashed_faces: = PackedStringArray([
		_number_to_face(date.day),
		_number_to_face(date.month),
	])

	var target_tiles = get_tiles({
		amount = rng.spell.randi_range(MIN_TILES, MAX_TILES),
		custom_tile_check = func(tile: Tile, _params: Dictionary): return tile.has_face() and tile.is_face_modifiable(),
	})

	if target_tiles.is_empty():
		_end_use()
		return

	AudioManager.play_sound(Sounds.SPELLS.BOX_SHUFFLE)

	for tile in target_tiles:
		tile.set_slashed(slashed_faces)
		tile.add_poofcloud(Globals.COLORS.INK_BLACK)

		await Game.timeout(0.08)

	_post_use()
