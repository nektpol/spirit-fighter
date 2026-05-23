class_name BattleUnit
extends RefCounted

var data: SpiritData
var current_hp: int
var cooldowns: Dictionary = {}
var status_effects: Array = []


func initialize(spirit_data: SpiritData) -> void:
	data = spirit_data
	current_hp = data.max_hp
	cooldowns.clear()
	for ability in data.abilities:
		cooldowns[ability] = 0

func is_alive() -> bool:
	return current_hp > 0

func take_damage(amount: int) -> void:
	current_hp -= amount
	current_hp = max(current_hp, 0)
	if current_hp == 0:
		die()

func heal(amount: int) -> void:
	current_hp += amount
	current_hp = min(current_hp, data.max_hp)

func die() -> void:
	print(data.spirit_name, " has been defeated.")

func can_use_ability(ability: AbilityData) -> bool:
	if not cooldowns.has(ability):
		return false
	return cooldowns[ability] <= 0

func use_ability(ability: AbilityData, target: BattleUnit) -> void:
	if not can_use_ability(ability):
		return
	cooldowns[ability] = ability.cooldown
	var damage = ability.power + data.attack
	target.take_damage(damage)
	print(data.spirit_name, " used ", ability.ability_name, " -> ", damage)


func tick_cooldowns() -> void:
	for ability in cooldowns.keys():
		if cooldowns[ability] > 0:
			cooldowns[ability] -= 1
