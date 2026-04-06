@tool
extends Node2D
class_name Legion


@export var instance: LegionInstance
@export var amount: int = 100
@export var navigation_polygon: NavigationPolygon = NavigationPolygon.new()
@export var layer: int = 1
@export var mask: int = 1

var arr: Array[I] = []
var nav_map: RID
var region: RID


func _enter_tree() -> void:
	nav_map = NavigationServer2D.map_create()
	NavigationServer2D.map_set_active(nav_map, true)
	
	region = NavigationServer2D.region_create()
	NavigationServer2D.region_set_transform(region, Transform2D())
	NavigationServer2D.region_set_map(region, nav_map)
	NavigationServer2D.region_set_navigation_polygon(region, navigation_polygon)
	
	arr.resize(amount)
	
	for i: int in range(amount):
		var inst: I = I.new()
		inst.cid = RenderingServer.canvas_item_create()
		RenderingServer.canvas_item_set_parent(inst.cid, get_canvas_item())
		
		inst.body = PhysicsServer2D.body_create()
		PhysicsServer2D.body_set_mode(inst.body, PhysicsServer2D.BODY_MODE_KINEMATIC)
		PhysicsServer2D.body_set_collision_layer(inst.body, layer)
		PhysicsServer2D.body_set_collision_mask(inst.body, mask)
		PhysicsServer2D.body_set_space(inst.body, get_world_2d().space)
		
		inst.shape = PhysicsServer2D.rectangle_shape_create()
		PhysicsServer2D.shape_set_data(inst.shape, instance.size / 2.)
		PhysicsServer2D.body_add_shape(inst.body, inst.shape, Transform2D(), false)
		
		inst.hitbox = PhysicsServer2D.area_create()
		PhysicsServer2D.area_set_space(inst.hitbox, get_world_2d().space)
		
		inst.hurtbox = PhysicsServer2D.area_create()
		
		
		inst.agent = NavigationServer2D.agent_create()

		arr[i] = inst

func _exit_tree() -> void:
	pass


func kill() -> void:
	NavigationServer2D.free_rid(nav_map)
	NavigationServer2D.free_rid(region)
	
	if !arr.is_empty():
		for inst in arr:
			PhysicsServer2D.free_rid(inst.body)
			PhysicsServer2D.free_rid(inst.shape)
			NavigationServer2D.free_rid(inst.agent)

	arr = []


class I extends RefCounted:
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
