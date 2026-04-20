@tool
extends EEAD
class_name Legion


@export_category("Instance")
@export var legion_information: LegionInformation = LegionInformation.new()
@export var amount: int = 100
@export_flags_2d_physics var layer: int = 1
@export_flags_2d_physics var mask: int = 0


@export_category("Path")
@export var path_scope: PathScope = PathScope.new()
@export var navigation_polygon: NavigationPolygon = NavigationPolygon.new()

@export_category("Body")
@export var has_body: bool = false
@export var color: Color = Color(0.208, 0.37, 0.65, 0.522)
@export var body_parts: Array[AnimatedPart]


@export_category("Behavior Tree")
@export var behavior_tree: BehaviorTree = BehaviorTree.new()


@export_category("DEBUG")
@export var body_color: Color = Color(0.89, 0.0, 0.0, 0.537)


var arr: Array[Instance] = []

var nav_map: RID
var region: RID
var scope: Scope


@export var target: Node2D


func create() -> void:
	if !legion_information or amount <= 0: return
	
	if init:
		kill()
	
	create_path()
	
	if legion_information.use_nav:
		navigation_polygon = NavigationPolygon.new()
		navigation_polygon.baking_rect = scope.rect
		
		nav_map = NavigationServer2D.map_create()
		NavigationServer2D.map_set_active(nav_map, true)
		NavigationServer2D.map_set_cell_size(nav_map, 1.)

		region = NavigationServer2D.region_create()
		NavigationServer2D.region_set_transform(region, Transform2D())
		NavigationServer2D.region_set_map(region, nav_map)
		NavigationServer2D.region_set_navigation_polygon(region, navigation_polygon)
	
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
		
		PhysicsServer2D.area_set_transform(instance.awareness.rid, Transform2D(0., instance.position))
		PhysicsServer2D.area_set_transform(instance.hurtbox.rid, Transform2D(0., instance.position))
		#PhysicsServer2D.area_set_transform(instance.hitbox.rid, Transform2D(0., instance.position))
		
		RenderingServer.canvas_item_set_transform(instance.cid, Transform2D(0., instance.position))
		RenderingServer.canvas_item_set_transform(instance.awareness.cid, Transform2D(0., instance.position))
		RenderingServer.canvas_item_set_transform(instance.hitbox.cid, Transform2D(0., instance.position))


func spawn_instance(_index: int) -> Instance:
	var instance: Instance = Instance.new()
	
	instance.space = get_viewport().world_2d.space
	var spawn_point: Vector2 = scope.path.sample_baked(scope.path.get_baked_length() * randf())
	instance.position = spawn_point + (spawn_point.direction_to(scope.rect.size / 2.) * path_scope.margin)
	instance.map = nav_map
	
	# Init Agent
	instance.agent = NavigationServer2D.agent_create()
	NavigationServer2D.agent_get_avoidance_enabled(instance.agent)
	NavigationServer2D.agent_set_avoidance_layers(instance.agent, 1)
	NavigationServer2D.agent_set_map(instance.agent, instance.map)
	NavigationServer2D.agent_set_position(instance.agent, instance.position)
	
	# Init Stat
	instance.stat = Stat.new()
	instance.stat.hp = legion_information.unit_information.init_hp
	instance.stat.atk = legion_information.unit_information.atk
	instance.stat.def = legion_information.unit_information.def
	instance.stat.speed = legion_information.unit_information.speed
	
	# (DEBUG) Set Instance Body Color Rect
	instance.cid = RenderingServer.canvas_item_create()
	RenderingServer.canvas_item_set_parent(instance.cid, get_canvas_item())
	RenderingServer.canvas_item_add_rect(
		instance.cid, Rect2(-instance.size / 2., instance.size), body_color
	)
	RenderingServer.canvas_item_set_transform(instance.cid, Transform2D(0., instance.position))
	
	instance.shape = PhysicsServer2D.rectangle_shape_create()
	PhysicsServer2D.shape_set_data(instance.shape, legion_information.unit_information.collider["idle"] / 2.)
		
	# Set Instance Body
	if has_body:
		instance.body = PhysicsServer2D.body_create()
		PhysicsServer2D.body_set_mode(instance.body, PhysicsServer2D.BODY_MODE_KINEMATIC)
		PhysicsServer2D.body_set_collision_layer(instance.body, layer)
		PhysicsServer2D.body_set_collision_mask(instance.body, mask)
		PhysicsServer2D.body_set_space(instance.body, get_viewport().world_2d.space)
		PhysicsServer2D.body_attach_object_instance_id(instance.body, instance.get_instance_id())
		
		PhysicsServer2D.body_add_shape(instance.body, instance.shape)
		PhysicsServer2D.body_set_state(instance.body, PhysicsServer2D.BODY_STATE_TRANSFORM, Transform2D(0., instance.position))
	
	# Init Hurtbox
	instance.hurtbox = Hurtbox.new()
	instance.hurtbox.rid = PhysicsServer2D.area_create()
	PhysicsServer2D.area_set_space(instance.hurtbox.rid, get_viewport().world_2d.space)
	instance.hurtbox.shape = PhysicsServer2D.circle_shape_create()
	PhysicsServer2D.shape_set_data(instance.hurtbox.shape, instance.hurtbox.size.x)
	PhysicsServer2D.area_set_monitorable(instance.hurtbox.rid, true)
	PhysicsServer2D.area_set_transform(instance.hurtbox.rid, Transform2D(0., instance.position))
	PhysicsServer2D.area_attach_object_instance_id(instance.hurtbox.rid, instance.get_instance_id())

	# Init Awareness Area
	instance.awareness = Awareness.new()
	instance.awareness.cid = RenderingServer.canvas_item_create()
	instance.awareness.rid = PhysicsServer2D.area_create()
	instance.awareness.radius = legion_information.awareness_information.radius
	instance.awareness.position = legion_information.awareness_information.position
	PhysicsServer2D.area_set_transform(instance.awareness.rid, Transform2D(0., instance.position))
	PhysicsServer2D.area_set_space(instance.awareness.rid, get_viewport().world_2d.space)
	PhysicsServer2D.area_attach_object_instance_id(instance.awareness.rid, instance.get_instance_id())
	PhysicsServer2D.area_set_monitor_callback(instance.awareness.rid, target_awareness_area_entered.bind(instance))
	instance.awareness.shape = PhysicsServer2D.circle_shape_create()
	PhysicsServer2D.shape_set_data(instance.awareness.shape, instance.awareness.radius)
	PhysicsServer2D.area_add_shape(instance.awareness.rid, instance.awareness.shape)
	PhysicsServer2D.area_set_transform(instance.awareness.rid, Transform2D(0., instance.position + instance.awareness.position))
	RenderingServer.canvas_item_set_transform(instance.awareness.cid, Transform2D(0., instance.position + instance.awareness.position))

	instance.awareness.cid = RenderingServer.canvas_item_create()
	RenderingServer.canvas_item_add_circle(
		instance.awareness.cid, Vector2(),
		instance.awareness.radius, Color(0.839, 1.0, 0.976, 0.404)
	)
	RenderingServer.canvas_item_set_parent(instance.awareness.cid, get_canvas_item())

	# Init hitbox
	instance.hitbox = Hitbox.new()
	instance.hitbox.size = legion_information.hitbox_information.size
	instance.hitbox.range = legion_information.hitbox_information.range
	instance.hitbox.damage = legion_information.hitbox_information.damage
	instance.hitbox.cid = RenderingServer.canvas_item_create()
	RenderingServer.canvas_item_set_parent(instance.hitbox.cid, get_canvas_item())

	# Init Behavior
	if behavior_tree:
		instance.bt = behavior_tree.clone()
	else:
		instance.bt = BehaviorTree.new()
	var sequence: BTSequence = BTSequence.new()
	
	var task_is_in_range: IsInRange = IsInRange.new()
	task_is_in_range.instance = instance
	
	var task_attack: Attack = Attack.new()
	task_attack.instance = instance
	
	instance.bt.set_root_task(sequence)
	sequence.add_child(task_is_in_range)
	sequence.add_child(task_attack)

	return instance


func target_awareness_area_entered(status: PhysicsServer2D.AreaBodyStatus, body_rid: RID, instance_id: int, area_shape_idx: int, self_shape_idx: int, instance: Instance) -> void:
	if instance_id != target.get_instance_id(): return
	
	if status == 0: # Entered
		instance.awareness.has_target = true
	elif status == 1: # Exited
		instance.awareness.has_target = false


func damaged(instance: Instance, value: int) -> void:
	instance.stat.hp -= value
	print("instance damaged => ", value)
	
	if instance.stat.hp <= 0:
		pass



func death() -> void:
	pass



func _exit_tree() -> void:
	if init:
		kill()


func kill() -> void:
	if scope:
		RenderingServer.free_rid(scope.cid)
		scope = null

	if Engine.is_editor_hint():
		pass
	else:
		if !arr.is_empty():
			for instance in arr:
				if legion_information.use_nav:
					NavigationServer2D.free_rid(instance.agent)

				if has_body:
					PhysicsServer2D.free_rid(instance.body)
					PhysicsServer2D.free_rid(instance.shape)
				PhysicsServer2D.free_rid(instance.hurtbox.rid)
				PhysicsServer2D.free_rid(instance.awareness.rid)
				#NavigationServer2D.free_rid(instance.agent)
				
				RenderingServer.free_rid(instance.cid)
				RenderingServer.free_rid(instance.awareness.cid)
				RenderingServer.free_rid(instance.hurtbox.cid)

		arr = []
	
	if legion_information.use_nav:
		NavigationServer2D.free_rid(nav_map)
		NavigationServer2D.free_rid(region)

	RenderingServer.canvas_item_clear(get_canvas_item())


func create_path() -> void:
	scope = Scope.new()
	#print("Created Scope")
	
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
	
	var map: RID
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


	func move(from: Vector2, motion: Vector2 = Vector2(), space: RID = RID(), test: bool = false) -> MotionResult:
		var motion_result: MotionResult
		
		#var direct_space: PhysicsDirectSpaceState2D = PhysicsServer2D.space_get_direct_state(space)
		#var shape_param: PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()
		
		NavigationServer2D.agent_set_velocity(agent, motion)
		
		var path: PackedVector2Array = NavigationServer2D.map_get_path(
			map, from, from + motion, true
		)
		
		print(path)

		#shape_param.collide_with_areas = true
		#shape_param.collide_with_bodies = false
		#shape_param.shape_rid = shape
		#shape_param.transform = Transform2D(0., from)
		#shape_param.motion = motion
		#
		#var rest_info: Dictionary = direct_space.get_rest_info(shape_param)
		#var cast_motion: PackedFloat32Array = direct_space.cast_motion(shape_param)
		#
		#var safe_proportion: float = cast_motion[0]
		#var unsafe_proportion: float = cast_motion[1]
		#
		#if !rest_info.is_empty():
			#motion_result = MotionResult.new()
			#motion_result.collider = instance_from_id(rest_info["collider_id"] as int)
			#motion_result.remainder = shape_param.motion
			#motion_result.safe_proportion = safe_proportion
			#motion_result.unsafe_proportion = unsafe_proportion
			#motion_result.normal = rest_info["normal"] as Vector2
			#motion_result.point = rest_info["point"] as Vector2
			#
			#if !test:
				#if motion_result.collider is Instance:
					#position += motion * (safe_proportion)
				#else:
					#position += motion
		#else:
			#if !test:
				#position += motion
		
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
				instance.position,
				instance.last_direction * instance.stat.speed * delta,
				instance.space
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
