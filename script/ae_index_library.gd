# ae_index_library.gd
extends Node
class_name AEIndexLibrary


@export_category("추가 스탯")
@export var atk: int
@export var atk_ratio: float
@export var def: int
@export var def_ratio: float
@export var speed: float
@export var speed_ratio: float


@export_category("추가 할당 비율 스탯")
@export var additional_damage_ratio: float


func add_index() -> void:
	pass


func get_ae(index_name: String) -> AEIndex:
	var index := get_node(NodePath(index_name)) as AEIndex
	return index


# call deferred
func clear() -> void:
	for node: Node in get_children():
		node.queue_free()


	
