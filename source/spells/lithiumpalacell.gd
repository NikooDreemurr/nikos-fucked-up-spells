extends Spell


func _use():
	var condition = func(spell):
		return spell.is_owned() and spell.charge < spell.max_charge

	var chosen_spell = await player.get_selection(player.Selection.SPELL, condition)

	if chosen_spell == null:
		_end_use()
		return

	elif not condition.call(chosen_spell):
		_end_use()
		return

	chosen_spell.add_charge(1, true)

	var valid_tiles: Array[Tile] = []

	for tile in tile_board.get_tiles():
		var coord = tile_board.get_tile_coord(tile)

		if coord.y < tile_board.num_rows - 1:
			valid_tiles.append(tile)

	rng.spell.shuffle(valid_tiles)

	AudioManager.play_sound(Sounds.SPELLS.SPRAY_SHORT)

	var acid_amount = mini(
		rng.spell.randi_range(2, 5),
		valid_tiles.size()
	)

	for i in acid_amount:
		var tile: Tile = valid_tiles[i]

		tile.add_status(TileStatus.ACID)
		tile.add_poofcloud(tile.get_color())

	_post_use()