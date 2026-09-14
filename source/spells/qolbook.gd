extends Spell


func _use():
	var vocab_size: int = SaveManager.get_save().word_stats.size()
	var digits: String = str(vocab_size)

	var letters: Array[String] = []
	for digit in digits:
		if digit in Letters.NUMPAD_CHARACTERS:
			letters.append(rng.spell.pick_random(Letters.NUMPAD_CHARACTERS[digit]))
		else:
			letters.append(rng.spell.pick_random(Letters.ALPHABET))

	var target_tiles = get_tiles({
		amount = letters.size(),
		effect_priority = EFFECT_PRIORITY.STATUS_AND_FACE,
	})

	if target_tiles.is_empty():
		_end_use()
		return

	AudioManager.play_sound(Sounds.SPELLS.STAMP_BIG)

	for i in target_tiles.size():
		var tile = target_tiles[i]
		var letter: String = letters[i % letters.size()]

		tile.set_face(letter)
		tile.add_poofcloud(tile.get_color())

		await Game.timeout(0.08)

	_post_use()