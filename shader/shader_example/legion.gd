@tool
extends Node2D
class_name Legion


@export var instance: LegionInstance

var count: int = 100
var arr: Array[I] = []


func _enter_tree() -> void:
	for i: int in range(count):
		pass


func clear() -> void:
	pass


class I extends RefCounted:
	pass
