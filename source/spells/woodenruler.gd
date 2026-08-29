extends Spell


var saved_board = null


func _use():
	var selected_tile = await get_selection()

	if selected_tile == null:
		_end_use()
		return

	var coord = selected_tile.get_coord()

	var width = tile_board.num_columns
	var height = tile_board.num_rows

	var expand_mode: TileBoard.ExpandMode
	var new_width = width
	var new_height = height

	# Bottom edge
	if coord.y == height - 1:
		expand_mode = TileBoard.ExpandMode.BOTTOM_LEFT
		new_height += 1

	# Top edge
	elif coord.y == 0:
		expand_mode = TileBoard.ExpandMode.TOP_RIGHT
		new_height += 1

	# Left/right edge
	elif coord.x == 0 or coord.x == width - 1:
		expand_mode = TileBoard.ExpandMode.CENTER
		new_width += 1

	else:
		selected_tile.animation.play("shake")
		_end_use()
		return

	saved_board = tile_board.get_tile_state_save_data(true)

	tile_board.add_flag("expanded_board")

	await tile_board.slide_out()

	await tile_board.set_size(
		new_width,
		new_height,
		null,
		null,
		false,
		0.33,
		expand_mode
	)

	tile_board.update_previews()

	await tile_board.slide_in()

	_post_use()


func return_board_if_able() -> void:
	if saved_board != null and tile_board.has_flag("expanded_board"):
		await tile_board.slide_out()

		tile_board.load_tile_state_save_data(saved_board, true)

		saved_board = null
		tile_board.remove_flag("expanded_board")

		await tile_board.slide_in()


func get_save_data():
	var save = super.get_save_data()
	save.saved_board = saved_board
	return save


func load_save_data(save):
	super.load_save_data(save)
	saved_board = save.saved_board
