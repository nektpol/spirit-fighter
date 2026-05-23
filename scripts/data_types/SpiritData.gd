extends Resource
class_name SpiritData

@export var id: String
@export var spirit_name: String
@export var spirit_class: SpiritType.Class

@export var element: ElementType.Type

@export var max_hp: int = 100
@export var attack: int = 10
@export var defense: int = 5
@export var speed: int = 5

@export var abilities: Array[Resource] = []

@export var icon: Texture2D
@export var portrait: Texture2D
