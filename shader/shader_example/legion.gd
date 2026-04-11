@tool
extends Node2D
class_name Legion


@export var instance: LegionInstance = LegionInstance.new()
@export var amount: int = 100
@export var navigation_polygon: NavigationPolygon = NavigationPolygon.new()
@export var layer: int = 1
@export var mask: int = 1
@export var spawn_path: Vector2 = Vector2(640., 380.)
@export var color: Color = Color(0.208, 0.37, 0.65, 0.522)

var arr: Array[I] = []
var nav_map: RID
var region: RID
var _path: Curve2D

var init: bool = false
var path_cid: RID
var target: Node2D

@export_tool_button("Create", "2D") var _create: Callable = create


func create() -> void:
	if !instance or amount == 0: return
	
	#nav_map = NavigationServer2D.map_create()
	#NavigationServer2D.map_set_active(nav_map, true)
	#
	#region = NavigationServer2D.region_create()
	#NavigationServer2D.region_set_transform(region, Transform2D())
	#NavigationServer2D.region_set_map(region, nav_map)
	#NavigationServer2D.region_set_navigation_polygon(region, navigation_polygon)

	if init:
		kill()
	
	if Engine.is_editor_hint():
		draw_path()
	else:
		draw_path()
		
		arr.resize(amount)
		
		for i: int in range(amount):
			arr[i] = spawn_instance()

	init = true


func spawn_instance() -> I:
	var inst: I = I.new()
	
	inst.cid = RenderingServer.canvas_item_create()
	RenderingServer.canvas_item_set_parent(inst.cid, get_canvas_item())
	
	inst.body = PhysicsServer2D.body_create()
	PhysicsServer2D.body_set_mode(inst.body, PhysicsServer2D.BODY_MODE_KINEMATIC)
	PhysicsServer2D.body_set_collision_layer(inst.body, layer)
	PhysicsServer2D.body_set_collision_mask(inst.body, mask)
	PhysicsServer2D.body_set_space(inst.body, get_world_2d().space)
	PhysicsServer2D.body_set_state(inst.body, PhysicsServer2D.BODY_STATE_TRANSFORM, inst.get_transform())
	
	inst.shape = PhysicsServer2D.rectangle_shape_create()
	PhysicsServer2D.shape_set_data(inst.shape, instance.size / 2.)
	PhysicsServer2D.body_add_shape(
		inst.body, inst.shape, Transform2D(), false
	)
	
	inst.hitbox = PhysicsServer2D.area_create()
	PhysicsServer2D.area_set_space(inst.hitbox, get_world_2d().space)
	
	inst.hurtbox = PhysicsServer2D.area_create()

	#inst.agent = NavigationServer2D.agent_create()

	var spawn_point: Vector2 = _path.sample_baked(randf())
	inst.position = spawn_point


	return inst


func create_hitbox() -> void:
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
				PhysicsServer2D.free_rid(inst.body)
				PhysicsServer2D.free_rid(inst.shape)
				NavigationServer2D.free_rid(inst.agent)

		arr = []


func draw_path() -> void:
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
			path_cid, Transform2D(0., - spawn_path / 2.)
		)
		RenderingServer.canvas_item_add_rect(
			path_cid, Rect2(Vector2(), spawn_path), color
		)
		RenderingServer.canvas_item_add_multiline(
			path_cid, polygon, [Color.WHITE], 1.
		)


class I extends RefCounted:
	enum State
	{
		WAIT = 0,
		MOVE = 1,
		ATTACK = 2,
	}
	
	var cid: RID
	var body: RID
	var shape: RID
	var agent: RID
	var hitbox: RID
	var hurtbox: RID
	var position: Vector2
	var size: Vector2
	var layer: int = 1
	var mask: int = 1
	var frame: int = 0
	var state: int = State.WAIT

	func get_transform() -> Transform2D: return Transform2D(0., position)



class Hitbox extends RefCounted:
	pass
