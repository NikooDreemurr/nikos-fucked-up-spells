extends TileModifierSpell


func set_status_tooltips():
	status_tooltips = [TileStatus.HOLE]


func apply_to_tile(tile: Tile, _real_tile: Tile, is_preview: bool, _is_preview_update: bool) -> void :
	if is_preview:
		tile.set_face("47")
		return

	AudioManager.play_sound(Sounds.SPELLS.STAMP_BIG)

	if rng.spell.randf() < (4.0 / 5.0):
		tile.set_face("47")
		tile.add_poofcloud(tile.get_color())
	else:
		var row = tile.get_coord().y

		var row_tiles = get_tiles({
			rows = [row],
			sorted = true,
		})

		for row_tile in row_tiles:
			row_tile.apply_hole(true)
			row_tile.add_poofcloud(Globals.COLORS.SMOKE)


func is_tile_selectable(tile: Tile) -> bool:
	return tile.is_face_modifiable() and not tile.has_harmful_status()