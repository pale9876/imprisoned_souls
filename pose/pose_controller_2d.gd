@tool
extends Node2D
class_name PoseController2D


signal pose_changed(pose_name: StringName)
#signal init_pose_changed(pose_name: StringName)


@export var agent: Node
#@export var blackboard_plan: BlackboardPlan = BlackboardPlan.new()
#var _blackboard: Blackboard = null

@export var _poses: Dictionary[StringName, Pose2D]
@export var init_pose: Pose2D = null:
	set(_pose):
		init_pose = _pose
		for p: Pose2D in get_poses():
			p.visible = (p == _pose)


@export_category("DEBUG")
@export var debug: bool = false
@export var monitor_label: Label


var _current: Pose2D = null


func _ready() -> void:
	if Engine.is_editor_hint(): return
	
	_updated()
	
	if init_pose != null:
		assert(
			pose_is_child(init_pose) and change_pose(init_pose)
			)

	#if blackboard_plan:
		#_blackboard = blackboard_plan.create_blackboard(self)

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


func _editor_pose_visibility_changed() -> void:
	pass


func _notification(what: int) -> void:
	match what:
		#NOTIFICATION_PARENTED:
			#var parent: Node = get_parent()
			#if parent is Character:
				#agent = parent

		NOTIFICATION_CHILD_ORDER_CHANGED:
			_updated()

		NOTIFICATION_ENTER_TREE:
			pass
			
		NOTIFICATION_READY:
			pass


func _updated() -> void:
	_poses.clear()
	for node: Node in get_children():
		if node is Pose2D:
			_poses[node.name] = node
			node.agent = agent


#func _visibility_changed_ev_handler() -> void:
	#for node: Node in get_children():
		#if node is Node2D:
			#node.visible = (_current == node and self.visible)


#func _pose_visible_changed_update(p: Pose2D) -> void:
	#change_init_pose(p)


func remove_pose(_pose: Pose2D) -> bool:
	if !_poses.has(_pose.name): return false
	
	_poses.erase(_pose.name)
	return true


func add_pose(_pose: Pose2D) -> bool:
	if _poses.has(_pose.name):
		return false
	
	_poses[_pose.name] = _pose
	_pose.agent = agent
	return true


func get_current_pose() -> Pose2D: return _current


func get_poses() -> Array[Pose2D]: return _poses.values()


func get_list() -> PackedStringArray:
	var list: Array = _poses.keys()
	var result: PackedStringArray = []
	
	for n: StringName in list:
		result.push_back(String(n))
	
	return result


func has_pose(pose_name: StringName) -> bool: return _poses.has(pose_name)


func change_pose_from_name(pose_name: StringName, _data: Dictionary = {}) -> bool:
	if !has_pose(pose_name): return false
	
	var prev_pose: Pose2D = get_current_pose()
	var next_pose: Pose2D = _poses[pose_name]
	
	if prev_pose != null:
		prev_pose._exit()
	
	for _pose: Pose2D in get_poses():
		if next_pose == _pose:
			_current = next_pose
			_pose._enter(_data)
	
	assert(_current != null)
	pose_changed.emit()
	return true


func change_pose(_pose: Pose2D, _data: Dictionary = {}) -> bool:
	if !get_children().has(_pose): return false
	
	var prev_pose: Pose2D = get_current_pose()
	
	if prev_pose != null:
		prev_pose._exit()
		prev_pose.visible = false

	if !Engine.is_editor_hint():
		_current = _pose
		_pose._enter(_data)
		pose_changed.emit(_current.name)
	
	_pose.visible = true
	
	return true


func pose_visibility_changed() -> void:
	pass


func change_init_pose(_pose: Pose2D) -> bool:
	if !has_pose(_pose.name): return false
	
	if init_pose:
		init_pose.visible = false
		init_pose = null

	init_pose = _pose
	
	#if agent is Character:
		#if _pose.
		#if _hurtbox and !_pose_hurtbox.is_empty():
			#var _pose_hurtbox: StringName = _pose.hurtbox_shape
			#var _hurtbox: Hurtbox2D = agent.hurtbox
			#var err: bool = _hurtbox.change_shape(_pose_hurtbox)
			#if !err:
				#printerr("Error :: 해당 포즈의 피격박스가 존재하지 않습니다.")
	
	return true


func pose_is_child(node: Pose2D) -> bool:
	return get_children().filter(
		func(_node: Node) -> bool: return _node is Pose2D
	).has(node)


#func get_blackboard() -> Blackboard: return _blackboard


func get_current_animation() -> StringName:
	var current_pose: Pose2D = get_current_pose()
	if current_pose.animation:
		var anim: Node = current_pose.animation
		if anim is AnimatedSprite2D:
			return anim.animation
		elif anim is AnimationPlayer:
			return anim.current_animation
	
	return &""
