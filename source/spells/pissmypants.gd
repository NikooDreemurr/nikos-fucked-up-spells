extends Spell


enum {
	FREEZE_ROW,
	FREEZE_COLUMN,
}

var state = FREEZE_ROW
var switch_cooldown = 0


func _ready() -> void :
	_update_state()


func _process(delta):
	update_switch_cooldown(delta)


func _process_select(delta):
	update_switch_cooldown(delta)


func update_switch_cooldown(delta) -> void :
	if switch_cooldown > 0:
		switch_cooldown = max(0, switch_cooldown - 60 * delta)


func _use():
	if state == FREEZE_ROW:
		_use_freeze_row()
	elif state == FREEZE_COLUMN:
		_use_freeze_column()


func get_tooltip_context():
	return {is_column = state == FREEZE_COLUMN}


func get_hv_frames() -> Vector2i:
	return Vector2i(2, 1)


func get_frame() -> int:
	if state == FREEZE_ROW:
		return 0
	else:
		return 1


func _update_state():
	status_tooltips = [TileStatus.FROZEN, TileEffect.SLASHED]

	frame_updated.emit()
	description_updated.emit()


func _use_freeze_row():
	var selected_tile = await get_selection()

	if selected_tile == null:
		_end_use()
		return

	var row = selected_tile.get_coord().y

	var target_tiles = get_tiles({
		rows = [row],
		sorted = true,
	})

	if target_tiles.is_empty():
		selected_tile.animation.play("shake")
		_end_use()
		return

	AudioManager.play_sound(Sounds.FREEZER.VOX_FOREIGN_BODY)

	for tile in target_tiles:
		tile.add_status(TileStatus.FROZEN)
		tile.apply_slashed(rng.spell)
		tile.bounce()
		tile.add_poofcloud(tile.get_color())

		await Game.timeout(0.08)

	_post_use()


func _use_freeze_column():
	var selected_tile = await get_selection()

	if selected_tile == null:
		_end_use()
		return

	var column = selected_tile.get_coord().x

	var target_tiles = get_tiles({
		columns = [column],
		sorted = true,
	})

	if target_tiles.is_empty():
		selected_tile.animation.play("shake")
		_end_use()
		return

	AudioManager.play_sound(Sounds.FREEZER.VOX_FOREIGN_BODY)

	for tile in target_tiles:
		tile.add_status(TileStatus.FROZEN)
		tile.apply_slashed(rng.spell)
		tile.bounce()
		tile.add_poofcloud(tile.get_color())

		await Game.timeout(0.08)

	_post_use()


func on_hover():
	AudioManager.play_sound(Sounds.FREEZER.DRUM)
	AudioManager.play_sound(Sounds.FREEZER.VOX_FREEZER)
	if player.is_using_spell() or switch_cooldown > 0:
		return

	switch_state()


func on_unhover():
	switch_cooldown = max(10, switch_cooldown)


func switch_state():
	switch_cooldown = 20

	if state == FREEZE_ROW:
		state = FREEZE_COLUMN
	elif state == FREEZE_COLUMN:
		state = FREEZE_ROW

	shake.emit()
	_update_state()