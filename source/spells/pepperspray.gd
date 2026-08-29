extends Spell

const NOOP_CALL: = "get_instance_id"

var _disabled_move: Dictionary = {}
var _had_custom_call: = false
var _original_custom_call = null

func set_status_tooltips():
	status_tooltips = [TileStatus.SPICY]

func is_usable() -> bool:
	return super.is_usable() and Game.enemy != null and not Game.enemy.is_defeated


func _use():
	if not is_usable():
		_end_use()
		return

	AudioManager.play_sound(Sounds.SPELLS.SPRAY_SHORT)

	var enemy: = Game.enemy
	var move: Dictionary = enemy.moves[enemy.next_move]

	_disabled_move = move
	_had_custom_call = "custom_call" in move
	_original_custom_call = move.get("custom_call", null)

	move.custom_call = NOOP_CALL

	await enemy.clear_intent()

	enemy.action_finished.connect(_restore_move, CONNECT_ONE_SHOT)

	enemy.flinch(0)

	var target_tiles = get_tiles({
		amount = rng.spell.randi_range(1, 5),
		effect_priority = EFFECT_PRIORITY.STATUS_AND_FACE,
	})

	for tile in target_tiles:
		tile.add_status(TileStatus.SPICY)
		tile.add_poofcloud(tile.get_color())

	_post_use()


func _restore_move() -> void :
	if _disabled_move.is_empty():
		return

	if _had_custom_call:
		_disabled_move.custom_call = _original_custom_call
	else:
		_disabled_move.erase("custom_call")

	_disabled_move = {}