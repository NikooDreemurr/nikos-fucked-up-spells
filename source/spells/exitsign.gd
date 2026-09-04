extends Spell

const SEEYA = preload("res://mods/evil_cat/sounds/spells/discordleave.wav")

func _use():
	if Game.enemy == null:
		_end_use()
		return

	Game.difficulty = mini(Game.difficulty + 1, 10)
	Game.update_balance_vars()
	Game.difficulty_changed.emit()

	AudioManager.play_sound(SEEYA)

	main.end_battle(true)

	player_spell_slot.despawn()