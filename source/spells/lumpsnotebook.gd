extends Spell


enum Category {
	COLORS,
	FRUITS_AND_VEGETABLES,
	ANIMALS,
	METALS,
	BODY_PARTS,
}

const CATEGORY_FRAMES = {
	Globals.WORD_CATEGORIES.COLORS: Category.COLORS,
	Globals.WORD_CATEGORIES.FRUITS_AND_VEGETABLES: Category.FRUITS_AND_VEGETABLES,
	Globals.WORD_CATEGORIES.ANIMALS: Category.ANIMALS,
	Globals.WORD_CATEGORIES.METALS: Category.METALS,
	Globals.WORD_CATEGORIES.BODY_PARTS: Category.BODY_PARTS,
}

var category_queue: Array[String] = []
var is_enhancing_word: = false


func _ready():
	super._ready()

	word_builder.post_tile_stats.connect(_on_word_builder_post_tile_stats)


func player_turn_started(is_battle_start: bool) -> void :
	super.player_turn_started(is_battle_start)
	if is_owned():
		reroll_category()


func reroll_category():
	var last_category := ""

	if not category_queue.is_empty():
		last_category = category_queue[0]

	category_queue = Globals.WORD_CATEGORIES.values()
	rng.spell.shuffle(category_queue)

	if category_queue.size() > 1 and category_queue[0] == last_category:
		category_queue.remove_at(0)
		category_queue.append(last_category)

	frame_updated.emit()
	description_updated.emit()


func get_current_category() -> String:
	if category_queue.is_empty():
		reroll_category()

	return category_queue[0]


func get_hv_frames() -> Vector2i:
	return Vector2i(5, 1)


func get_frame() -> int:
	return CATEGORY_FRAMES[get_current_category()]


func get_tooltip_context() -> Dictionary:
	return {category_number = str(get_frame())}


func has_valid_category_word() -> bool:
	var words: WordList = word_builder.get_words()

	if not word_builder.can_submit_tiles():
		return false

	if not word_builder.can_submit_words(words):
		return false

	return WordUtility.word_list_has_flag(
		words,
		Globals.WORD_CATEGORY_FLAGS[get_current_category()]
	)


func _use():
	if not has_valid_category_word():
		_end_use()
		return

	Game.stop_turn_timers.emit()

	Game.screenshake(2, 0.16)

	is_enhancing_word = true
	word_builder.update()

	AudioManager.play_sound(Sounds.UI.FORWARD_PAPER)

	await Game.timeout(0.5)
	main.force_end_player_turn(true)
	is_enhancing_word = false

	_post_use()


func is_usable():
	return super.is_usable() and has_valid_category_word()


func _on_word_builder_post_tile_stats(_words):
	if is_enhancing_word:
		word_builder.damage_multiplier += 0.5
		word_builder.defense_multiplier += 0.5
