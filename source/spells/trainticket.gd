extends Spell


func _use():
	var queued_tiles = tile_board.get_preview_tiles()

	if queued_tiles.is_empty():
		_end_use()
		return

	var copied_tile = await get_selection()

	if copied_tile == null:
		_end_use()
		return

	var copied_face: String = copied_tile.tile_face.get_face_text(false, false)
	copied_tile.animation.play("pressed")

	var queued_tile = rng.spell.pick_random(queued_tiles)
	queued_tile.faces = [copied_face]
	tile_board.update_previews()

	AudioManager.play_sound(Sounds.SPELLS.STAMP_BIG)

	_post_use()


func is_tile_selectable(tile: Tile) -> bool:
	return (
		tile.has_face()
		and tile.faces.size() == 1
		and not tile.has_any_effect(Globals.FULL_WILDCARD_EFFECTS + [TileStatus.MYSTERY])
	)
