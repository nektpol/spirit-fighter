extends Node
class_name BattleController

var state: BattleState.State = BattleState.State.MATCH_START

var player_character: CharacterRuntime
var enemy_character: CharacterRuntime

var player_spirits: Array[BattleUnit] = []
var enemy_spirits: Array[BattleUnit] = []

var player_selected_target: BattleUnit = null
var enemy_selected_target: BattleUnit = null

var round_winner: String = ""
var player_round_wins: int = 0
var enemy_round_wins: int = 0

func start_match(p_char: CharacterRuntime, e_char: CharacterRuntime, p_spirits: Array[BattleUnit], e_spirits: Array[BattleUnit]) -> void:
	player_character = p_char
	enemy_character = e_char
	player_spirits = p_spirits
	enemy_spirits = e_spirits
	state = BattleState.State.ROUND_START
	next_state()
	
func next_state() -> void:
	match state:
		BattleState.State.ROUND_START:
			start_round()
		BattleState.State.TURN_START:
			start_turn()
		BattleState.State.CHARACTER_PHASE:
			character_phase()
		BattleState.State.SPIRIT_PHASE:
			spirit_phase()
		BattleState.State.RESOLVE_PHASE:
			resolve_phase()
		BattleState.State.CHECK_ROUND_END:
			check_round_end()
		BattleState.State.TURN_END:
			end_turn()
		BattleState.State.ROUND_END:
			end_round()
		BattleState.State.MATCH_END:
			print("Match finished")
			
func start_round() -> void:
	print("ROUND START")
	reset_spirits()
	state = BattleState.State.TURN_START
	next_state()
	
func start_turn() -> void:
	print("TURN START")
	player_selected_target = null
	enemy_selected_target = null
	state = BattleState.State.CHARACTER_PHASE
	next_state()
	
func character_phase() -> void:
	print("CHARACTER PHASE")
	# WAIT FOR INPUT IN REAL GAME
	# For now assume already chosen action:
	player_character.start_new_turn()
	state = BattleState.State.SPIRIT_PHASE
	next_state()
	
func spirit_phase() -> void:
	print("SPIRIT PHASE")
	var attacker = player_character.connected_spirit
	var defender_target = resolve_target(enemy_spirits, enemy_selected_target)
	if attacker != null and defender_target != null:
		var ability = attacker.data.abilities[0]
		attacker.use_ability(ability, defender_target)
	state = BattleState.State.RESOLVE_PHASE
	next_state()
	
func resolve_target(team: Array[BattleUnit], selected: BattleUnit) -> BattleUnit:
	if selected != null and selected.is_alive():
		return selected
	var highest_def: BattleUnit = null
	var highest_value := -999
	for unit in team:
		if not unit.is_alive():
			continue
		if unit.data.defense > highest_value:
			highest_value = unit.data.defense
			highest_def = unit
	return highest_def
	
func resolve_phase() -> void:
	print("RESOLVE PHASE")
	for unit in player_spirits:
		unit.tick_cooldowns()
	for unit in enemy_spirits:
		unit.tick_cooldowns()
	state = BattleState.State.CHECK_ROUND_END
	next_state()
	
func check_round_end() -> void:
	if is_team_dead(enemy_spirits):
		player_round_wins += 1
		end_round()
		return
	if is_team_dead(player_spirits):
		enemy_round_wins += 1
		end_round()
		return
	state = BattleState.State.TURN_END
	next_state()
	
func is_team_dead(team: Array[BattleUnit]) -> bool:
	for unit in team:
		if unit.is_alive():
			return false
	return true
	
func end_turn() -> void:
	print("TURN END")
	state = BattleState.State.TURN_START
	next_state()
	
func end_round() -> void:
	print("ROUND END")
	if player_round_wins >= 2:
		state = BattleState.State.MATCH_END
		print("PLAYER WINS MATCH")
		return
	if enemy_round_wins >= 2:
		state = BattleState.State.MATCH_END
		print("ENEMY WINS MATCH")
		return
	state = BattleState.State.ROUND_START
	next_state()
	
func reset_spirits() -> void:
	for unit in player_spirits:
		unit.current_hp = unit.data.max_hp
	for unit in enemy_spirits:
		unit.current_hp = unit.data.max_hp
