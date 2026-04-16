@tool
extends RefCounted
class_name PoseModule


var owner: int
var cache: Dictionary[String, Pose]
var current: Pose


func has_pose(pose_name: String) -> bool:
	return cache.has(pose_name)


func init_data(info: PoseInformation, _owner: Node = null, enter_data: Dictionary[String, Variant] = {}) -> void:
	cache = info.data
	if _owner: owner = _owner.get_instance_id()

	for pose: Pose in info.data.values():
		pose.init(self)
	
	current = cache[info.init_pose]
	current.enter(enter_data)


func add_pose(pose_name: String, pose: Pose) -> bool:
	if cache.has(pose_name):
		return false
	
	cache[pose_name] = pose
	return true


func change_pose(pose_name: String, _condition: bool = true, enter_data: Dictionary[String, Variant] = {}, exit_data: Dictionary[String, Variant] = {}) -> void:
	if cache.has(pose_name) and cache[pose_name].can_enter(_condition):
		current.exit(exit_data)
		current = cache[pose_name]
		current.enter(enter_data)


func reenter_current_pose(enter_data: Dictionary[String, Variant] = {}, exit_data: Dictionary[String, Variant] = {}) -> void:
	current.exit(exit_data)
	current.enter(enter_data)


func update(delta: float) -> void:
	current.update(delta)


func tick(delta: float) -> void:
	current.tick(delta)


func kill() -> void:
	for pose: Pose in cache.values():
		pose.kill()
	
