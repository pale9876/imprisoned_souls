@tool
extends Pose
class_name DashPose


@export var motion: Vector2 = Vector2()
@export var motion_curve: Curve = Curve.new()
@export var duration: float = .75


func enter(_data: Dictionary[String, Variant] = {}) -> void:
	if _data.has("force"):
		motion = _data["force"] as Vector2


func tick(_delta: float) -> void:
	pass


func exit(_data: Dictionary[String, Variant] = {}) -> void:
	pass


#func dashing(motion: Vector2, delta: float) -> void:
	#var motion_param: PhysicsTestMotionParameters2D = PhysicsTestMotionParameters2D.new()
	#var motion_result: PhysicsTestMotionResult2D = PhysicsTestMotionResult2D.new()
	#motion_param.from = get_global_transform()
	#motion_param.motion = motion
	#
	#if !PhysicsServer2D.body_test_motion(body.rid, motion_param, motion_result):
		#global_position += motion
	#else:
		#var shape_param: PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()
		#shape_param.transform = get_global_transform()
		#shape_param.motion = motion
		#shape_param.shape_rid = body.shape
		#shape_param.exclude = [body.rid]
	#
		#var rest_info: Dictionary = get_world_2d().direct_space_state.get_rest_info(shape_param)
		#var normal: Vector2 = rest_info["normal"]
		#var remainder: Vector2 = motion_result.get_remainder()
		#
		#global_position += motion * (motion_result.get_collision_safe_fraction() - .01)
		#
		#var remainder_param: PhysicsTestMotionParameters2D = PhysicsTestMotionParameters2D.new()
		#var remainder_result: PhysicsTestMotionResult2D = PhysicsTestMotionResult2D.new()
		#remainder_param.from = get_global_transform()
		#remainder_param.motion = remainder.slide(normal)
		#
		#if !PhysicsServer2D.body_test_motion(body.rid, remainder_param, remainder_result):
			#global_position += remainder.slide(normal)
		#else:
			#global_position += remainder.slide(normal) * (remainder_result.get_collision_safe_fraction() - .01)
