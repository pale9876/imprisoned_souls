@tool
extends Node2D
class_name PoseModule


signal pose_changed()


const NOTIFICATION_POSE_CHANGED: int = 1600
const NOTIFICATION_POSE_ORDER_CHANGED: int = 1601


@export var agent: Node
var pose: Pose

@export var list: Dictionary[StringName, Pose] = {}
@export var init_data: Dictionary


func _enter_tree() -> void:
	pass


func _process(_delta: float) -> void:
	pass


func _physics_process(_delta: float) -> void:
	pass


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENTER_TREE:
			if !list.is_empty():
				if !change_pose(&"Idle", {}, init_data):
					var init_pose: Pose = list.values()[0]
					change_pose(init_pose.name, {}, init_data)

		NOTIFICATION_PROCESS:
			if Engine.is_editor_hint(): return
			var delta: float = get_process_delta_time()
			pose._update(delta)

		NOTIFICATION_PHYSICS_PROCESS:
			if Engine.is_editor_hint(): return
			var delta: float = get_physics_process_delta_time()
			pose._tick(delta)

		NOTIFICATION_POSE_CHANGED:
			pose_changed.emit()

		NOTIFICATION_EXIT_TREE:
			pass

		NOTIFICATION_POSE_ORDER_CHANGED:
			var _arr: Array[Pose] = list.values()
			list = {}
			
			for _pose: Pose in _arr:
				list[_pose.name] = _pose


func add_pose(_pose: Pose) -> bool:
	if list.has(_pose.name):
		printerr(self, " => 해당 포즈는 이미 존재합니다.")
		return false
	
	list[_pose.name] = _pose
	notification(NOTIFICATION_POSE_ORDER_CHANGED)
	return true


func remove_pose(_pose: Pose) -> bool:
	if !list.has(_pose.name):
		printerr(self, " => 해당 포즈는 존재하지 않습니다.")
		return false
	
	list.erase(_pose)
	notification(NOTIFICATION_POSE_ORDER_CHANGED)
	return true


func pose_set_disabled(pose_name: StringName, toggle: bool) -> bool:
	if !list.has(pose_name): return false
	
	list[pose_name].disabled = toggle
	return true


func change_pose(pose_name: StringName, x_data: Dictionary = {}, e_data: Dictionary = {}) -> bool:
	if !list.has(pose_name): return false
	
	# CURRENT POSE EXIT
	var prev: Pose = pose
	if prev:
		prev.data = x_data
		prev.notification(Pose.NOTIFICATION_POSE_EXITED)
	
	# CURRENT POSE ENTER
	pose = list[pose_name]
	pose.data = e_data
	pose.notification(Pose.NOTIFICATION_POSE_ENTERED)
	
	notification(NOTIFICATION_POSE_CHANGED)
	
	return true
