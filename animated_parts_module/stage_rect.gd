@tool
extends Node2D
class_name Sector


const NOTIFICATION_SECTOR_DISABLED: int = 900


@export var size: Vector2 = Vector2(640., 480.): set = set_size

var _body: RID
var segments: Array[RID]


@export var draw_center: bool = true:
	set(toggle):
		draw_center = toggle
		queue_redraw()
@export var color: Color = Color(0.0, 0.741, 0.733, 0.576):
	set(colour):
		color = colour
		queue_redraw()
@export var disabled: bool = false: set = set_disabled


func _init() -> void:
	pass


# OVERRIDE
func _enter_tree() -> void:
	pass


# OVERRIDE
func _physics_process(delta: float) -> void:
	pass


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENTER_TREE:
			if !disabled:
				init_body()

		NOTIFICATION_TRANSFORM_CHANGED:
			pass


		NOTIFICATION_VISIBILITY_CHANGED:
			disabled = !visible


		NOTIFICATION_DRAW:
			var new_color: Color = color
			
			if disabled: new_color.s = 0.
			
			draw_rect(get_rect(), new_color)


		NOTIFICATION_PHYSICS_PROCESS:
			pass


		NOTIFICATION_EXIT_TREE:
			PhysicsServer2D.free_rid(_body)


		NOTIFICATION_SECTOR_DISABLED:
			pass


func init_body() -> void:
	_body = PhysicsServer2D.body_create()
	PhysicsServer2D.body_attach_object_instance_id(_body, get_instance_id())
	
	PhysicsServer2D.body_set_space(_body, get_world_2d().space)
	
	PhysicsServer2D.body_set_state(
		_body, PhysicsServer2D.BODY_STATE_TRANSFORM, get_global_transform()
	)
	
	PhysicsServer2D.body_set_mode(_body, PhysicsServer2D.BODY_MODE_STATIC)
	
	PhysicsServer2D.body_set_collision_mask(_body, 1)
	PhysicsServer2D.body_set_collision_layer(_body, 1)
		
	segments = get_segments()
	
	for seg: RID in segments:
		PhysicsServer2D.body_add_shape(_body, seg)


func set_disabled(toggle: bool) -> void:
	disabled = toggle
	
	if toggle:
		if _body:
			PhysicsServer2D.free_rid(_body)
			notification(NOTIFICATION_SECTOR_DISABLED)
	else:
		init_body()
		
	queue_redraw()


func set_size(sz: Vector2):
	size = sz
	
	if _body:
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
