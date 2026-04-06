@tool
extends Node2D
class_name Sector


const NOTIFICATION_SECTOR_DISABLED: int = 900


@export var size: Vector2 = Vector2(640., 480.): set = set_size

var _body: RID
var segments: Array[RID]


@export_flags_2d_physics var mask: int = 1


@export var draw_center: bool = true:
	set(toggle):
		draw_center = toggle
		queue_redraw()
@export var color: Color = Color(0.0, 0.741, 0.733, 0.576):
	set(colour):
		color = colour
		queue_redraw()

@export var disabled: bool = false: set = set_disabled


func _enter_tree() -> void:
	if !segments.is_empty():
		kill()
	
	_body = PhysicsServer2D.body_create()
	
	segments = get_segments()

	PhysicsServer2D.body_set_space(_body, get_world_2d().space)
	
	PhysicsServer2D.body_set_state(
		_body, PhysicsServer2D.BODY_STATE_TRANSFORM, get_global_transform()
	)
			
	PhysicsServer2D.body_set_mode(_body, PhysicsServer2D.BODY_MODE_STATIC)
	PhysicsServer2D.body_set_collision_mask(_body, mask)

	PhysicsServer2D.body_attach_object_instance_id(_body, get_instance_id())
	
	for seg: RID in segments:
		PhysicsServer2D.body_add_shape(_body, seg)


func _exit_tree() -> void:
	if !segments.is_empty():
		kill()


func _draw() -> void:
	draw_rect(
		Rect2(-size/2. if draw_center else Vector2(), size), color, false, 1.
	)


func kill() -> void:
	for i: int in range(segments.size()):
		PhysicsServer2D.free_rid(segments[i])
	
	PhysicsServer2D.free_rid(_body)
	
	segments = []


func set_disabled(toggle: bool) -> void:
	disabled = toggle
	
	if segments.is_empty(): return
	
	if toggle:
		segs_disabled(true)
	else:
		segs_disabled(false)

	queue_redraw()


func segs_disabled(toggle: bool) -> void:
	if !segments.is_empty():
		for i: int in range(segments.size()):
			PhysicsServer2D.body_set_shape_disabled(
				_body, i, toggle
		)


func set_size(sz: Vector2):
	size = sz
	
	if !_body.is_valid(): return

	PhysicsServer2D.body_clear_shapes(_body)
		
	segments = get_segments()

	for rid: RID in segments:
		PhysicsServer2D.body_add_shape(_body, rid)
	
	queue_redraw()


func get_rect() -> Rect2:
	return Rect2(- (size / 2.), size) if draw_center else Rect2(Vector2(), size)


func get_polygon(closed: bool = true) -> PackedVector2Array:
	var result: PackedVector2Array = []
	
	result.push_back(- size / 2. if draw_center else Vector2())
	result.push_back(Vector2(result[0].x, result[0].y + size.y))
	result.push_back(Vector2(result[0].x + size.x, result[1].y))
	result.push_back(Vector2(result[0].x + size.x, result[0].y))

	if closed:
		result.push_back(result[0])
	
	return result


func get_segments() -> Array[RID]:
	var result: Array[RID] = []
	var segs: PackedVector2Array = get_polygon(true)
	
	for i: int in range(segs.size() - 1):
		var point_a: Vector2 = segs[i]
		var point_b: Vector2 = segs[i + 1]
		var segment_shape: RID = PhysicsServer2D.segment_shape_create()
		PhysicsServer2D.shape_set_data(segment_shape, Rect2(point_a, point_b))
		result.push_back(segment_shape)

	return result
