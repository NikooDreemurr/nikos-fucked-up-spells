extends Spell


const CYCLE_STEP_DELAY: = 0.03
const MAX_CYCLES: = 2

var stop_requested: = false


func _use():
	var selected_tile = await get_selection()

	if selected_tile == null:
		_end_use()
		return

	AudioManager.play_sound(Sounds.SPELLS.DICE_ROLL_1)

	stop_requested = false
	_listen_for_stop(selected_tile)

	var reversed_alphabet: Array = Letters.ALPHABET.duplicate()
	reversed_alphabet.reverse()

	var total_steps: = reversed_alphabet.size() * MAX_CYCLES

	for i in total_steps:
		if stop_requested:
			break

		selected_tile.set_face(reversed_alphabet[i % reversed_alphabet.size()])

		await Game.timeout(CYCLE_STEP_DELAY)

	selected_tile.add_poofcloud(selected_tile.get_color())

	_post_use()


func _listen_for_stop(tile: Tile) -> void :
	var stop_tile = await player.get_selection(player.Selection.TILE, func(t): return t == tile)

	if stop_tile != null:
		stop_requested = true