extends Spell


func _use():
	var words: WordList = word_builder.get_words()

	if not word_builder.can_submit_tiles() or not word_builder.can_submit_words(words):
		_end_use()
		return

	var word_tiles: Array[Tile] = word_builder.tiles

	if word_tiles.is_empty():
		_end_use()
		return

	var selected_tile = await get_selection()

	if selected_tile == null:
		_end_use()
		return

	var row = selected_tile.get_coord().y

	var row_tiles = get_tiles({
		rows = [row],
		sorted = true,
	})

	if row_tiles.is_empty():
		selected_tile.animation.play("shake")
		_end_use()
		return

	AudioManager.play_sound(Sounds.SPELLS.SWITCH)

	for i in row_tiles.size():
		var word_tile: Tile = word_tiles[i % word_tiles.size()]
		var letter: String = word_tile.face

		var shift_amount: = Letters.ALPHABET.find(letter) + 1
		if shift_amount <= 0:
			continue

		var tile = row_tiles[i]
		tile.set_face(Letters.shift_face(tile.face, [Letters.ALPHABET], shift_amount))
		tile.add_poofcloud(tile.get_color())

		await Game.timeout(0.08)

	_post_use()