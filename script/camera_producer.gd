extends Node2D
class_name CameraProducer


@export var init_camera: Camera2D


var _current: Camera2D


func _enter_tree() -> void:
	_current = init_camera


func _change_camera(_next: Camera2D) -> void:
	pass


func add_camera(cam: Camera2D) -> void:
	pass
