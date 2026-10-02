extends Spell

const FART = preload("res://mods/fun_spells/sounds/spells/hfart.wav")
var RAINBOW_MATERIAL: Material = load("res://data/materials/ssn_shader.tres")
const RAINBOW_SPEED: = 60.0

const CRASH_CHANCE: = 0.1

var hue_offset: float = 0.0
var saturation_offset: float = 0.0


func _process(delta: float) -> void :
	hue_offset = fmod(hue_offset + RAINBOW_SPEED * delta, 360.0)
	shader_state_updated.emit()


func get_material() -> Material:
	return RAINBOW_MATERIAL


func update_instance_shader_parameters(instance: CanvasItem, censored: bool, show_outline: bool) -> void :
	super.update_instance_shader_parameters(instance, censored, show_outline)
	instance.set_instance_shader_parameter("hsv_offset", Vector2(hue_offset, saturation_offset))


func _use():
	AudioManager.play_sound(FART)

	player.heal(1)

	if rng.spell.randf() < CRASH_CHANCE:
		_fake_crash()
		return

	_post_use()


func _fake_crash() -> void :
	AudioManager.fade_music()
	AudioManager.fade_sounds()

	main.get_tree().paused = true

	await Game.timeout(1.5)

	main.get_tree().quit()