extends Spell


const CRIT_CHANCE: = 0.1

func set_status_tooltips():
	status_tooltips = [TileStatus.ENHANCED, TileStatus.CRIT]


func _use():
	main.turn_timer.appearing = true
	main.turn_timer.time_scale = 1
	main.turn_timer.enable()

	word_builder.post_tile_stats.connect(_on_word_builder_post_tile_stats, CONNECT_ONE_SHOT)
	player.turn_ended.connect(_disable_timer, CONNECT_ONE_SHOT)

	AudioManager.play_sound(Sounds.SPELLS.SWITCH)

	_post_use()


func _on_word_builder_post_tile_stats(_words) -> void :
	for tile: Tile in word_builder.tiles:
		if tile.face in Letters.VOWELS:
			if rng.spell.randf() < CRIT_CHANCE:
				tile.add_status(TileStatus.CRIT)
			else:
				tile.add_status(TileStatus.ENHANCED)

			tile.add_poofcloud(tile.get_color())


func _disable_timer() -> void :
	main.turn_timer.appearing = false

	if Game.player.id != Globals.CHARACTERS.ADDICT:
		main.turn_timer.enabled = false
