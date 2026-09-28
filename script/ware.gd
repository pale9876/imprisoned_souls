extends Node
class_name Ware


var stat: AEIndexStatInformation = AEIndexStatInformation.new()


func _ready() -> void:
	pass


# Override
func execute_conflict(cargo: ActionResult) -> void:
	pass


func get_replicator() -> Replicator:
	return get_parent() as Replicator
