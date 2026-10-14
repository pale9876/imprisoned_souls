extends Node
class_name Ware


@export var head: Gear
@export var body: Gear
@export var leg: Gear
@export var belt: Gear
@export var pants: Gear


var stat: AEIndexStatInformation = AEIndexStatInformation.new()


func _ready() -> void:
	pass


func has_gear(_name: NodePath) -> bool:
	return has_node(_name)


# Override
func execute_conflict(cargo: ActionResult) -> void:
	pass


func get_replicator() -> Replicator:
	return get_parent() as Replicator
