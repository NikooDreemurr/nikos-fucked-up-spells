extends Spell

const CHARACTER_FACES = { # this is my headcanon, if you dont like it.. *sniffles*
	Globals.CHARACTERS.LEXICOGRAPHER: "o",
	Globals.CHARACTERS.ADDICT: "o",
	Globals.CHARACTERS.JUBILIST: "a",
	Globals.CHARACTERS.CHILD: "b",
	Globals.CHARACTERS.FISHER: "ab",
}

const BONUS_CHANCE: = 0.3 


func set_status_tooltips():
	status_tooltips = [TileStatus.CRIT, TileStatus.CAPITAL]


func get_character_face() -> String:
	return CHARACTER_FACES.get(Game.player.id, "o")


func get_tooltip_context() -> Dictionary:
	return {blood_type = get_character_face()}


func _use():
	var selected_tile = await get_selection()

	if selected_tile == null:
		_end_use()
		return

	var face: = get_character_face()

	AudioManager.play_sound(Sounds.LIQUID_HUMAN.DO_NOTHING)

	player.hurt(1, Globals.DamageType.DIRECT, false)

	selected_tile.set_face(face)
	selected_tile.add_status(TileStatus.CRIT)
	selected_tile.add_poofcloud(selected_tile.get_color())

	if rng.spell.randf() < BONUS_CHANCE:
		if rng.spell.randi_range(0, 1) == 0:
			var target_tiles = get_tiles({
				amount = 1,
				effect_priority = EFFECT_PRIORITY.STATUS_AND_FACE,
				exclude_tiles = [selected_tile],
			})

			for tile in target_tiles:
				tile.set_face(face)
				tile.add_status(TileStatus.CRIT)
				tile.add_poofcloud(tile.get_color())
		else:
			selected_tile.add_status(TileStatus.CAPITAL) # fuck you

	_post_use()