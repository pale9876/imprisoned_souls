@tool
extends Resource
class_name Pose


var agent: Node = null
var owner: PoseModule = null


@export var name: StringName = &"Pose"
@export var disabled: bool = false
@export var data: Dictionary[String, Variant] = {}


# OVERRIDE
func _enter(_data: Dictionary = {}) -> void:
	pass


# OVERRIDE:: 매 렌더링 타임마다 실행되는 함수
func _update(_delta: float) -> void:
	pass


# OVERRIDE:: 매 물리 틱마다 실행되는 함수
func _tick(_delta: float) -> void:
	pass


# OVERRIDE
func _exit(_data: Dictionary = {}) -> void:
	pass
