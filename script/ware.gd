@tool
extends Node
class_name Ware


@export var head: Gear
@export var body: Gear
@export var leg: Gear
@export var belt: Gear
@export var pants: Gear


var stat: AEIndexStatInformation


func _init() -> void:
	if Engine.is_editor_hint(): return
	
	stat = AEIndexStatInformation.new()


func gear_get_type(gear: Gear) -> Gear.Type:
	return gear.type


func set_gear(gear: Gear) -> void:
	match gear_get_type(gear):
		Gear.Type.HEAD:
			head = gear
		Gear.Type.BODY:
			body = gear
		Gear.Type.BELT:
			belt = gear
		Gear.Type.PANTS:
			pants = gear
		Gear.Type.LEG:
			leg = gear


func has_gear(_name: NodePath) -> bool:
	return has_node(_name)


func gear_up(gear: Gear) -> void:
	
	set_gear(gear)


# Override
func execute_conflict(cargo: ActionResult) -> void:
	pass


func get_replicator() -> Replicator:
	return get_parent() as Replicator
