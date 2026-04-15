@tool
extends EEAD2D
class_name Player


enum Mode
{
	GROUNDED = 0,
	FLOAT = 1
}


const GROUNDED: Mode = Mode.GROUNDED
const FLOAT: Mode = Mode.FLOAT


signal health_changed(value: float)


@export_category("Settings")
@export var mode: Mode = GROUNDED
@export var init_collider: String = "idle"
@export var init_pose: String = "idle"

@export_category("Resources")
@export var unit_information: UnitInformation = UnitInformation.new()
@export var skills: Dictionary[String, SkillInformation]
@export var hurtbox_information: HurtboxInformation = HurtboxInformation.new()
@export var body_parts: Array[AnimatedPart]


@export_category("Canvas")
@export var texture: Dictionary[String, AtlasTexture]
@export var frame_coord: Vector2i = Vector2i()


@export_category("Collision")
@export_flags_2d_physics var mask: int = 1
@export_flags_2d_physics var layer: int = 1


var sep_ray: RID
var face: Vector2 = Vector2.RIGHT
var body: Body
var velocity: Vector2 = Vector2()
var pose: Pose

var _onwall: bool = false
var _onfloor: bool = false
var _onceil: bool = false

var _hurtbox: Hurtbox
var skill_arr: Array[Skill]

var cid: RID
var debug_cid: RID

var stat: Stat
var dash: Dash
var last_direciton: Vector2 = Vector2()


func _enter_tree() -> void:
	if !Engine.is_editor_hint():
		create()


func use_skill(skill: Skill) -> SkillResult:
	var result: SkillResult = SkillResult.new()
	var target: Legion.Instance = instance_from_id(skill.awareness_area.entered.pick_random()) as Legion.Instance
	var target_position: Vector2 = target.position
	var param: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(
		global_position, target_position, mask, [body.rid]
	)
	
	var ray_result: Dictionary = get_world_2d().direct_space_state.intersect_ray(param)
	
	if !ray_result.is_empty():
		if result["collider"] == target:
			result.hit = true
	
	return result


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	var input: Vector2 = Input.get_vector("left", "right", "up", "down")
	if input != Vector2():
		velocity = velocity.move_toward(input * stat.speed, stat.accel * delta)
		last_direciton = velocity.normalized()
	else:
		if velocity != Vector2():
			velocity = velocity.move_toward(Vector2(), stat.frict * delta)
	
	if Input.is_action_just_pressed("dash"):
		dash.use(.35)
	
	if !dash.active:
		move(velocity, delta)
	elif dash.active:
		dashing(last_direciton * stat.speed * 3.5 * delta, delta)
		if dash.duration <= 0.:
			dash.active = false
	
	PhysicsServer2D.body_set_state(body.rid, PhysicsServer2D.BODY_STATE_TRANSFORM, get_global_transform())
	
	if !skill_arr.is_empty():
		for skill: Skill in skill_arr:
			if !skill.enable():
				skill.cooldown -= delta
			else:
				if skill.awareness_area.is_enemy():
					var result: SkillResult = use_skill(skill)
			
			PhysicsServer2D.area_set_transform(skill.awareness_area.rid, get_global_transform())
	
	PhysicsServer2D.area_set_transform(_hurtbox.rid, get_global_transform())
	

func dashing(motion: Vector2, delta: float) -> void:
	dash.duration -= delta
	
	var motion_param: PhysicsTestMotionParameters2D = PhysicsTestMotionParameters2D.new()
	var motion_result: PhysicsTestMotionResult2D = PhysicsTestMotionResult2D.new()
	motion_param.from = get_global_transform()
	motion_param.motion = motion
	
	if !PhysicsServer2D.body_test_motion(body.rid, motion_param, motion_result):
		global_position += motion
	else:
		var shape_param: PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()
		shape_param.transform = get_global_transform()
		shape_param.motion = motion
		shape_param.shape_rid = body.shape
		shape_param.exclude = [body.rid]
	
		var rest_info: Dictionary = get_world_2d().direct_space_state.get_rest_info(shape_param)
		var normal: Vector2 = rest_info["normal"]
		var remainder: Vector2 = motion_result.get_remainder()
		
		global_position += motion * (motion_result.get_collision_safe_fraction() - .01)
		
		var remainder_param: PhysicsTestMotionParameters2D = PhysicsTestMotionParameters2D.new()
		var remainder_result: PhysicsTestMotionResult2D = PhysicsTestMotionResult2D.new()
		remainder_param.from = get_global_transform()
		remainder_param.motion = remainder.slide(normal)
		
		if !PhysicsServer2D.body_test_motion(body.rid, remainder_param, remainder_result):
			global_position += remainder.slide(normal)
		else:
			global_position += remainder.slide(normal) * (remainder_result.get_collision_safe_fraction() - .01)


func change_collider(collider_name: String) -> void:
	PhysicsServer2D.body_clear_shapes(body.rid)
	
	body.shape = body.collider[collider_name]
	PhysicsServer2D.body_add_shape(body.rid, body.shape, Transform2D(0., body.collider[collider_name].pos))


func move(motion: Vector2, delta: float) -> void:
	if motion == Vector2.ZERO: return
	
	var motion_param: PhysicsTestMotionParameters2D = PhysicsTestMotionParameters2D.new()
	var motion_result: PhysicsTestMotionResult2D = PhysicsTestMotionResult2D.new()
	
	motion_param.recovery_as_collision = true
	motion_param.exclude_objects = [self.get_instance_id()]
	motion_param.from = get_global_transform()
	motion_param.motion = motion * delta
	
	if motion != Vector2.ZERO:
		if PhysicsServer2D.body_test_motion(body.rid, motion_param, motion_result):
			var shape_param: PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()
			
			shape_param.collide_with_areas = false
			shape_param.collision_mask = mask
			shape_param.exclude = [body.rid]
			shape_param.shape_rid = body.shape
			shape_param.transform = get_global_transform()
			shape_param.motion = motion * delta
			shape_param.margin = 1.
			
			var old_global_position: Vector2 = global_position
			
			if motion_result.get_collision_safe_fraction() > .1:
				global_position += (motion * motion_result.get_collision_safe_fraction() * delta)
			
			var remainder: Vector2 = motion_result.get_remainder()
			var rest_info: Dictionary = get_world_2d().direct_space_state.get_rest_info(shape_param)
			var normal: Vector2 = rest_info["normal"]
			var point: Vector2 = rest_info["point"]
			
			if remainder != Vector2():
				remainder = remainder.slide(normal)

				var remainder_motion_param: PhysicsTestMotionParameters2D = PhysicsTestMotionParameters2D.new()
				remainder_motion_param.from = Transform2D(0., global_position)
				remainder_motion_param.motion = remainder
				remainder_motion_param.recovery_as_collision = true
				var remainder_motion_result: PhysicsTestMotionResult2D = PhysicsTestMotionResult2D.new()
				
				if PhysicsServer2D.body_test_motion(body.rid, remainder_motion_param, remainder_motion_result):
					global_position += remainder * (remainder_motion_result.get_collision_safe_fraction())
				else:
					global_position += remainder
			
			if mode == FLOAT:
				_onwall = true
			elif mode == GROUNDED:
				if absf(old_global_position.direction_to(point).angle() - Vector2.UP.angle()) < deg_to_rad(45.):
					_onceil = true
		else:
			global_position += motion * delta
			_onwall = false
			_onceil = true


func _exit_tree() -> void:
	if init:
		kill()


func create() -> void:
	if init:
		kill()
	
	cid = RenderingServer.canvas_item_create()
	RenderingServer.canvas_item_set_parent(cid, get_canvas_item())
	RenderingServer.canvas_item_set_transform(cid, Transform2D())
	
	body = Body.new()
	
	var _body: RID = PhysicsServer2D.body_create()
	PhysicsServer2D.body_set_mode(_body, PhysicsServer2D.BODY_MODE_KINEMATIC)
	PhysicsServer2D.body_set_space(_body, get_world_2d().space)
	PhysicsServer2D.body_attach_object_instance_id(_body, get_instance_id())
	PhysicsServer2D.body_set_collision_mask(_body, mask)
	PhysicsServer2D.body_set_collision_layer(_body, layer)
	PhysicsServer2D.body_set_state(_body, PhysicsServer2D.BODY_STATE_TRANSFORM, get_global_transform())
	body.rid = _body
	
	if !unit_information.collider.is_empty():
		for collider_name: String in unit_information.collider:
			var collider: Collider = Collider.new()
			collider.rid = PhysicsServer2D.rectangle_shape_create()
			PhysicsServer2D.shape_set_data(collider.rid, unit_information.collider[collider_name] / 2.)
			
			body.collider[collider_name] = collider
			
			RenderingServer.canvas_item_add_rect(
				cid, Rect2(- unit_information.collider[collider_name] / 2.,
				unit_information.collider[collider_name]),
				Color.WHITE
			)

	body.shape = body.collider[init_collider].rid
	PhysicsServer2D.body_add_shape(body.rid, body.shape)

	if !Engine.is_editor_hint():
		# Init Information to Stat
		stat = Stat.new()
		stat.hp = unit_information.init_hp
		stat.max_hp = unit_information.max_hp
		stat.atk_speed = unit_information.atk_speed
		stat.speed = unit_information.speed
		stat.frict = unit_information.friction
		stat.accel = unit_information.acceleration
		
		# Create Hurtbox
		_hurtbox = Hurtbox.new()
		_hurtbox.rid = PhysicsServer2D.area_create()
		
		PhysicsServer2D.area_set_space(_hurtbox.rid, get_world_2d().space)
		PhysicsServer2D.area_set_area_monitor_callback(_hurtbox.rid, damaged)
		PhysicsServer2D.area_set_transform(_hurtbox.rid, Transform2D())
		PhysicsServer2D.area_set_monitorable(_hurtbox.rid, true)
		PhysicsServer2D.area_set_collision_mask(_hurtbox.rid, 1)
		PhysicsServer2D.area_set_collision_layer(_hurtbox.rid, 1)
		PhysicsServer2D.area_attach_object_instance_id(_hurtbox.rid, get_instance_id())
		
		_hurtbox.shape = PhysicsServer2D.rectangle_shape_create()
		PhysicsServer2D.area_add_shape(_hurtbox.rid, _hurtbox.shape)
		PhysicsServer2D.shape_set_data(_hurtbox.shape, _hurtbox.size / 2.)
		
		if !skills.is_empty():
			for skill_name: String in skills:
				var info: SkillInformation = skills[skill_name]
				var s: Skill = Skill.new()
				
				var awareness_area: AwarenessArea = AwarenessArea.new()
				awareness_area.rid = PhysicsServer2D.area_create()
				PhysicsServer2D.area_set_space(awareness_area.rid, get_world_2d().space)
				PhysicsServer2D.area_attach_object_instance_id(awareness_area.rid, awareness_area.get_instance_id())
				PhysicsServer2D.area_set_monitorable(awareness_area.rid, false)
				
				awareness_area.shape = PhysicsServer2D.circle_shape_create()
				PhysicsServer2D.shape_set_data(awareness_area.shape, info.skill_range)
				PhysicsServer2D.area_add_shape(awareness_area.rid, awareness_area.shape)
				PhysicsServer2D.area_set_monitor_callback(awareness_area.rid, unit_entered_awareness_area.bind(awareness_area))
				PhysicsServer2D.area_set_transform(awareness_area.rid, get_global_transform())
				
				s.awareness_area = awareness_area
	
	dash = Dash.new()
	
	
	init = true


func create_hitbox(duration: float, timer_scale: float) -> void:
	var hitbox: Hitbox = Hitbox.new()
	hitbox.rid = PhysicsServer2D.area_create()
	PhysicsServer2D.area_set_space(hitbox.rid, get_world_2d().space)
	
	hitbox.duration = duration
	
	var hitbox_shape: RID = PhysicsServer2D.rectangle_shape_create()
	PhysicsServer2D.area_add_shape(hitbox, hitbox_shape, Transform2D(), false)


func kill() -> void:
	if body:
		for index: int in range(PhysicsServer2D.body_get_shape_count(body.rid)):
			PhysicsServer2D.free_rid(PhysicsServer2D.body_get_shape(body.rid, index))
		PhysicsServer2D.free_rid(body.rid)
	
		for collider_name: String in body.collider:
			PhysicsServer2D.free_rid(body.collider[collider_name].rid)

	if _hurtbox:
		free_hurtbox()

	if !skill_arr.is_empty():
		free_skill()


func free_hurtbox() -> void:
	PhysicsServer2D.free_rid(_hurtbox.rid)
	PhysicsServer2D.free_rid(_hurtbox.shape)

	_hurtbox = null


func free_skill() -> void:
	for s: Skill in skill_arr:
		PhysicsServer2D.free_rid(s.awareness_area)


func unit_entered_awareness_area(status: PhysicsServer2D.AreaBodyStatus, body_rid: RID, instance_id: int, area_shape_idx: int, self_shape_idx: int, awareness_area: AwarenessArea) -> void:
	if instance_id == get_instance_id(): return
	
	if status == PhysicsServer2D.AreaBodyStatus.AREA_BODY_ADDED:
		var obj: Object = instance_from_id(instance_id)
		if obj is Legion.Instance:
			awareness_area.entered.push_back(instance_id)
			print("hello")

	elif status == PhysicsServer2D.AreaBodyStatus.AREA_BODY_REMOVED:
		if awareness_area.entered.has(instance_id):
			awareness_area.entered.erase(instance_id)
		


func hit(status: PhysicsServer2D.AreaBodyStatus, area_rid: RID, instance_id: int, area_shape_idx: int, self_shape_idx: int) -> void:
	if instance_id == get_instance_id(): return
	
	if status == PhysicsServer2D.AreaBodyStatus.AREA_BODY_ADDED:
		pass
	elif status == PhysicsServer2D.AreaBodyStatus.AREA_BODY_REMOVED:
		pass


func damaged(value: int) -> void:
	print("Player damaged => ", value)


class Body extends RefCounted:
	var rid: RID
	var collider: Dictionary[String, Collider]
	var shape: RID
	var size: Vector2
	var pos: Vector2 = Vector2()
	var disabled: bool = false


class Collider extends RefCounted:
	var pos: Vector2
	var size: Vector2
	var rid: RID


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
	var cid: RID
	var rid: RID
	var shape: RID
	var range: float
	var size: Vector2
	var duration: float:
		set(value):
			duration = maxf(value, 0.)
	var disabled: bool = false
	var look_target: bool = false


class Skill extends RefCounted:
	var ray_type: int = SkillInformation.RAYTYPE_CAST
	var attack_type: int = SkillInformation.ATK_EXPLOSION
	var awareness_area: AwarenessArea
	var cooltime: float
	var cooldown: float:
		set(value):
			cooldown = maxf(value, 0.)
	var hitbox: Hitbox

	func enable() -> bool:
		return cooldown == 0.


class AwarenessArea extends RefCounted:
	var rid: RID
	var shape: RID
	var entered: Array[int] = []
	
	func is_enemy() -> bool:
		return !entered.is_empty()


class Stat extends RefCounted:
	var hp: int
	var max_hp: int
	var speed: float
	var atk_speed: float = 1.
	var accel: float
	var frict: float


class Dash extends RefCounted:
	var active: bool = false
	var duration: float = .75:
		set(value):
			duration = maxf(0., value)
	var cooltime: float = 1.
	var _cooldown: float = 0.:
		set(value): _cooldown = maxf(value, 0.)
	
	func enable() -> bool:
		return _cooldown == 0. and !active

	func use(duration: float) -> void:
		_cooldown = cooltime
		self.duration = duration
		active = true


class SkillResult:
	var target: int
	var point: Vector2
	var hit: bool = false
