extends TileModifierSpell


func set_status_tooltips():
	status_tooltips = [TileStatus.ENHANCED, TileStatus.CRIT]


func apply_to_tile(tile: Tile, real_tile: Tile, is_preview: bool, _is_preview_update: bool) -> void :
	tile.set_face("a")
	tile.add_status(TileStatus.ENHANCED)

	if is_preview:
		return

	AudioManager.play_sound(Sounds.SPELLS.BOX_SHUFFLE)
	tile.add_poofcloud(tile.get_color())

	var right_neighbor = real_tile.get_board_neighbor(Vector2i.RIGHT)

	if right_neighbor == null:
		return

	await Game.timeout(0.16)

	var neighbor_face: = "ll" if rng.spell.randi_range(0, 1) == 0 else "l"
	right_neighbor.set_face(neighbor_face)
	right_neighbor.add_status(TileStatus.CRIT)
	right_neighbor.add_poofcloud(right_neighbor.get_color())


func is_tile_selectable(tile: Tile) -> bool:
	return (
		tile.is_face_modifiable()
		and not tile.has_harmful_status()
		and not (tile.has_status(TileStatus.ENHANCED) and tile.only_face_is("a"))
	)