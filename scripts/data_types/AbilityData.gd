extends Resource
class_name AbilityData

@export var id: String
@export var ability_name: String
@export var description: String

@export var icon: Texture2D

# --- Combat ---
@export var power: int = 10
@export var accuracy: float = 1.0

# optional: elemental scaling later
@export var element: String

# --- Costs ---
@export var mana_cost: int = 5
@export var cooldown: int = 1

# --- Targeting ---
@export var target_type: TargetType.Type = TargetType.Type.ENEMY_SINGLE

# --- Behavior flags ---
@export var is_ultimate: bool = false
