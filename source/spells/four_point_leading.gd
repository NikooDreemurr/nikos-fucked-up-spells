extends Spell


var swapping: = false


func get_tooltip_context():
	return {swapping = swapping}


func _use():
	swapping = false

	var tile_a = await get_selection()

	if tile_a == null:
		_end_use()
		return

	tile_a.animation.play("pressed")

	var row_a: = tile_a.get_coord().y

	swapping = true
	update_banner_label()

	var tile_b = await get_selection(get_tiles({rows = [row_a]}))

	if tile_b == null:
		_end_use()
		return

	var row_b: = tile_b.get_coord().y

	AudioManager.play_sound(Sounds.SPELLS.SWITCH)

	for column in tile_board.num_columns:
		var swap_a = tile_board.get_tile_at(Vector2i(column, row_a))
		var swap_b = tile_board.get_tile_at(Vector2i(column, row_b))

		if swap_a == null or swap_b == null:
			continue

		await tile_board.swap_tiles(swap_a, swap_b, 0.08, 0.04)

	_post_use()