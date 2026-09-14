extends TileModifierSpell


func set_status_tooltips():
	status_tooltips = [TileEffect.WILDCARD]


func apply_to_tile(tile: Tile, _real_tile: Tile, is_preview: bool, _is_preview_update: bool) -> void :
	tile.set_face("*".repeat(max_charge))

	if not is_preview:
		AudioManager.play_sound(Sounds.SPELLS.GUNSHOT)
		tile.add_poofcloud(tile.get_color())


func is_tile_selectable(tile: Tile) -> bool:
	return (
		tile.is_face_modifiable()
		and not tile.has_harmful_status()
		and not tile.only_face_is("*".repeat(max_charge))
	)