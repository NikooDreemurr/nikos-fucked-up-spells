extends Spell


func set_status_tooltips():
	status_tooltips = [TileStatus.SPICY, TileEffect.SLASHED]


func _use():
	var selected_tile = await get_selection()

	if selected_tile == null:
		_end_use()
		return

	var column = selected_tile.get_coord().x

	var target_tiles = get_tiles({
		columns = [column],
		sorted = true,
	})

	if target_tiles.is_empty():
		selected_tile.animation.play("shake")
		_end_use()
		return

	AudioManager.play_sound(Sounds.CAT.BITE)

	for tile in target_tiles:
		tile.add_status(TileStatus.SPICY)
		tile.apply_slashed(rng.spell)
		tile.add_poofcloud(tile.get_color())

		await Game.timeout(0.08)

	_post_use()
