extends Node2D
class_name AEIndex


signal updated()


var stat: AEIndexStatInformation = AEIndexStatInformation.new()


func _enter_tree() -> void:
	updated.connect(get_lib().update_total_stat)


# Override
func activate() -> void:
	pass


# Override
func deactivate() -> void:
	pass


# Override
func _update() -> void:
	pass


# Override
func enable(_act_result: ActionResult = null) -> bool:
	return false


func clear() -> void:
	stat = AEIndexStatInformation.new()


func get_lib() -> AEIndexLibrary:
	return get_parent() as AEIndexLibrary


func get_unit() -> Replicator:
	return get_lib().get_parent() as Replicator
