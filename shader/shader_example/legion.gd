@tool
extends Node2D
class_name Legion


@export_category("Instance")
@export var instance: LegionInstance = LegionInstance.new()
@export var amount: int = 100
@export var navigation_polygon: NavigationPolygon = NavigationPolygon.new()
@export_flags_2d_physics var layer: int = 1
@export_flags_2d_physics var mask: int = 0


@export_category("Path")
@export var path_scope: PathScope


@export_category("Body")
@export var has_body: bool = false
@export var color: Color = Color(0.208, 0.37, 0.65, 0.522)
@export var body_parts: Array[AnimatedPart]


@export_category("Behavior Tree")
@export var behavior_tree: BehaviorTree = BehaviorTree.new()
@export var awareness_information: AwarenessInformation

@export_category("DEBUG")
@export var body_color: Color = Color(0.89, 0.0, 0.0, 0.537)


var arr: Array[Instance] = []

var nav_map: RID
var region: RID
var scope: Scope

var init: bool = false

@export var target: Node2D

@export_tool_button("Create", "2D") var _create: Callable = create


func create() -> void:
	if !instance or amount <= 0: return

	#nav_map = NavigationServer2D.map_create()
	#NavigationServer2D.map_set_active(nav_map, true)
	#
	#region = NavigationServer2D.region_create()
	#NavigationServer2D.region_set_transform(region, Transform2D())
	#NavigationServer2D.region_set_map(region, nav_map)
	#NavigationServer2D.region_set_navigation_polygon(region, navigation_polygon)
	if init:
		kill()
	
	create_path()
	
	if !Engine.is_editor_hint():
		arr.resize(amount)
		
		for i: int in range(amount):
			arr[i] = spawn_instance(i) # i번째 인스턴스 생성
		
		init = true


func _physics_process(delta: float) -> void:
	for instance: Instance in arr:
		if instance != null:
			if behavior_tree:
				var direction: Vector2 = instance.position.direction_to(target.global_position)
				instance.last_direction = direction
				var execute: BT.Status = instance.bt.get_root_task().execute(delta)
		
		PhysicsServer2D.area_set_transform(instance.awareness.rid, Transform2D(0., position))
		PhysicsServer2D.area_set_transform(instance.hurtbox.rid, Transform2D(0., position))
		
		RenderingServer.canvas_item_set_transform(instance.cid, Transform2D(0., position))
		RenderingServer.canvas_item_set_transform(instance.awareness.cid, Transform2D(0., position))
		RenderingServer.canvas_item_set_transform(instance.hitbox.cid, Transform2D(0., position))


func spawn_instance(index: int) -> Instance:
	var inst: Instance = Instance.new()
	
	inst.space = get_world_2d().space
	var spawn_point: Vector2 = scope.path.sample_baked(scope.path.get_baked_length() * randf())
	inst.position = spawn_point + (spawn_point.direction_to(scope.rect.size / 2.) * path_scope.margin)
	
	# Init Stat
	inst.stat = Stat.new()
	inst.stat.hp = instance.unit_information.init_hp
	inst.stat.atk = instance.unit_information.atk
	inst.stat.def = instance.unit_information.def
	inst.stat.speed = instance.unit_information.speed
	
	# (DEBUG) Set Instance Body Color Rect
	inst.cid = RenderingServer.canvas_item_create()
	RenderingServer.canvas_item_set_parent(inst.cid, get_canvas_item())
	RenderingServer.canvas_item_add_rect(
		inst.cid, Rect2(-inst.size / 2., inst.size), body_color
	)
	RenderingServer.canvas_item_set_transform(inst.cid, Transform2D(0., inst.position))
	RenderingServer.canvas_item_set_z_as_relative_to_parent(inst.cid, false)
	RenderingServer.canvas_item_set_z_index(inst.cid, 0)
	
	inst.shape = PhysicsServer2D.rectangle_shape_create()
	PhysicsServer2D.shape_set_data(inst.shape, instance.size / 2.)
	
	# Set Instance Body
	if has_body:
		inst.body = PhysicsServer2D.body_create()
		PhysicsServer2D.body_set_mode(inst.body, PhysicsServer2D.BODY_MODE_KINEMATIC)
		PhysicsServer2D.body_set_collision_layer(inst.body, layer)
		PhysicsServer2D.body_set_collision_mask(inst.body, mask)
		PhysicsServer2D.body_set_space(inst.body, get_world_2d().space)
		PhysicsServer2D.body_attach_object_instance_id(inst.body, inst.get_instance_id())
		PhysicsServer2D.body_add_shape(inst.body, inst.shape)
		PhysicsServer2D.body_set_state(inst.body, PhysicsServer2D.BODY_STATE_TRANSFORM, Transform2D(0., inst.position))
	
	# Init Hurtbox
	inst.hurtbox = Hurtbox.new()
	inst.hurtbox.rid = PhysicsServer2D.area_create()
	PhysicsServer2D.area_set_space(inst.hurtbox.rid, get_world_2d().space)
	inst.hurtbox.shape = PhysicsServer2D.rectangle_shape_create()
	PhysicsServer2D.shape_set_data(inst.hurtbox.shape, inst.hurtbox.size)
	PhysicsServer2D.area_attach_object_instance_id(inst.hurtbox.rid, inst.get_instance_id())
	PhysicsServer2D.area_set_monitorable(inst.hurtbox.rid, true)
	PhysicsServer2D.area_set_transform(inst.hurtbox.rid, Transform2D(0., inst.position))


	# Init Awareness Area
	inst.awareness = Awareness.new()
	inst.awareness.cid = RenderingServer.canvas_item_create()
	inst.awareness.rid = PhysicsServer2D.area_create()
	inst.awareness.radius = awareness_information.radius
	inst.awareness.position = awareness_information.position
	PhysicsServer2D.area_set_transform(inst.awareness.rid, Transform2D(0., inst.position))
	PhysicsServer2D.area_set_space(inst.awareness.rid, get_world_2d().space)
	PhysicsServer2D.area_attach_object_instance_id(inst.awareness.rid, inst.get_instance_id())
	PhysicsServer2D.area_set_monitor_callback(inst.awareness.rid, target_awareness_area_entered.bind(inst))
	inst.awareness.shape = PhysicsServer2D.circle_shape_create()
	PhysicsServer2D.shape_set_data(inst.awareness.shape, inst.awareness.radius)
	PhysicsServer2D.area_add_shape(inst.awareness.rid, inst.awareness.shape)
	PhysicsServer2D.area_set_transform(inst.awareness.rid, Transform2D(0., inst.position + inst.awareness.position))
	RenderingServer.canvas_item_set_transform(inst.awareness.cid, Transform2D(0., inst.position + inst.awareness.position))

	inst.awareness.cid = RenderingServer.canvas_item_create()
	RenderingServer.canvas_item_add_circle(
		inst.awareness.cid, Vector2(),
		inst.awareness.radius, Color(0.839, 1.0, 0.976, 0.404)
	)
	RenderingServer.canvas_item_set_parent(inst.awareness.cid, get_canvas_item())

	# Init hitbox
	inst.hitbox = Hitbox.new()
	inst.hitbox.size = instance.hitbox_information.size
	inst.hitbox.range = instance.hitbox_information.range
	inst.hitbox.damage = instance.hitbox_information.damage
	inst.hitbox.cid = RenderingServer.canvas_item_create()
	RenderingServer.canvas_item_set_parent(inst.hitbox.cid, get_canvas_item())


	# Init Behavior
	if behavior_tree:
		inst.bt = behavior_tree.clone()
	else:
		inst.bt = BehaviorTree.new()
	var sequence: BTSequence = BTSequence.new()
	
	var task_is_in_range: IsInRange = IsInRange.new()
	task_is_in_range.instance = inst
	
	var task_attack: Attack = Attack.new()
	task_attack.instance = inst
	
	inst.bt.set_root_task(sequence)
	sequence.add_child(task_is_in_range)
	sequence.add_child(task_attack)

	return inst


func target_awareness_area_entered(status: PhysicsServer2D.AreaBodyStatus, body_rid: RID, instance_id: int, area_shape_idx: int, self_shape_idx: int, inst: Instance) -> void:
	if instance_id != target.get_instance_id(): return
	
	if status == 0: # Entered
		inst.awareness.has_target = true
	elif status == 1: # Exited
		inst.awareness.has_target = false


func damaged(inst: Instance, value: int) -> void:
	inst.stat.hp -= value
	print("instance damaged => ", value)
	
	if inst.stat.hp <= 0:
		pass



func death() -> void:
	pass



func _exit_tree() -> void:
	if init:
		kill()


func kill() -> void:
	#NavigationServer2D.free_rid(nav_map)
	#NavigationServer2D.free_rid(region)
	if scope:
		RenderingServer.free_rid(scope.cid)

	if Engine.is_editor_hint():
		pass
	else:
		if !arr.is_empty():
			for inst in arr:
				if has_body:
					PhysicsServer2D.free_rid(inst.body)
					PhysicsServer2D.free_rid(inst.shape)
				PhysicsServer2D.free_rid(inst.hurtbox.rid)
				PhysicsServer2D.free_rid(inst.awareness.rid)
				#NavigationServer2D.free_rid(inst.agent)
				
				RenderingServer.free_rid(inst.cid)
				RenderingServer.free_rid(inst.awareness.cid)
				RenderingServer.free_rid(inst.hurtbox.cid)

		arr = []


func create_path() -> void:
	scope = Scope.new()
	
	scope.type = path_scope.path_type
	scope.rect = Rect2(path_scope.from, path_scope.to)
	scope.cid = RenderingServer.canvas_item_create()
	RenderingServer.canvas_item_set_parent(scope.cid, get_canvas_item())
	
	scope.path = Curve2D.new()
	
	if scope.type == PathScope.PATH_TYPE_RECT:
		scope.path.add_point((scope.rect.position))
		scope.path.add_point((scope.rect.position) + Vector2(0., scope.rect.size.y))
		scope.path.add_point((scope.rect.position) + scope.rect.size)
		scope.path.add_point((scope.rect.position) + Vector2(scope.rect.size.x, 0.))

		var polygon: PackedVector2Array = PackedVector2Array()
		polygon.resize(8)
		
		var index: int = 0
		for i in range(0, polygon.size(), 2):
			polygon[i] = scope.path.get_point_position(index)
			polygon[i + 1] = scope.path.get_point_position((index + 1) % scope.path.point_count)
			index += 1
		
		# [0 1 0 1] [2 3 1 2] [4 5 2 3] [6 7 3 0]
		if Engine.is_editor_hint():
			RenderingServer.canvas_item_set_transform(
				scope.cid, Transform2D(0., Vector2())
			)
			RenderingServer.canvas_item_add_rect(
				scope.cid, scope.rect, path_scope.color
			)
			RenderingServer.canvas_item_add_multiline(
				scope.cid, polygon, [Color.WHITE], 1.
			)

	elif scope.type == PathScope.PATH_TYPE_LINE:
		scope.path.add_point(scope.rect.position)
		scope.path.add_point(scope.rect.size)
		
		if Engine.is_editor_hint():
			RenderingServer.canvas_item_add_line(
				scope.cid, scope.rect.position, scope.rect.size, Color(0.0, 1.0, 1.0, 1.0), 3.
			)

	elif scope.type == PathScope.PATH_TYPE_CIRCLE:
		var radius: float = scope.rect.position.distance_to(scope.rect.size)
		for i: int in range(64):
			scope.path.add_point(scope.rect.position + Vector2.from_angle((TAU / 64.) * float(i)) * radius)
		
		if Engine.is_editor_hint():
			RenderingServer.canvas_item_add_circle(
				scope.cid, scope.rect.position, radius, Color(0.0, 1.0, 1.0, 1.0)
			)


class Instance extends RefCounted:
	var cid: RID
	var body: RID
	var shape: RID
	var space: RID
	var agent: RID
	var hurtbox: Hurtbox
	var awareness: Awareness
	var position: Vector2
	var size: Vector2
	var layer: int = 1
	var mask: int = 1
	var frame: int = 0
	var bt: BehaviorTree
	var stat: Stat
	var last_direction: Vector2
	var hitbox: Hitbox
	var z_relative: bool = false
	var z_value: float = 0.
	
	
	func create_hitbox(direction: Vector2) -> void:
		hitbox.rid = PhysicsServer2D.area_create()
		PhysicsServer2D.area_set_space(hitbox.rid, space)
		PhysicsServer2D.area_set_transform(hitbox.rid, Transform2D(0., position + (direction * hitbox.range)))
		PhysicsServer2D.area_set_area_monitor_callback(hitbox.rid, hit)
		PhysicsServer2D.area_set_collision_mask(hitbox.rid, 1)
		
		hitbox.shape = PhysicsServer2D.rectangle_shape_create()
		PhysicsServer2D.shape_set_data(hitbox.shape, hitbox.size / 2.)
		PhysicsServer2D.area_add_shape(hitbox.rid, hitbox.shape)
		
		PhysicsServer2D.area_attach_object_instance_id(hitbox.rid, get_instance_id())
		RenderingServer.canvas_item_set_transform(hitbox.cid, Transform2D(0., position + (direction * hitbox.range)))
		RenderingServer.canvas_item_add_rect(
			hitbox.cid, Rect2(- hitbox.size / 2., hitbox.size), Color.RED
		)


	func kill_hitbox() -> void:
		PhysicsServer2D.free_rid(hitbox.rid)
		PhysicsServer2D.free_rid(hitbox.shape)
		
		RenderingServer.canvas_item_clear(hitbox.cid)
		hitbox.result = null


	func move(motion: Vector2 = Vector2(), space: RID = RID()) -> MotionResult:
		var motion_result: MotionResult
		
		var direct_space: PhysicsDirectSpaceState2D = PhysicsServer2D.space_get_direct_state(space)
		var shape_param: PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()
		shape_param.collide_with_areas = true
		shape_param.collide_with_bodies = false
		shape_param.shape_rid = shape
		shape_param.motion = motion
		
		var rest_info: Dictionary = direct_space.get_rest_info(shape_param)
		var cast_motion: PackedFloat32Array = direct_space.cast_motion(shape_param)
		
		var safe_distance: float = cast_motion[0]
		var unsafe_distance: float = cast_motion[1]
		
		if !rest_info.is_empty():
			motion_result = MotionResult.new()
			motion_result.collider = instance_from_id(rest_info["collider_id"] as int)
			motion_result.normal = rest_info["normal"] as Vector2
			motion_result.point = rest_info["point"] as Vector2
		else:
			position += motion
		
		return motion_result


	func hit(status: PhysicsServer2D.AreaBodyStatus, area_rid: RID, instance_id: int, area_shape_idx: int, self_shape_idx: int) -> void:
		if status == PhysicsServer2D.AreaBodyStatus.AREA_BODY_ADDED:
			var obj: Object = instance_from_id(instance_id)
			if obj is Player and !hitbox.result:
				obj.damaged(hitbox.damage)
				hitbox.result = HitResult.new()
				hitbox.result.hit = true
		


class Stat extends RefCounted:
	var hp: int:
		set(value): hp = maxi(value, 0)
	var speed: float:
		set(value): speed = maxf(0., value)
	var atk: int = 3:
		set(value): atk = maxi(value, 0)
	var def: int = 3


class Hitbox extends RefCounted:
	var owner: Instance
	var cid: RID
	var rid: RID
	var range: float
	var size: Vector2
	var shape: RID
	var damage: int
	var result: HitResult


class HitResult extends RefCounted:
	var hit: bool = false
	var to: int = -1
	

class Hurtbox extends RefCounted:
	var owner: Instance
	var cid: RID
	var rid: RID
	var position: Vector2
	var size: Vector2
	var shape: RID


class Awareness extends RefCounted:
	var owner: Legion.Instance
	var cid: RID
	var rid: RID
	var position: Vector2
	var radius: float
	var shape: RID
	var has_target: bool = false


class IsInRange extends BTAction:
	var instance: Legion.Instance
	
	func _tick(delta: float) -> Status:
		if !instance.awareness.has_target:
			var motion_result: MotionResult = instance.move(
				instance.last_direction * instance.stat.speed * delta, instance.space
			)
			return RUNNING
		
		return SUCCESS


class Attack extends BTAction:
	var instance: Legion.Instance
	var duration: float:
		set(value):
			duration = maxf(value, 0.)

	func _enter() -> void:
		duration = 1.25
		instance.create_hitbox(instance.last_direction)


	func _tick(delta: float) -> Status:
		duration -= delta
		
		if duration > 0.:
			return RUNNING
		
		return SUCCESS


	func _exit() -> void:
		instance.kill_hitbox()


class Scope:
	var type: PathScope.Type
	var rect: Rect2
	var path: Curve2D
	var cid: RID


class DamagePopupText:
	var cid: RID
	var value: int
	var duration: float = .3
	var curve: Curve
