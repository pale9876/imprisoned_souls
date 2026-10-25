@tool
extends Node
class_name Ware


const MAX_ACCESSORY_COUNT: int = 2


var stat: AEIndexStatInformation


func _init() -> void:
	if Engine.is_editor_hint(): return
	
	stat = AEIndexStatInformation.new()


func gear_get_type(gear: Gear) -> GlobalClassified.GearType:
	return gear.type


func has_gear(_name: NodePath) -> bool:
	return has_node(_name)


#func gear_up(gear: Gear) -> void:
	#set_gear(gear)


# Override
func execute_conflict(cargo: ActionResult) -> void:
	pass


func get_replicator() -> Replicator:
	return get_parent() as Replicator
