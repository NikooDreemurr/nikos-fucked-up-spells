extends Spell


var danger_chance: int = 0


func _use():
	var selected_tile = await get_selection()

	if selected_tile == null:
		_end_use()
		return

	var chance_increase: int = randi_range(1, 5)
	danger_chance += chance_increase

	AudioManager.play_sound(Sounds.SPELLS.STAMP_BIG)

	selected_tile.remove_face_statuses()
	selected_tile.set_face("ty")
	selected_tile.add_poofcloud(selected_tile.get_color())

	if danger_chance >= 100:
		Game.player.hurt(randi_range(1, 5), Globals.DamageType.PIERCING)

		danger_chance = 0

	elif danger_chance > 50:
		var curse_targets = get_tiles({
			amount = 1,
			effect_priority = EFFECT_PRIORITY.STATUS_AND_FACE,
		})

		if not curse_targets.is_empty():
			var curse_tile: Tile = curse_targets[0]

			curse_tile.add_status(TileStatus.CURSED)
			curse_tile.add_poofcloud(curse_tile.get_color())

	_post_use()


func is_tile_selectable(tile: Tile) -> bool:
	return (
		tile.has_face()
		and not tile.has_harmful_status()
	)