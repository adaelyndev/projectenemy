class_name AbilityManager extends Node

signal ability_cast(ability: AbilityResource)
signal ability_cooldown_started(ability: AbilityResource, duration: float)
signal ability_failed(ability: AbilityResource, reason: String)

@export var abilities: Array[AbilityResource] = []

@export var player: PlayerController

var cooldowns: Dictionary = {}

func _ready() -> void:
	for ability in abilities:
		cooldowns[ability] = 0.0

func _process(delta: float) -> void:
	for ability in cooldowns:
		if cooldowns[ability] > 0:
			cooldowns[ability] -= delta

func cast_ability(ability_index: int, target: Node = null) -> bool:
	if ability_index < 0 or ability_index > abilities.size():
		return false
	
	var ability = abilities[ability_index]
	return cast_ability_direct(ability, target)

func cast_ability_direct(ability: AbilityResource, target: Node = null) -> bool:
	if not ability:
		return false
	
	if is_on_cooldown(ability):
		ability_failed.emit(ability, "On cooldown")
		return false
	
	if not ability.can_cast(get_parent()):
		ability_failed.emit(ability, "Cannot cast")
		return false
	
	if player.has_method("consume_mana"):
		player.consume_mana(ability.mana_cost)
	
	ability.execute(get_parent(), target)
	
	cooldowns[ability] = ability.cooldown
	ability_cooldown_started.emit(ability, ability.cooldown)
	ability_cast.emit(ability)
	
	return true

func is_on_cooldown(ability: AbilityResource) -> bool:
	return cooldowns.get(ability, 0.0) > 0

func get_cooldown_remaining(ability: AbilityResource) -> float:
	return cooldowns.get(ability, 0.0)

func add_ability(ability: AbilityResource) -> void:
	abilities.append(ability)
	cooldowns[ability] = 0.0

func remove_ability(ability: AbilityResource) -> void:
	abilities.erase(ability)
	cooldowns.erase(ability)
