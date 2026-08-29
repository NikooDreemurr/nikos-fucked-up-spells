extends Spell

const FAGGOT = preload("res://mods/evil_cat/sounds/spells/fivehundredscigar.wav")

func set_status_tooltips():
	status_tooltips = [TileStatus.ASH, "wildcard"]


func _use():
	AudioManager.play_sound(FAGGOT)
	for tile: Tile in tile_board.get_tiles():
		tile.add_status(TileStatus.ASH)
		tile.set_face("*")
		tile.add_poofcloud(Globals.COLORS.ASH)

	for queued_tile in tile_board.get_preview_tiles():
		queued_tile.get_or_add("statuses", []).append(TileStatus.ASH)
		queued_tile.faces = ["*"]

	tile_board.update_previews()

	_post_use()
