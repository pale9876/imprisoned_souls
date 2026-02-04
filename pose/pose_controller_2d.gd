@tool
extends Node2D
class_name PoseController2D


signal pose_changed(state_name: StringName)


@export var agent: Node
@export var blackboard_plan: BlackboardPlan = BlackboardPlan.new()
var _blackboard: Blackboard = null

@export var pose: Dictionary[StringName, Pose2D]
@export var init_pose: Pose2D = null


@export_category("DEBUG")
@export var debug: bool = false
@export var monitor_label: Label


var _current: Pose2D = null


func _ready() -> void:
	if Engine.is_editor_hint(): return
	
	_updated()
	
	if init_pose != null:
		assert( pose_is_child(init_pose) and change_pose(init_pose) )

	if blackboard_plan:
		_blackboard = blackboard_plan.create_blackboard(self)

	pose_changed.connect(_pose_changed)


func _pose_changed(state_name: StringName) -> void:
	var current_pose: String = monitor_label.text
	var next_pose_name: String = String(state_name)
	var unit_name: String = String(agent.name)
	
	if current_pose != next_pose_name:
		monitor_label.text = ("State: " + next_pose_name)
		if !current_pose.is_empty():
			print(
				unit_name, " :: Pose Changed => ", current_pose, " to ", next_pose_name
			)


func _process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	if _current != null:
		_current._update(delta)


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	if _current != null:
		_current._fixed_update(delta)


func _notification(what: int) -> void:
	if what == NOTIFICATION_CHILD_ORDER_CHANGED:
		_updated()
	elif what == NOTIFICATION_VISIBILITY_CHANGED:
		_visibility_changed_ev_handler()


func _updated() -> void:
	pose.clear()
	for node: Node in get_children():
		if node is Pose2D:
			pose[node.name] = node
			node.agent = agent


func _visibility_changed_ev_handler() -> void:
	for node: Node in get_children():
		if node is Node2D:
			node.visible = visible


func remove_pose(_pose: Pose2D) -> bool:
	if !pose.has(_pose.name): return false
	
	pose.erase(_pose.name)
	return true


func add_pose(_pose: Pose2D) -> bool:
	if pose.has(_pose.name):
		return false
	
	pose[_pose.name] = _pose
	_pose.agent = agent
	return true


func get_current_pose() -> Pose2D:
	return _current


func get_poses() -> Array[Pose2D]:
	return pose.values()


func get_list() -> PackedStringArray:
	var list: Array = pose.keys()
	var result: PackedStringArray = []
	
	for n: StringName in list:
		result.push_back(String(n))
	
	return result


func has_pose(pose_name: StringName) -> bool:
	return pose.has(pose_name)


func change_pose_from_name(pose_name: StringName) -> bool:
	if !has_pose(pose_name): return false
	
	var prev_pose: Pose2D = get_current_pose()
	var next_pose: Pose2D = pose[pose_name]
	
	if prev_pose != null:
		prev_pose._exit()
	
	for _pose: Pose2D in get_poses():
		if next_pose == _pose:
			_current = next_pose
			_pose._enter()
	
	assert(_current != null)
	pose_changed.emit()
	return true


func change_pose(_pose: Pose2D, data: Dictionary = {}) -> bool:
	if !get_children().has(_pose):
		return false
	
	var prev_pose: Pose2D = get_current_pose()
	
	if prev_pose != null:
		prev_pose._exit()

	_current = _pose
	if !Engine.is_editor_hint(): _pose._enter()
	
	assert(_current != null)
	
	pose_changed.emit(_current.name)
	return true


func pose_is_child(node: Pose2D) -> bool:
	return get_children().filter(
		func(_node: Node) -> bool: return _node is Pose2D
	).has(node)


func get_blackboard() -> Blackboard: return _blackboard
