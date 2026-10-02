extends Spell


const SPIN_SPEED: = 1440.0
const SPIN_DURATION: = 0.5


const ROTATED_LETTERS = { # taken straight out of Letters.gd
	"z": {90: "n", 270: "n"},
	"d": {180: "p"},
	"p": {180: "q"},
	"b": {180: "q"},
	"q": {180: "b"},
	"m": {180: "w", 270: "e"},
	"w": {90: "e", 180: "m"},
	"n": {180: "u", 270: "c"},
	"u": {180: "n", 90: "c"},
	"c": {90: "n", 270: "u"},
}


const ROTATED_CAPITAL_LETTERS = {
	"h": {90: "i"},
	"i": {90: "h"},
	"n": {90: "z", 270: "z"},
	"z": {90: "n", 270: "n"},
}


func _use():
	var target_tiles = get_tiles({
		amount = 1,
		effect_priority = EFFECT_PRIORITY.STATUS_AND_FACE,
	})

	if target_tiles.is_empty():
		_end_use()
		return

	var tile: Tile = target_tiles[0]

	if not tile.has_face():
		_end_use()
		return

	AudioManager.play_sound(Sounds.SPELLS.SWITCH)

	var degrees = rng.spell.pick_random([90, 180, 270])

	await spin_tile(tile, degrees)

	tile.add_poofcloud(tile.get_color())
	tile.set_face(rotate_face(tile.face, degrees))

	_post_use()


func spin_tile(tile: Tile, degrees: float) -> void:
	var start_rotation := tile.rotation_degrees
	var elapsed := 0.0

	while elapsed < SPIN_DURATION:
		var step := 1.0 / 60.0
		elapsed += step

		var progress: = minf(elapsed / SPIN_DURATION, 1.0)
		var eased_progress: = 1.0 - pow(1.0 - progress, 2.0)

		tile.rotation_degrees = start_rotation + degrees * eased_progress

		await Game.timeout(step)



func rotate_face(face: String, degrees: int) -> String:
	var new_face := ""

	for character in face:
		if character in ROTATED_CAPITAL_LETTERS:
			var rotations: Dictionary = ROTATED_CAPITAL_LETTERS[character]

			if degrees in rotations:
				new_face += rotations[degrees]
			else:
				new_face += character

		elif character in ROTATED_LETTERS:
			var rotations: Dictionary = ROTATED_LETTERS[character]

			if degrees in rotations:
				new_face += rotations[degrees]
			else:
				new_face += character

		else:
			new_face += character

	return new_face