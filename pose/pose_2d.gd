@tool
extends Node2D
class_name Pose2D


var agent: Node = null


@export var hurtbox: Hurtbox2D
@export var animation: Node
@export var init_anim: String = ""


func _ready() -> void:
	if hurtbox != null:
		hurtbox.area_shape_entered.connect(_hitbox_entered_ev_handler)
		hurtbox.area_shape_exited.connect(_hitbox_exited_ev_handler)

	if animation != null:
		if animation is AnimationPlayer:
			animation.animation_finished.connect(_animation_finished_ev_handler)


func _notification(what: int) -> void:
	if what == NOTIFICATION_VISIBILITY_CHANGED:
		_visible_changed()
	elif what == NOTIFICATION_PATH_RENAMED:
		_renamed()


func _renamed() -> void:
	var parent: Node = get_parent()
	if parent is PoseController2D:
		parent._updated()


func _visible_changed() -> void:
	for node: Node in get_children():
		node.visible = visible


func _enter_tree() -> void:
	var parent: Node = get_parent()
	
	if parent == null:
		printerr("포즈는 반드시 포즈컨트롤러의 자식으로 있어야 합니다.")
		process_mode = Node.PROCESS_MODE_DISABLED
		return
	
	if parent is not PoseController2D:
		printerr("포즈는 반드시 포즈컨트롤러의 자식으로 있어야 합니다.")
		process_mode = Node.PROCESS_MODE_DISABLED
		pass


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


func get_controller() -> PoseController2D:
	return get_parent() as PoseController2D


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
func _hitbox_entered_ev_handler(area_rid: RID, area: Area2D, area_shape_idx: int, local_shape_idx: int) -> void:
	pass


#OVERRIDE
func _hitbox_exited_ev_handler(area_rid: RID, area: Area2D, area_shape_idx: int, local_shape_idx: int) -> void:
	pass


#OVERRIDE
func _animation_finished_ev_handler(anim_name: StringName) -> void:
	pass



func change_pose(pose: Pose2D, data: Dictionary = {}) -> void:
	var result: bool = get_controller().change_pose(pose)
	
	if !result:
		printerr(agent.name, ":: Cannot Changed to target Pose => ", pose.name)
