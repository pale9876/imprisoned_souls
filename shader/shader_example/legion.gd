@tool
extends Node2D
class_name Legion


@export_category("Instance")
@export var instance: LegionInstance = LegionInstance.new()
@export var amount: int = 100
@export var navigation_polygon: NavigationPolygon = NavigationPolygon.new()
@export_flags_2d_physics var layer: int = 1
@export_flags_2d_physics var mask: int = 0


@export_category("Spawn Region")
@export var spawn_time: float = 2.
@export var spawn_path: Vector2 = Vector2(640., 380.)
@export var margin: float = 50.


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
var _path: Curve2D

var init: bool = false
var path_cid: RID

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
			arr[i] = spawn_instance()
		
		init = true


func _physics_process(delta: float) -> void:
	for i: Instance in arr:
		if i != null:
			if behavior_tree:
				var direction: Vector2 = i.position.direction_to(target.global_position)
				i.last_direction = direction
				var execute: BT.Status = i.bt.get_root_task().execute(delta)


func spawn_instance() -> Instance:
	var inst: Instance = Instance.new()
	
	inst.space = get_world_2d().space
	var spawn_point: Vector2 = _path.sample_baked(_path.get_baked_length() * randf())
	
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
	
	# Set Instance Body
	if has_body:
		inst.body = PhysicsServer2D.body_create()
		PhysicsServer2D.body_set_mode(inst.body, PhysicsServer2D.BODY_MODE_KINEMATIC)
		PhysicsServer2D.body_set_collision_layer(inst.body, layer)
		PhysicsServer2D.body_set_collision_mask(inst.body, mask)
		PhysicsServer2D.body_set_space(inst.body, get_world_2d().space)
		PhysicsServer2D.body_attach_object_instance_id(inst.body, inst.get_instance_id())
		inst.shape = PhysicsServer2D.rectangle_shape_create()
		PhysicsServer2D.shape_set_data(inst.shape, instance.size / 2.)
		PhysicsServer2D.body_add_shape(inst.body, inst.shape)
		PhysicsServer2D.body_set_state(inst.body, PhysicsServer2D.BODY_STATE_TRANSFORM, Transform2D(0., inst.position))
	
	inst.hurtbox = Hurtbox.new()
	inst.hurtbox.rid = PhysicsServer2D.area_create()
	PhysicsServer2D.area_set_space(inst.hurtbox.rid, get_world_2d().space)
	inst.hurtbox.shape = PhysicsServer2D.circle_shape_create()
	PhysicsServer2D.shape_set_data(inst.hurtbox.shape, 10.)
	PhysicsServer2D.area_attach_object_instance_id(inst.hurtbox.rid, inst.get_instance_id())
	PhysicsServer2D.area_set_monitorable(inst.hurtbox.rid, true)

	inst.awareness = Awareness.new()
	inst.awareness.rid = PhysicsServer2D.area_create()
	PhysicsServer2D.area_set_transform(inst.awareness.rid, Transform2D(0., inst.position))
	PhysicsServer2D.area_set_space(inst.awareness.rid, get_world_2d().space)
	PhysicsServer2D.area_attach_object_instance_id(inst.awareness.rid, inst.get_instance_id())
	PhysicsServer2D.area_set_monitor_callback(inst.awareness.rid, target_awareness_area_entered.bind(inst))
	inst.awareness.shape = PhysicsServer2D.circle_shape_create()
	PhysicsServer2D.shape_set_data(inst.awareness.shape, 5.)
	PhysicsServer2D.area_add_shape(inst.awareness.rid, inst.awareness.shape)
	
	inst.awareness.cid = RenderingServer.canvas_item_create()
	RenderingServer.canvas_item_add_circle(
		inst.awareness.cid, Vector2(), 40., Color(0.839, 1.0, 0.976, 0.404)
	)
	RenderingServer.canvas_item_set_parent(inst.awareness.cid, get_canvas_item())
	
	# Init Position Transform
	RenderingServer.canvas_item_set_transform(inst.cid, Transform2D(0., inst.position))
	PhysicsServer2D.area_set_transform(inst.awareness.rid, Transform2D(0., inst.position))
	RenderingServer.canvas_item_set_transform(inst.awareness.cid, Transform2D(0., inst.position))
	PhysicsServer2D.area_set_transform(inst.hurtbox.rid, Transform2D(0., inst.position))


	# Init hitbox
	inst.hitbox = Hitbox.new()
	inst.hitbox.size = instance.hitbox_information.size
	inst.hitbox.range = instance.hitbox_information.range
	inst.hitbox.damage = instance.hitbox_information.damage

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


func damaged(status: PhysicsServer2D.AreaBodyStatus, area_rid: RID, instance_id: int, area_shape_idx: int, self_shape_idx: int) -> void:
	pass


func death() -> void:
	pass



func _exit_tree() -> void:
	if init:
		kill()


func kill() -> void:
	#NavigationServer2D.free_rid(nav_map)
	#NavigationServer2D.free_rid(region)
	
	if Engine.is_editor_hint():
		RenderingServer.free_rid(path_cid)
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
	_path = Curve2D.new()
	
	_path.add_point(global_position)
	_path.add_point(global_position + Vector2(0., spawn_path.y))
	_path.add_point(global_position + spawn_path)
	_path.add_point(global_position + Vector2(spawn_path.x, 0.))
	_path.add_point(global_position)

	if Engine.is_editor_hint():
		var polygon: PackedVector2Array = PackedVector2Array()
		polygon.resize(8)
		polygon[0] = global_position
		polygon[1] = global_position + Vector2(0., spawn_path.y)
		
		polygon[2] = global_position + Vector2(0., spawn_path.y)
		polygon[3] = global_position + spawn_path
		
		polygon[4] = global_position + spawn_path
		polygon[5] = global_position + Vector2(spawn_path.x, 0.)
		
		polygon[6] = global_position + Vector2(spawn_path.x, 0.)
		polygon[7] = global_position

		path_cid = RenderingServer.canvas_item_create()
		
		RenderingServer.canvas_item_set_parent(path_cid, get_canvas_item())
		RenderingServer.canvas_item_set_transform(
			path_cid, Transform2D(0., Vector2())
		)
		RenderingServer.canvas_item_add_rect(
			path_cid, Rect2(Vector2(), spawn_path), color
		)
		RenderingServer.canvas_item_add_multiline(
			path_cid, polygon, [Color.WHITE], 1.
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
	
	
	func create_hitbox(direction: Vector2) -> void:
		hitbox.rid = PhysicsServer2D.area_create()
		PhysicsServer2D.area_set_space(hitbox.rid, space)
		PhysicsServer2D.area_set_transform(hitbox.rid, Transform2D(0., position + (direction * hitbox.range)))
		
		hitbox.shape = PhysicsServer2D.rectangle_shape_create()
		PhysicsServer2D.shape_set_data(hitbox.shape, hitbox.size / 2.)
		PhysicsServer2D.area_add_shape(hitbox.rid, hitbox.shape)
		
		hitbox.cid = RenderingServer.canvas_item_create()
		

	func kill_hitbox() -> void:
		PhysicsServer2D.free_rid(hitbox.rid)
		PhysicsServer2D.free_rid(hitbox.shape)
	

	func move(motion: Vector2 = Vector2()) -> void:
		position += motion
		
		#PhysicsServer2D.body_set_state(body,PhysicsServer2D.BODY_STATE_TRANSFORM,Transform2D(0., position))
		
		PhysicsServer2D.area_set_transform(awareness.rid, Transform2D(0., position))
		PhysicsServer2D.area_set_transform(hurtbox.rid, Transform2D(0., position))

		RenderingServer.canvas_item_set_transform(cid, Transform2D(0., position))
		RenderingServer.canvas_item_set_transform(awareness.cid, Transform2D(0., position))


	func hit(status: PhysicsServer2D.AreaBodyStatus, area_rid: RID, instance_id: int, area_shape_idx: int, self_shape_idx: int) -> void:
		if status == PhysicsServer2D.AreaBodyStatus.AREA_BODY_ADDED:
			print("HI")


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


class Hurtbox extends RefCounted:
	var owner: Instance
	var cid: RID
	var rid: RID
	var pos: Vector2
	var size: Vector2
	var shape: RID


class Awareness extends RefCounted:
	var owner: Legion.Instance
	var cid: RID
	var rid: RID
	var pos: Vector2
	var radius: float
	var shape: RID
	var has_target: bool = false


class IsInRange extends BTAction:
	var instance: Legion.Instance
	
	func _tick(delta: float) -> Status:
		if !instance.awareness.has_target:
			instance.move(instance.last_direction * instance.stat.speed * delta)
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
