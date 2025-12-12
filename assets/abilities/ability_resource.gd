class_name AbilityResource extends Resource

@export var ability_name: String = "Unnamed Ability"
@export_multiline var description: String = ""
@export var icon: Texture2D
@export var cooldown: float = 1.0
@export var mana_cost: int = 0
@export var cast_time: float = 0.0

func execute(_caster: Node, _target: Node = null) -> void:
	pass

func can_cast(_caster: Node) -> bool:
	return true
