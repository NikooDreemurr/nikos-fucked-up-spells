extends Spell

const STATUS_POOL = [
	TileStatus.MONEY,
	TileStatus.BLEED,
	TileStatus.ACID,
	TileStatus.POOP,
	TileStatus.ENHANCED,
	TileStatus.SPICY,
	TileStatus.GAY,
	TileStatus.BRUISE,
	TileStatus.CANDY,
	TileStatus.BOMB,
]

const HANDS = [
	{name = "high_card", groups = [1]},
	{name = "pair", groups = [2]},
	{name = "three_of_a_kind", groups = [3]},
	{name = "four_of_a_kind", groups = [4]},
	{name = "full_house", groups = [3, 2]},
	#{name = "five_of_a_kind", groups = [5]} # 5 acid diamond tiles doesnt sound fun
]


# func set_status_tooltips():
#	status_tooltips = [TileEffect.SUIT] + STATUS_POOL


func _use():
	var hand: Dictionary = rng.spell.pick_random(HANDS)

	var total_tiles: = 0
	for group_size in hand.groups:
		total_tiles += group_size

	var target_tiles = get_tiles({
		amount = total_tiles,
		effect_priority = EFFECT_PRIORITY.STATUS_AND_FACE,
	})

	if target_tiles.size() < total_tiles:
		var fallback_tiles = get_tiles({
			amount = total_tiles - target_tiles.size(),
			effect_priority = EFFECT_PRIORITY.STATUS_AND_FACE,
			exclude_tiles = target_tiles,
		})
		target_tiles += fallback_tiles

	if target_tiles.is_empty():
		_end_use()
		return

	var available_suits = Letters.SUITS.duplicate()
	rng.spell.shuffle(available_suits)

	AudioManager.play_sound(Sounds.SPELLS.DICE_ROLL_3)

	var tile_index: = 0
	for group_size in hand.groups:
		if tile_index >= target_tiles.size():
			break

		var suit = available_suits.pop_front()
		var status = rng.spell.pick_random(STATUS_POOL)

		for i in group_size:
			if tile_index >= target_tiles.size():
				break

			var tile = target_tiles[tile_index]
			tile_index += 1

			tile.set_face(suit)
			tile.add_status(status)
			tile.add_poofcloud(tile.get_color())

			await Game.timeout(0.08)

	_post_use()
