extends Node2D


var a_rid: RID

var b_rid: RID
var b_cid: RID

@export var target: Node2D


func _enter_tree() -> void:
	a_rid = PhysicsServer2D.body_create()
	var a_shape: RID = PhysicsServer2D.circle_shape_create()
	PhysicsServer2D.body_add_shape(a_rid, a_shape)
	PhysicsServer2D.shape_set_data(a_shape, 40.)
	PhysicsServer2D.body_set_space(a_rid, get_world_2d().space)
	PhysicsServer2D.body_set_mode(a_rid, PhysicsServer2D.BODY_MODE_KINEMATIC)
	PhysicsServer2D.body_set_state(a_rid, PhysicsServer2D.BODY_STATE_TRANSFORM, target.get_global_transform())
	
	
	b_rid = PhysicsServer2D.area_create()
	var b_shape: RID = PhysicsServer2D.circle_shape_create()
	PhysicsServer2D.area_add_shape(b_rid, b_shape)
	PhysicsServer2D.shape_set_data(b_shape, 40.)
	PhysicsServer2D.area_set_space(b_rid, get_world_2d().space)
	PhysicsServer2D.area_set_monitor_callback(b_rid, enteredexited)

	b_cid = RenderingServer.canvas_item_create()
	RenderingServer.canvas_item_add_circle(b_cid, Vector2(), 40., Color.WHITE)
	RenderingServer.canvas_item_set_transform(b_cid, Transform2D(0., Vector2(180., 180.)))
	RenderingServer.canvas_item_set_parent(b_cid, get_canvas_item())

	print(PhysicsServer2D.body_get_shape_transform(a_rid, 0))


func _physics_process(delta: float) -> void:
	PhysicsServer2D.area_set_transform(b_rid, Transform2D(0., get_global_mouse_position()))
	RenderingServer.canvas_item_set_transform(b_cid, Transform2D(0., get_global_mouse_position()))


func _draw() -> void:
	draw_circle(target.global_position, 40., Color.RED)



func enteredexited(status: PhysicsServer2D.AreaBodyStatus, body_rid: RID, instance_id: int, area_shape_idx: int, self_shape_idx: int) -> void:
	if status == PhysicsServer2D.AreaBodyStatus.AREA_BODY_ADDED:
		print("hello")
	elif status == PhysicsServer2D.AreaBodyStatus.AREA_BODY_REMOVED:
		print("exit")
