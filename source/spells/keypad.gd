extends Spell


var saved_board = null

func return_board():
	if saved_board == null:
		return

	if not tile_board.has_flag("spell_keypad"):
		return

	await tile_board.slide_out()

	await tile_board.reset_tiles(true)

	tile_board.load_tile_state_save_data(saved_board, true)

	saved_board = null
	tile_board.remove_flag("spell_keypad")

	await tile_board.slide_in()


func _use():
	tile_board.turn_ended.connect(_on_turn_ended)
	if tile_board.has_flag("spell_keypad"):
		_end_use()
		return

	saved_board = tile_board.get_tile_state_save_data(true)

	await tile_board.slide_out()
	await tile_board.reset_tiles(true)

	tile_board.set_size(3, 3, 0, 0, true, 0.0)
	tile_board.queue.clear_outside_columns()
	tile_board.update_previews()

	for number in range(9):
		var tile: Tile = tile_board.create_tile()
		main.add_child(tile)

		tile.add_status(TileStatus.DEFAULT)

		if number == 0:
			tile.set_face("*")
		else:
			tile.set_face(str(number + 1))

		var coordinate = Vector2i(
			number % 3,
			2 - (number / 3)
		)

		tile_board.insert_tile(tile, coordinate, false)

	tile_board.add_flag("spell_keypad")

	await tile_board.slide_in()

	_post_use()


func _on_turn_ended():
	if tile_board.has_flag("spell_keypad"):
		await return_board()