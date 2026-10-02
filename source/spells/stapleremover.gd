extends Spell


func _use():
	var selected_tile = await get_selection()

	if selected_tile == null:
		_end_use()
		return

	var letters: String = selected_tile.face
	var coord: Vector2i = selected_tile.get_coord()

	if letters.length() < 2:
		selected_tile.animation.play("shake")
		_end_use()
		return

	var original_statuses = selected_tile.statuses.duplicate()

	var target_tiles: Array[Tile] = []
	var target_letters: Array[String] = []

	for i in letters.length():
		var distance: int = (i / 3) + 1
		var target_coord: Vector2i

		match i % 3:
			0:
				target_coord = coord + Vector2i(-distance, 0)

			1:
				target_coord = coord + Vector2i(0, -distance)

			2:
				target_coord = coord + Vector2i(distance, 0)

		if (
			target_coord.x < 0
			or target_coord.x >= tile_board.num_columns
			or target_coord.y < 0
			or target_coord.y >= tile_board.num_rows
		):
			continue

		var tiles = get_tiles({
			rows = [target_coord.y],
			columns = [target_coord.x],
			sorted = true,
		})

		if tiles.is_empty():
			continue

		var target_tile: Tile = tiles[0]

		if not target_tile.has_face():
			continue

		target_tiles.append(target_tile)
		target_letters.append(letters[i])


	if target_tiles.is_empty():
		selected_tile.animation.play("shake")
		_end_use()
		return

	AudioManager.play_sound(Sounds.SPELLS.STAMP_BIG)

	selected_tile.add_poofcloud(
		Globals.COLORS.SMOKE,
		Globals.COLORS.BLEND_SMOKE
	)

	tile_board.remove_tile(selected_tile, {
		delete_tiles = false,
		settle = false,
		restock = false,
	})

	var bounce_offset: float = randf_range(32.0, 72.0)
	var direction_sign: int = -1 if randi_range(0, 1) == 0 else 1

	var dest = Vector2(
		selected_tile.global_position.x + bounce_offset * direction_sign,
		290
	)

	var projectile = selected_tile.launch(
		selected_tile.global_position,
		dest,
		32,
		Vector2i.MIN,
		1200,
		true,
		false,
		false
	)

	projectile.look_at_direction = false
	projectile.angular_velocity = PI * 10
	projectile.angular_deceleration = PI * 18
	projectile.decelerate_to = PI * 2

	for i in target_tiles.size():
		var tile: Tile = target_tiles[i]
		var letter: String = target_letters[i]

		tile.set_face(letter)

		for status in original_statuses:
			tile.add_status(status)

		tile.add_poofcloud(tile.get_color())

		await Game.timeout(0.08)

	await tile_board.settle_board()
	await tile_board.fill_board()

	_post_use()


func is_tile_selectable(tile: Tile) -> bool:
	return (
		tile.has_face()
		and tile.faces.size() == 1
		and tile.face.length() > 1
		and not tile.has_effect(TileEffect.SLASHED)
		and not tile.has_harmful_status()
	)