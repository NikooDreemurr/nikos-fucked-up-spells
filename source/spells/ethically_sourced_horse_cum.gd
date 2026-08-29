extends Spell

const NEIGH = preload("res://mods/evil_cat/sounds/spells/horsecum.wav")

func set_status_tooltips():
	status_tooltips = [TileStatus.ENHANCED, TileStatus.GUNK]


func _use():
	for row in range(1, tile_board.num_rows):
		var target_tiles = get_tiles({
			rows = [row],
			sorted = true,
		})

		AudioManager.play_sound(NEIGH)

		for tile in target_tiles:
			tile.add_status(TileStatus.ENHANCED)
			tile.add_poofcloud(tile.get_color())
			await Game.timeout(0.08)

	var bottom_row = get_tiles({
		rows = [0],
		sorted = true,
	})

	for tile in bottom_row:
		tile.add_status(TileStatus.GUNK)
		tile.add_poofcloud(tile.get_color())
		await Game.timeout(0.08)

	_post_use()
