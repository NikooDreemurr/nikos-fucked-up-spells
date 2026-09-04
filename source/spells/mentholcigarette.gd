extends TileModifierSpell # straight out of cigarette's code


func set_status_tooltips():
	status_tooltips = [TileStatus.FROZEN, "wildcard"]


func apply_to_tile(tile: Tile, _real_tile: Tile, is_preview: bool, _is_preview_update: bool) -> void :
	tile.add_status(TileStatus.FROZEN)
	tile.set_face("*")

	if not is_preview:
		tile.add_poofcloud(Globals.COLORS.ICE)


func is_tile_selectable(tile: Tile) -> bool:
	return not (
		tile.has_harmful_status()
		or not tile.is_face_modifiable()
		or (
			tile.has_status(TileStatus.FROZEN)
			and tile.only_face_is("*")
		)
	)
