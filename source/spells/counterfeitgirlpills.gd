extends TileModifierSpell


const FACES = ["ss", "88"]


func set_status_tooltips():
	status_tooltips = [TileStatus.HAZE]


func apply_to_tile(tile: Tile, real_tile: Tile, is_preview: bool, _is_preview_update: bool) -> void :
	if is_preview:
		tile.set_type(TileType.DEFENSE)
		tile.set_face(FACES[0])
		return

	AudioManager.play_sound(Sounds.HERARRA.FLINCH)

	tile.set_type(TileType.DEFENSE)
	tile.set_face(rng.spell.pick_random(FACES))
	tile.add_poofcloud(tile.get_color())

	var neighbors: = real_tile.get_board_neighbors()
	if neighbors.is_empty():
		return

	rng.spell.shuffle(neighbors)
	var neighbor: Tile = neighbors[0]

	await Game.timeout(0.16)

	neighbor.add_status(TileStatus.HAZE)
	neighbor.add_poofcloud(neighbor.get_color())


func is_tile_selectable(tile: Tile) -> bool:
	return tile.is_face_modifiable() and not tile.has_harmful_status()