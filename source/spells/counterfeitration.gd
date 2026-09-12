extends Spell


func _use():
	var chargeable_spells: Array[Spell] = []
	for spell in player.get_spells():
		if spell.spell_data.has_charge():
			chargeable_spells.append(spell)

	if chargeable_spells.size() < 2:
		_end_use()
		return

	var charges: Array[int] = []
	for spell in chargeable_spells:
		charges.append(spell.charge)
	charges.shuffle()

	var max_charge_spells: Array[Spell] = []
	var max_charges: Array[int] = []
	for spell in chargeable_spells:
		if not spell.spell_data.fixed_max_charge:
			max_charge_spells.append(spell)
			max_charges.append(spell.max_charge)
	max_charges.shuffle()

	AudioManager.play_sound(Sounds.SPELLS.SWITCH)

	for i in max_charge_spells.size():
		var spell = max_charge_spells[i]
		var new_max_charge: int = max_charges[i]

		if new_max_charge > spell.max_charge:
			spell.add_max_charge(new_max_charge - spell.max_charge)
		elif new_max_charge < spell.max_charge:
			spell.remove_max_charge(spell.max_charge - new_max_charge, false)

	for i in chargeable_spells.size():
		var spell = chargeable_spells[i]
		spell.charge = clampi(charges[i], 0, spell.max_charge)
		spell.animate_charge.emit()

	_post_use()