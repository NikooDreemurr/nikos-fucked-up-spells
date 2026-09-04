extends Spell


func set_status_tooltips():
	status_tooltips = [TileStatus.SPICY]


func _use():
	var available_tiles = get_tiles({
		effect_priority = EFFECT_PRIORITY.STATUS_AND_FACE,
	})

	# ECHO SAID IF I OVERRIDE THE EXISTING VOWELS HE'LL KILL ME
	available_tiles = available_tiles.filter(func(tile: Tile):
		return not tile.face.to_upper() in ["A", "E", "I", "O", "U", "Y"]
	)

	if available_tiles.is_empty():
		_end_use()
		return

	var max_attempts = 20
	var attempts = 0

	var vowelless_word := ""

	while vowelless_word.is_empty() and attempts < max_attempts:
		var word = WordUtility.dictionary.pick_random_flag_word(
			WordDictionary.WordFlags.SLUR,
			rng.spell.randi_range(1, 12),
			rng.spell
		)

		vowelless_word = word

		for vowel in ["A", "E", "I", "O", "U", "Y", "a", "e", "i", "o", "u", "y"]: # im not arguing with violeta or everyone in that matter
			vowelless_word = vowelless_word.replace(vowel, "")

		attempts += 1

	if vowelless_word.is_empty():
		_end_use()
		return

	var letters = vowelless_word.split("", false)

	if letters.is_empty():
		_end_use()
		return

	rng.spell.shuffle(available_tiles)

	var amount = min(letters.size(), available_tiles.size())

	AudioManager.play_sound(Sounds.SPELLS.DICE_ROLL_3)

	for i in amount:
		var tile: Tile = available_tiles[i]

		tile.remove_face_statuses()
		tile.set_face(letters[i])
		tile.add_status(TileStatus.SPICY)
		tile.add_poofcloud(tile.get_color())

		await Game.timeout(0.06)

	_post_use()
