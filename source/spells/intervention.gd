extends Spell

const DAMNSON = preload("res://mods/fun_spells/sounds/spells/damnson.wav")

func _use():

	AudioManager.play_sound(DAMNSON)
	Game.enemy.hurt(99, Globals.DamageType.DIRECT)

	_post_use()