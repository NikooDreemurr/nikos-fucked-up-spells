extends Spell


func _use():
	var time: Dictionary = Time.get_time_dict_from_system()
	var time_string: = "%02d%02d" % [time.hour, time.minute]

	var digits: Array = []
	for character in time_string:
		if character == "0":
			digits.append("zero")
		elif character == "1":
			digits.append("one")
		else:
			digits.append(character)

	var amount: = rng.spell.randi_range(1, digits.size())

	var target_tiles = get_tiles({
		amount = amount,
		effect_priority = EFFECT_PRIORITY.STATUS_AND_FACE,
	})

	if target_tiles.is_empty():
		_end_use()
		return

	rng.spell.shuffle(digits)

	AudioManager.play_sound(Sounds.SPELLS.SWITCH)

	for i in target_tiles.size():
		var tile = target_tiles[i]
		var digit: String = digits[i % digits.size()]

		tile.set_type(TileType.DEFENSE)
		tile.set_face(digit)
		tile.add_poofcloud(tile.get_color())

		await Game.timeout(0.08)

	_post_use()
