extends Spell


const SPIN_CYCLES: = 4
const CYCLE_DURATION: = 0.12
const BOUNCE_HEIGHT: = 14.0


func set_status_tooltips():
	status_tooltips = [TileStatus.CRIT]


func _use():
	var all_tiles = get_tiles({amount = 999, sorted = true})

	if all_tiles.is_empty():
		_end_use()
		return

	AudioManager.play_sound(Sounds.SPELLS.SWITCH)

	for cycle in SPIN_CYCLES:
		for tile in all_tiles:
			var tween: = tile.create_tween()
			tween.tween_property(tile, "position:y", tile.position.y - BOUNCE_HEIGHT, CYCLE_DURATION * 0.4)
			tween.tween_property(tile, "position:y", tile.position.y, CYCLE_DURATION * 0.6)

		await Game.timeout(CYCLE_DURATION)

	var row: = rng.spell.randi_range(0, tile_board.num_rows - 1)

	var row_tiles = get_tiles({
		rows = [row],
		sorted = true,
	})

	if row_tiles.is_empty():
		_post_use()
		return

	var reel_count: = mini(3, row_tiles.size())
	var reel_tiles: Array[Tile] = row_tiles.duplicate()
	rng.spell.shuffle(reel_tiles)
	reel_tiles = reel_tiles.slice(0, reel_count)

	var crit_count: = 0
	for tile in reel_tiles:
		if rng.spell.randf() < 0.5:
			tile.add_status(TileStatus.CRIT)
			tile.add_poofcloud(tile.get_color())
			crit_count += 1

	if crit_count == reel_count and reel_count == 3:
		AudioManager.play_sound(Sounds.SPELLS.STAMP_BIG)

		for tile in row_tiles:
			tile.add_status(TileStatus.CRIT)
			tile.add_poofcloud(tile.get_color())

			await Game.timeout(0.05)

	_post_use()