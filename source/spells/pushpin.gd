extends Spell

func _use():
	var enemy = Game.enemy

	if enemy == null:
		_end_use()
		return

	if enemy.id == Enemies.NEW_COP or enemy.id == Enemies.SHERIFF:
		enemy.health = 0
		await enemy.animate_flinch_lethal()
	else:
		enemy.hurt(0.1, Globals.DamageType.DIRECT) # there's no way in hell it actually damages anything unless i set it to 1

	_post_use()