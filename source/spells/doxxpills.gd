class_name EnemyIDSpell extends TileModifierSpell

var SSN_MATERIAL: Material = load("res://data/materials/ssn_shader.tres")
const POSSIBLE_STATUSES = [TileStatus.CANDY, TileStatus.ENHANCED, TileStatus.ETERNAL, TileStatus.BOMB, TileStatus.FROZEN]

const CHARACTER_EXCLUDE_STATUSES = {
	"2": [TileStatus.ENHANCED],
	"3": [TileStatus.CANDY],
	"4": [TileStatus.BOMB],
	"8": [TileStatus.BOMB],
	"9": [TileStatus.FROZEN],
}

var number: String = ""
var status: String = TileStatus.DEFAULT

var hue_offset: float = 0.0
var saturation_offset: float = 0.0
var frame: int = 0


func _setup_enemy_id(enemy_id: Variant) -> void :
	if enemy_id == null:
		number = "3"
		status = TileStatus.GAY
		hue_offset = 0.0
		saturation_offset = 0.0
		return

	var id_string: = str(enemy_id)
	var last_letter: = id_string.substr(id_string.length() - 1, 1)
	var user_rng: = get_user_rng(enemy_id)

	# theres like 26 alphabets, so we running it back
	var alphabet_position: = Letters.ALPHABET.find(last_letter) + 1

	if alphabet_position <= 0:
		number = user_rng.pick_random(Letters.NUMPAD_CHARACTERS.keys())
	else:
		var folded: = ((alphabet_position - 1) % 8) + 2
		number = str(folded)

	var status_pool = POSSIBLE_STATUSES.duplicate()
	if number in CHARACTER_EXCLUDE_STATUSES:
		for exclude_status in CHARACTER_EXCLUDE_STATUSES[number]:
			status_pool.erase(exclude_status)

	status = user_rng.pick_random(status_pool)

	if number == "5" and status == TileStatus.ETERNAL:
		status_pool.erase(TileStatus.ETERNAL)
		status = user_rng.pick_random(status_pool)

	hue_offset = user_rng.randf_range(0.0, 360.0)
	saturation_offset = user_rng.randf_range(-0.1, 0.2)
	frame = user_rng.randi_range(0, 2)
	frame_updated.emit()
	shader_state_updated.emit()
	set_status_tooltips()


func _spell_init():
	_setup_enemy_id(null)


func battle_started():
	super.battle_started()
	_setup_enemy_id(Game.enemy.id if Game.enemy != null else null)


func get_hv_frames() -> Vector2i:
	return Vector2i(3, 1)


func get_frame() -> int:
	return frame


func get_material() -> Material:
	return SSN_MATERIAL


func update_instance_shader_parameters(instance: CanvasItem, censored: bool, show_outline: bool) -> void :
	super.update_instance_shader_parameters(instance, censored, show_outline)
	instance.set_instance_shader_parameter("hsv_offset", Vector2(hue_offset, saturation_offset))


func get_user_rng(enemy_id: Variant) -> RNG:
	var id_string = str(enemy_id)
	var user_rng: = RNG.new()
	user_rng.set_seed(id_string.hash())
	return user_rng


func get_excluded_charges() -> PackedStringArray:
	if number in Letters.NUMPAD_CHARACTERS:
		return Letters.NUMPAD_CHARACTERS[number]
	else:
		return []


func set_status_tooltips():
	if status == TileStatus.DEFAULT:
		return
	elif status == TileStatus.BOMB:
		status_tooltips = [{status = TileStatus.BOMB, bomb_turns = 2}]
	else:
		status_tooltips = [status]


func get_tooltip_context():
	return {
		status_name = StringManager.get_string("status/" + status + "/name"),
		number = number,
		letters = Letters.NUMPAD_CHARACTERS[number],
	}


func apply_to_tile(tile: Tile, _real_tile: Tile, is_preview: bool, _is_preview_update: bool) -> void :
	if status == TileStatus.BOMB:
		tile.add_status(status, 2)
	else:
		tile.add_status(status)

	tile.set_face(number)

	if not is_preview:
		AudioManager.play_sound(Sounds.SPELLS.BOX_SHUFFLE)
		tile.add_poofcloud(tile.get_color())


func is_tile_selectable(tile: Tile) -> bool:
	return tile.is_face_modifiable() and not tile.has_harmful_status() and not (tile.has_status(status) and tile.only_face_is(number))