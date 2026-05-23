class_name CharacterRuntime
extends RefCounted

var data: CharacterData
var current_mana: int
var connected_spirit: BattleUnit = null
var chosen_action: CharacterAction.Action = CharacterAction.Action.NONE

func initialize(character_data: CharacterData) -> void:
	data = character_data
	current_mana = data.max_mana

func connect_spirit(spirit: BattleUnit) -> void:
	connected_spirit = spirit
	print("Connected to ", spirit.data.spirit_name)

func disconnect_spirit() -> void:
	connected_spirit = null

func gather_mana() -> void:
	current_mana += data.mana_regen_per_turn
	current_mana = min(current_mana, data.max_mana)

func spend_mana(amount: int) -> bool:
	if current_mana < amount:
		return false
	current_mana -= amount
	return true

func start_new_turn() -> void:
	chosen_action = CharacterAction.Action.NONE
