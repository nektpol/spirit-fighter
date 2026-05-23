extends Resource
class_name CharacterData

@export var character_name: String

# resource system
@export var max_mana: int = 100
@export var mana_regen_per_turn: int = 10

# optional future systems
@export var defense_modifier: float = 1.0
@export var spirit_sync_bonus: float = 1.0
