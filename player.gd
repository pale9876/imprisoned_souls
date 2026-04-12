@tool
extends EEAD2D
class_name Player


enum Mode
{
	GROUNDED = 0,
	FLOAT = 1
}


const GROUNDED: int = Mode.GROUNDED
const FLOAT: int = Mode.FLOAT


signal player_damaged(value: float)


@export_category("Settings")
@export var mode: Mode = GROUNDED
@export var collider: String = "idle"


@export_category("Resources")
@export var unit_information: UnitInformation = UnitInformation.new()
@export var skills: Dictionary[String, SkillInformation]
@export var hurtbox_information: HurtboxInformation = HurtboxInformation.new()
@export var body_parts: Array[AnimatedPart]

@export_category("Canvas")
@export var texture: Dictionary[String, AtlasTexture]
@export var frame_coord: Vector2i = Vector2i()
@export var animation_player: AnimationPlayer


@export_category("Collision")
@export_flags_2d_physics var mask: int = 1
@export_flags_2d_physics var layer: int = 1


var sep_ray: RID
var face: Vector2 = Vector2.RIGHT
var _body: RID
var _shape: Dictionary[String, RID]
var velocity: Vector2 = Vector2()

var _onwall: bool = false
var _onfloor: bool = false

var _hurtbox: Hurtbox
var s_arr: Array[S]


var cid: RID


func _enter_tree() -> void:
	if !Engine.is_editor_hint():
		create()


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	var input: Vector2 = Input.get_vector("left", "right", "up", "down")
	velocity = velocity.move_toward(input * unit_information.speed, unit_information.acceleration * delta)
	
	move(velocity, delta)


func move(motion: Vector2, delta: float) -> void:
	var motion_param: PhysicsTestMotionParameters2D = PhysicsTestMotionParameters2D.new()
	var motion_result: PhysicsTestMotionResult2D = PhysicsTestMotionResult2D.new()
	
	motion_param.recovery_as_collision = true
	motion_param.exclude_objects = [self.get_instance_id()]
	motion_param.from = get_global_transform()
	motion_param.motion = motion * delta
	
	if motion != Vector2.ZERO:
		if PhysicsServer2D.body_test_motion(_body, motion_param, motion_result):
			var shape_param: PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()
			
			shape_param.collide_with_areas = false
			shape_param.collision_mask = mask
			shape_param.exclude = [_body]
			shape_param.shape_rid = _shape[collider]
			shape_param.transform = get_global_transform()
			shape_param.motion = motion * delta
			shape_param.margin = 1.
			
			if motion_result.get_collision_safe_fraction() > .1:
				global_position += (motion * motion_result.get_collision_safe_fraction() * delta)
			_onwall = true
			
			var remainder: Vector2 = motion_result.get_remainder()
			
			if remainder != Vector2():
				var rest_info: Dictionary = get_world_2d().direct_space_state.get_rest_info(shape_param)
				var normal: Vector2 = rest_info["normal"]
				remainder = remainder.slide(normal)

				var remainder_motion_param: PhysicsTestMotionParameters2D = PhysicsTestMotionParameters2D.new()
				remainder_motion_param.from = Transform2D(0., global_position)
				remainder_motion_param.motion = remainder
				remainder_motion_param.recovery_as_collision = true
				var remainder_motion_result: PhysicsTestMotionResult2D = PhysicsTestMotionResult2D.new()
				
				if PhysicsServer2D.body_test_motion(_body, remainder_motion_param, remainder_motion_result):
					global_position += remainder * (remainder_motion_result.get_collision_safe_fraction())
				else:
					global_position += remainder
				
			print("collide")
		else:
			global_position += motion * delta
			_onwall = false

func _exit_tree() -> void:
	if init:
		kill()


func create() -> void:
	if init:
		kill()
	
	cid = RenderingServer.canvas_item_create()
	RenderingServer.canvas_item_set_transform(cid, Transform2D())
	RenderingServer.canvas_item_set_parent(cid, get_canvas_item())
	
	_body = PhysicsServer2D.body_create()
	PhysicsServer2D.body_set_mode(_body, PhysicsServer2D.BODY_MODE_KINEMATIC)
	PhysicsServer2D.body_set_state(_body, PhysicsServer2D.BODY_STATE_TRANSFORM, get_global_transform())
	PhysicsServer2D.body_set_space(_body, get_world_2d().space)
	PhysicsServer2D.body_attach_object_instance_id(_body, get_instance_id())
	PhysicsServer2D.body_set_collision_mask(_body, mask)
	PhysicsServer2D.body_set_collision_layer(_body, layer)


	if !unit_information.collider.is_empty():
		for collider_name: String in unit_information.collider:
			_shape[collider_name] = PhysicsServer2D.rectangle_shape_create()
			PhysicsServer2D.shape_set_data(_shape[collider_name], unit_information.collider[collider_name] / 2.)
			PhysicsServer2D.body_add_shape(_body, _shape[collider_name], Transform2D(0., Vector2()), false)
			RenderingServer.canvas_item_add_rect(
				cid, Rect2(- unit_information.collider[collider_name] / 2., unit_information.collider[collider_name]),
				Color.WHITE
			)

	if !Engine.is_editor_hint():
		_hurtbox = Hurtbox.new()
		_hurtbox.rid = PhysicsServer2D.area_create()
		
		PhysicsServer2D.area_set_space(_hurtbox.rid, get_world_2d().space)
		PhysicsServer2D.area_set_area_monitor_callback(_hurtbox.rid, damaged)
		PhysicsServer2D.area_set_transform(_hurtbox.rid, Transform2D())
		PhysicsServer2D.area_set_monitorable(_hurtbox.rid, true)
		PhysicsServer2D.area_attach_object_instance_id(_hurtbox.rid, get_instance_id())
		
		_hurtbox.shape = PhysicsServer2D.rectangle_shape_create()
		PhysicsServer2D.area_add_shape(_hurtbox.rid, _hurtbox.shape, Transform2D(), false)
		PhysicsServer2D.shape_set_data(_hurtbox.shape, _hurtbox.size / 2.)
		
		if !skills.is_empty():
			for skill_name: String in skills:
				var info: SkillInformation = skills[skill_name]
				
				var awareness_area: AwarenessArea = AwarenessArea.new()
				awareness_area.rid = PhysicsServer2D.area_create()
				awareness_area.shape = PhysicsServer2D.circle_shape_create()
				PhysicsServer2D.shape_set_data(awareness_area.shape, info.range)
				PhysicsServer2D.area_set_monitor_callback(awareness_area.rid, unit_entered_awareness_area)
				
				var hitbox: Hitbox = Hitbox.new()
				hitbox.rid = PhysicsServer2D.area_create()
				hitbox.shape = PhysicsServer2D.rectangle_shape_create()
				
				var s: S = S.new()
				s.awareness_area = awareness_area
				

	init = true


func kill() -> void:
	PhysicsServer2D.free_rid(_body)
	
	if !_shape.is_empty():
		for shape_name: String in _shape:
			PhysicsServer2D.free_rid(_shape[shape_name])

	if _hurtbox:
		free_hurtbox()


func free_hurtbox() -> void:
	PhysicsServer2D.free_rid(_hurtbox.rid)
	PhysicsServer2D.free_rid(_hurtbox.shape)

	_hurtbox = null


func unit_entered_awareness_area(status: PhysicsServer2D.AreaBodyStatus, body_rid: RID, instance_id: int, area_shape_idx: int, self_shape_idx: int) -> void:
	if instance_id == get_instance_id(): return
	
	if status == PhysicsServer2D.AreaBodyStatus.AREA_BODY_ADDED:
		pass
	elif status == PhysicsServer2D.AreaBodyStatus.AREA_BODY_REMOVED:
		pass


func hit(status: PhysicsServer2D.AreaBodyStatus, area_rid: RID, instance_id: int, area_shape_idx: int, self_shape_idx: int) -> void:
	if instance_id == get_instance_id(): return
	
	if status == PhysicsServer2D.AreaBodyStatus.AREA_BODY_ADDED:
		pass
	elif status == PhysicsServer2D.AreaBodyStatus.AREA_BODY_REMOVED:
		pass


func damaged(value: int) -> void:
	pass


class Body extends RefCounted:
	var rid: RID
	var size: Vector2
	var pos: Vector2 = Vector2()
	var disabled: bool = false


class Hurtbox extends RefCounted:
	var direction: Vector2 = Vector2.ONE:
		get:
			return direction.normalized() if !direction.is_normalized() else direction
	var rid: RID
	var shape: RID
	var pos: Vector2
	var size: Vector2
	var duration: float:
		set(value):
			duration = maxf(value, 0.)
	var disabled: bool = false


class Hitbox extends RefCounted:
	var rid: RID
	var shape: RID
	var pos: Vector2
	var size: Vector2
	var duration: float:
		set(value):
			duration = maxf(value, 0.)
	var disabled: bool = false
	var look_target: bool = false


# ShapeCast
class HitRay extends Hitbox:
	var penetrate_count: int = 1


class S extends RefCounted:
	var awareness_area: AwarenessArea
	var hitbox: Hitbox
	var cooldown: float:
		set(value):
			cooldown = maxf(value, 0.)


class AwarenessArea extends RefCounted:
	var rid: RID
	var shape: RID
	var entered: Array[int] = []
	
	func is_enemy() -> bool:
		return !entered.is_empty()
