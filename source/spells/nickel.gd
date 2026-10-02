extends Spell


const CYCLE_STATUSES = [
	TileStatus.DEFAULT,
	TileStatus.CRIT,
	TileStatus.SPICY,
	TileStatus.BLEED,
	TileStatus.ENHANCED,
	TileStatus.FROZEN,
	TileStatus.POISON,
	TileStatus.CANDY,
	TileStatus.MONEY,
	TileStatus.BOMB,
	TileStatus.POOP,
	#TileStatus.SCREW, for some reason the screw stays
	TileStatus.BRUISE,
	TileStatus.MYSTERY,
	#TileStatus.CAPITAL,
	TileStatus.COAL,
	TileStatus.CURSED,
	#TileStatus.PERIOD,
	TileStatus.ASH,
	TileStatus.ETERNAL,
	TileStatus.HAZE,
	TileStatus.GAY
]

const CYCLE_STEP_DELAY: = 0.03
const MAX_CYCLES: = 2

var stop_requested: = false


func _use():
	var selected_tile = await get_selection()

	if selected_tile == null:
		_end_use()
		return

	AudioManager.play_sound(Sounds.SPELLS.SWITCH)

	stop_requested = false
	_listen_for_stop(selected_tile)

	var total_steps: = CYCLE_STATUSES.size() * MAX_CYCLES

	for i in total_steps:
		if stop_requested:
			break

		selected_tile.add_status(CYCLE_STATUSES[i % CYCLE_STATUSES.size()])

		await Game.timeout(CYCLE_STEP_DELAY)

	selected_tile.add_poofcloud(selected_tile.get_color())

	_post_use()


func _listen_for_stop(tile: Tile) -> void :
	var stop_tile = await player.get_selection(player.Selection.TILE, func(t): return t == tile)

	if stop_tile != null:
		stop_requested = true