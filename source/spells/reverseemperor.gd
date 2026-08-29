extends Spell


func is_usable() -> bool:
	return true


func _use():
	if not is_usable():
		_end_use()
		return

	force_enemy_encounter(Enemies.AGE_REGRESSOR)

	player_spell_slot.despawn()

	_post_use()


func force_enemy_encounter(enemy_id) -> void:
	var act_and_floor = Enemies.get_act_and_floor(enemy_id)

	main.force_skip_transition = false

	main.act = act_and_floor.act
	Game.debug_spawn_enemy = enemy_id
	main.generate_act()
	main.act_events = [{}] + main.act_events
	main.background.set_background_for_act(main.act)
	main.background.initialize_layers()
	main.background.play_pattern("loop")
	main.end_battle(true)
