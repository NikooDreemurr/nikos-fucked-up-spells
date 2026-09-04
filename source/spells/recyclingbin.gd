extends Spell


func set_status_tooltips():
	status_tooltips = [{status = "wildcard", wildcard_letter = "$"}, TileStatus.MONEY]


func _use():
	var plastic_tiles = get_tiles({type = TileType.DEFENSE})

	if plastic_tiles.is_empty():
		_end_use()
		return

	await tile_board.remove_tiles(plastic_tiles, {interval = 0.08, tile_color = true})

	var uses_crit: bool = Game.player.id in [Globals.CHARACTERS.CHILD, Globals.CHARACTERS.ADDICT]
	var converted_tiles: Array[Tile] = []

	# 1 for every 6 tiles removed
	var guaranteed_conversions: = plastic_tiles.size() / 6
	var remainder: = plastic_tiles.size() % 6

	var conversions: = guaranteed_conversions
	if remainder > 0 and rng.spell.randf() < (remainder / 6.0):
		conversions += 1

	for i in conversions:
		var target_tiles = get_tiles({
			amount = 1,
			effect_priority = EFFECT_PRIORITY.STATUS_AND_FACE,
			exclude_tiles = converted_tiles,
		})

		if target_tiles.is_empty():
			continue

		var target_tile = target_tiles[0]
		converted_tiles.append(target_tile)

		if uses_crit:
			target_tile.add_status(TileStatus.CRIT)
		else:
			target_tile.add_status(TileStatus.MONEY)
			target_tile.set_face("**")

		AudioManager.play_sound(Sounds.SPELLS.BOX_SHUFFLE)
		target_tile.add_poofcloud(target_tile.get_color())

	_post_use()