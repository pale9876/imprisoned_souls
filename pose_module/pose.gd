@tool
extends Resource
class_name Pose


var module: PoseModule = null


func init(_module: PoseModule) -> void:
	module = _module


func change_pose(pose_name: String) -> bool:
	if !module.has_pose(pose_name):
		return false
	
	module.change_pose(pose_name)
	return true


func condition() -> bool:
	return true


# OVERRIDE
func enter(_data: Dictionary[String, Variant] = {}) -> void:
	pass


# OVERRIDE:: 매 렌더링 타임마다 실행되는 함수
func update(_delta: float) -> void:
	pass


# OVERRIDE:: 매 물리 틱마다 실행되는 함수
func tick(_delta: float) -> void:
	pass


# OVERRIDE
func exit(_data: Dictionary[String, Variant] = {}) -> void:
	pass
