@tool
extends Node2D
class_name Pose2D


var agent: Node = null

@export var hurtbox_shape: StringName
@export var animation: Node
@export var init_anim: String


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENTER_TREE:
			var parent: Node = get_parent()
			if !Engine.is_editor_hint():
				assert(parent != null, "해당 포즈의 포즈 컨트롤러가 존재하지 않습니다.")
				assert(parent is PoseController2D, "부모노드가 PoseController2D가 아닙니다. ")
		NOTIFICATION_READY:
			if animation != null:
				if animation is AnimationPlayer:
					animation.animation_finished.connect(_animation_finished_ev_handler)
		NOTIFICATION_VISIBILITY_CHANGED:
			_visible_changed()
		NOTIFICATION_PATH_RENAMED:
			_renamed()


func _renamed() -> void:
	hurtbox_shape = get_name()
	var parent: Node = get_parent()
	if parent is PoseController2D:
		parent._updated()
	visible = false


func _visible_changed() -> void:
	for node: Node in get_children():
		node.visible = visible
		
	if Engine.is_editor_hint():
		var parent: Node = get_parent()
		
		if parent != null:
			if parent is PoseController2D:
				if parent.visible and visible:
					if parent.init_pose != self:
						parent._pose_visible_changed_update(self)


# OVERRIDE
func _enter(data: Dictionary = {}) -> void:
	pass


# OVERRIDE
func _update(_delta: float) -> void:
	pass


# OVERRIDE
func _fixed_update(_delta: float) -> void:
	pass


# OVERRIDE
func _exit() -> void:
	pass


func get_controller() -> PoseController2D: return get_parent() as PoseController2D


func get_agent_input_direction() -> Vector2:
	var _controller: PoseController2D = get_controller()
	
	if agent is PhysicsUnit2D:
		if InputHandler.player == agent:
			return InputHandler.get_input_dir()
		else:
			if _controller != null:
				var blackboard: Blackboard = _controller.get_blackboard()
				if blackboard != null:
					if blackboard.has_var("direction"):
						return blackboard.get_var("direction", Vector2())
	
	return Vector2()


func get_agent_information() -> UnitInformation:
	return agent.get_information() if agent is PhysicsUnit2D else null


# OVERRIDE
func hurt_ev_handler() -> void:
	pass


#OVERRIDE
func _animation_finished_ev_handler(anim_name: StringName) -> void:
	pass



func change_pose(pose: Pose2D, data: Dictionary = {}) -> void:
	var result: bool = get_controller().change_pose(pose, data)
	
	if !result:
		printerr(agent.name, ":: Cannot Changed to target Pose => ", pose.name)
