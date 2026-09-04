extends Spell


func set_status_tooltips():
	status_tooltips = [TileStatus.CANDY, TileStatus.GUNK]


func _use():
	var candy_tiles = get_tiles({
		amount = rng.spell.randi_range(2, 4),
		effect_priority = EFFECT_PRIORITY.STATUS_AND_FACE,
	})

	var gunk_tiles = get_tiles({
		amount = rng.spell.randi_range(2, 4),
		effect_priority = EFFECT_PRIORITY.STATUS_AND_FACE,
		exclude_effects = [TileStatus.GUNK],
		exclude_tiles = candy_tiles,
	})

	if candy_tiles.is_empty() and gunk_tiles.is_empty():
		_end_use()
		return

	AudioManager.play_sound(Sounds.NOPPY.POP)

	for tile in candy_tiles:
		tile.add_status(TileStatus.CANDY)
		tile.add_poofcloud(tile.get_color())

		await Game.timeout(0.08)

	for tile in gunk_tiles:
		tile.add_status(TileStatus.GUNK)
		tile.add_poofcloud(tile.get_color())

		await Game.timeout(0.08)

	_post_use()