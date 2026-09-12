extends Mod


var SPELLS: Dictionary[String, String] = {
	#REVERSE_EMPEROR = "reverseemperor",
	FIVE_HUNDREDS_CIGARETTES = "500_cigarettes",
	ETHICALLY_SOURCED_HORSE_CUM = "ethically_sourced_horse_cum",
	#KEYPAD = "keypad",
	PUSHPIN = "pushpin",
	PEPPER_SPRAY = "pepperspray",
	WOODEN_RULER = "woodenruler",
	#INTERVENTION = "intervention",
	#THEDUD = "thedud",
	HOLY_BIBLE = "holybible",
	LUMPS_NOTEBOOK = "lumpsnotebook",
	DEALERS_HAND = "dealershand",
	FIRE_AX = "fireax",
	WRISTWATCH = "wristwatch",
	TRAIN_TICKET = "trainticket",
	MENTHOL_CIGARETTE = "mentholcigarette",
	EXIT_SIGN = "exitsign",
	LITHIUM_PALACELL = "lithiumpalacell",
	RECYCLING_BIN = "recyclingbin",
	BUBBLE_GUM = "bubblegum",
	INSTANT_COFFEE = "instantcoffee",
	IPA84 = "ipa84",
	COUNTERFEIT_RATION = "counterfeitration"
}

var SPELL_POOL: Dictionary[String, float] = {
	#SPELLS.REVERSE_EMPEROR: 1.0,
	SPELLS.FIVE_HUNDREDS_CIGARETTES: 0.01,
	SPELLS.ETHICALLY_SOURCED_HORSE_CUM: 0.01,
	#SPELLS.KEYPAD: 1.0,
	SPELLS.PUSHPIN: 1.0,
	SPELLS.WOODEN_RULER: 0.67,
	#SPELLS.INTERVENTION: 1.0,
	#SPELLS.THEDUD: 1.0,
	SPELLS.HOLY_BIBLE: 1.0,
	SPELLS.LUMPS_NOTEBOOK: 1.0,
	SPELLS.PEPPER_SPRAY: 1.0,
	SPELLS.DEALERS_HAND: 1.0,
	SPELLS.FIRE_AX: 1.0,
	SPELLS.WRISTWATCH: 1.0,
	SPELLS.TRAIN_TICKET: 1.0,
	SPELLS.MENTHOL_CIGARETTE: 1.0,
	SPELLS.EXIT_SIGN: 0.1,
	SPELLS.LITHIUM_PALACELL: 1.0,
	SPELLS.RECYCLING_BIN: 1.0,
	SPELLS.BUBBLE_GUM: 1.0,
	#SPELLS.INSTANT_COFFEE: 1.0,
	SPELLS.IPA84: 1.0,
	SPELLS.COUNTERFEIT_RATION: 1.0
}

var SPELL_CATEGORIES: Dictionary[String, Array] = {
	Globals.SPELL_CATEGORY.DEFENSIVE: [
		SPELLS.WRISTWATCH,
		SPELLS.MENTHOL_CIGARETTE,
		SPELLS.BUBBLE_GUM
	],
	Globals.SPELL_CATEGORY.DIRECT_DEFENSE: [
		SPELLS.WRISTWATCH,
		SPELLS.MENTHOL_CIGARETTE,
	],
	Globals.SPELL_CATEGORY.SUPPORT: [
		#SPELLS.REVERSE_EMPEROR,
		SPELLS.FIVE_HUNDREDS_CIGARETTES,
		#SPELLS.KEYPAD,
		SPELLS.WOODEN_RULER,
		#SPELLS.INTERVENTION,
		SPELLS.TRAIN_TICKET,
		SPELLS.EXIT_SIGN,
		SPELLS.LITHIUM_PALACELL,
		SPELLS.RECYCLING_BIN,
		SPELLS.IPA84,
		SPELLS.COUNTERFEIT_RATION
	],
	Globals.SPELL_CATEGORY.OFFENSIVE: [
		SPELLS.ETHICALLY_SOURCED_HORSE_CUM,
		SPELLS.PUSHPIN,
		#SPELLS.INTERVENTION,
		SPELLS.HOLY_BIBLE,
		SPELLS.LUMPS_NOTEBOOK,
		SPELLS.PEPPER_SPRAY,
		SPELLS.DEALERS_HAND,
		SPELLS.FIRE_AX,
		#SPELLS.INSTANT_COFFEE,
	]
}


func _init() -> void:
	print("ping!")


func _post_mods_loaded() -> void:
	print("All loaded")


## Returns a list of spell ids for the game to load into SpellData
## The ids must be namespaced as "modid:spellid" or the game won't like it!
## Convenience functions exist to do so.
func get_spell_ids() -> Array[String]:
	return namespace_ids(SPELLS.values())


## Returns a dictionary {spell_id: weight}
## You are expected to filter appropriately to the requested category!
## The SpellData.get_filtered_spell_pool function makes that convenient, though.
## And again, namespace!
func get_spell_pool(category: String = "") -> Dictionary[String, float]:
	var category_pool: Array = SPELL_CATEGORIES.get(category, [])
	var pool := SpellData.get_filtered_spell_pool(SPELL_POOL, category_pool)
	return namespace_dictionary_ids(pool)
