extends Spell


func set_status_tooltips():
	status_tooltips = [TileStatus.HOLE, TileStatus.POOP]


func _use():
	var board_tiles = get_tiles({
		amount = 999,
		effect_priority = EFFECT_PRIORITY.STATUS_AND_FACE,
	})

	if board_tiles.is_empty():
		_end_use()
		return

	var highest_tile: Tile = board_tiles[0]
	var highest_value: = Letters.get_face_value(highest_tile.faces)

	for tile in board_tiles:
		var value: = Letters.get_face_value(tile.faces)
		if value > highest_value:
			highest_value = value
			highest_tile = tile

	AudioManager.play_sound(Sounds.SPELLS.GUNSHOT)
	highest_tile.apply_hole(true)
	highest_tile.add_poofcloud(Globals.COLORS.SMOKE)

	var neighbor_tiles = highest_tile.get_board_neighbors()

	for neighbor in neighbor_tiles:
		if rng.spell.randf() < (4.0 / 8.0):
			neighbor.add_status(TileStatus.POOP)
			neighbor.add_poofcloud(neighbor.get_color())

			await Game.timeout(0.1)

	_post_use()