extends Spell


var has_triggered: = false


func generate_player_spell_tooltip(_tooltip: GameTooltip) -> void :

	if has_triggered or not is_owned():
		return
	has_triggered = true

	Game.player.hurt(5, Globals.DamageType.DIRECT, false)
	await player.recompose()

	player_spell_slot.despawn()
