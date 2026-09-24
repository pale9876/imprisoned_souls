# ae_index_library.gd
extends Node2D
class_name AEIndexLibrary


signal updated()


var total_stat: AEIndexStatInformation = AEIndexStatInformation.new()


func has_index(node_name: NodePath) -> bool:
	return get_node_or_null(node_name) != null


func add_index(node: AEIndex) -> void:
	if !has_index(NodePath(node.name)):
		add_child(node)


func update_total_stat() -> void:
	var info := AEIndexStatInformation.new()
	
	for node: Node in get_children():
		if node is AEIndex:
			info.atk += node.stat.atk
			info.atk_ratio += node.stat.atk_ratio
			
			info.def += node.stat.def
			info.def_ratio += node.stat.def_ratio
			
			info.speed += node.stat.speed
			info.speed_ratio += node.stat.speed_ratio
	
	total_stat = info
	updated.emit()


func get_speed_stat() -> float:
	return total_stat.speed * total_stat.speed_ratio


func get_ae(index_name: String) -> AEIndex:
	var index := get_node(NodePath(index_name)) as AEIndex
	return index


func remove_index(target: AEIndex) -> void:
	target.queue_free.call_deferred()


# call deferred
func clear() -> void:
	for node: Node in get_children():
		node.queue_free()


	
