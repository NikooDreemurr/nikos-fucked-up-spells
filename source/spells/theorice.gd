extends Spell


func _use():

	AudioManager.play_sound(Sounds.SPELLS.DICE_ROLL_1)

	var spell_select = Game.main.get_node("HUDLayer/SpellSelect")

	if spell_select == null or not spell_select.select_started or spell_select.select_completed:
		_end_use()
		return

	spell_select.select_started = false

	await reroll_animation(spell_select)

	spell_select.generate_spells()

	for panel in spell_select.get_spells():
		panel.modulate.a = 0.0

	for panel in spell_select.get_spells():
		var tween = panel.create_tween()
		tween.tween_property(panel, "modulate:a", 1.0, 0.2)

	spell_select.select_started = true

	_post_use()


func reroll_animation(spell_select):
	for panel in spell_select.get_spells():
		var tween = panel.create_tween()
		tween.tween_property(panel, "modulate:a", 0.0, 0.15)

	await Game.timeout(0.16)


func is_usable():
	var spell_select = Game.main.get_node("HUDLayer/SpellSelect")

	return (
		super.is_usable()
		and spell_select != null
		and spell_select.visible
		and spell_select.select_started
		and not spell_select.select_completed
	)