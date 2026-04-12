@tool
extends EEAD2D
class_name UnderpassModule


@export var debug_mode: bool = true
@export var underpass_line: Array[RoomInformation]
@export_flags_2d_physics var mask: int = 1


var arr: Array[A] = []


func _enter_tree() -> void:
	if !Engine.is_editor_hint():
		create()


func create() -> void:
	if init:
		kill()
	
	if !underpass_line.is_empty():
		arr.resize(underpass_line.size())
		
		for i: int in range(underpass_line.size()):
			var a: A = A.new()
			
			a.pos = underpass_line[i].pos
			a.size = underpass_line[i].size
			
			a.cid = RenderingServer.canvas_item_create()
			RenderingServer.canvas_item_set_parent(a.cid, get_canvas_item())
			
			a.body = PhysicsServer2D.body_create()
			PhysicsServer2D.body_set_mode(a.body, PhysicsServer2D.BODY_MODE_STATIC)
			PhysicsServer2D.body_set_state(a.body, PhysicsServer2D.BODY_STATE_TRANSFORM, Transform2D(0., global_position + a.pos))
			PhysicsServer2D.body_set_space(a.body, get_world_2d().space)
			PhysicsServer2D.body_set_collision_mask(a.body, mask)
			
			var area_rect: Rect2 = Rect2(underpass_line[i].pos, underpass_line[i].size)
			a.rect = area_rect
			
			a.shape.resize(4)
			a.door.resize(2)
			
			var polygon: PackedVector2Array = PackedVector2Array([
				- a.size / 2.,
				Vector2(- a.size.x / 2., a.size.y / 2.),
				a.size / 2.,
				Vector2(a.size.x / 2., - a.size.y / 2.),
				- a.size / 2.,
			])
			
			# 길이 가로면 1번째, 3번째 세그먼트를 닫아야하고,
			# 세로면 2번째, 4번째 세그먼트를 닫아야함.
			# 길이 가로면 항상 2번째 4번째 세그먼트가 항상 활성화되어야 하고
			# 세로면 1번째 3번째 세그먼트가 항상 활성화되어야함.
			
			for j: int in range(4):
				var segment: RID = PhysicsServer2D.segment_shape_create()
				PhysicsServer2D.shape_set_data(segment, Rect2(polygon[j], polygon[j + 1]))
				PhysicsServer2D.body_add_shape(
					a.body, segment, Transform2D(), false
				)
				a.shape[j] = segment
			
			if !underpass_line[i].closed:
				if underpass_line[i].type == HORIZONTAL:
					PhysicsServer2D.body_set_shape_disabled(a.body, 0, true)
					PhysicsServer2D.body_set_shape_disabled(a.body, 2, true)
				elif underpass_line[i].type == VERTICAL:
					PhysicsServer2D.body_set_shape_disabled(a.body, 1, true)
					PhysicsServer2D.body_set_shape_disabled(a.body, 3, true)
			
			if Engine.is_editor_hint() or debug_mode:
				RenderingServer.canvas_item_set_transform(a.cid, Transform2D(0., a.pos))
				
				RenderingServer.canvas_item_add_rect(
					a.cid, Rect2(- a.size / 2., a.size), Color(0.42, 1.0, 0.913, 0.365)
				)
				
				for j: int in range(4):
					RenderingServer.canvas_item_add_line(
						a.cid, polygon[j], polygon[j + 1],
						Color.WHITE if (!underpass_line[i].closed and (underpass_line[i].type == HORIZONTAL and (j == 1 or j == 3)) or (underpass_line[i].type == VERTICAL and (j == 0 or j == 2))) else Color.RED
					)
			
			arr[i] = a

	init = true


func kill() -> void:
	if !arr.is_empty():
		for a: A in arr:
			RenderingServer.free_rid(a.cid)
			PhysicsServer2D.free_rid(a.body)
			for s in a.shape:
				PhysicsServer2D.free_rid(s)


func area_disabled() -> void:
	pass



func _draw() -> void:
	pass



class A extends RefCounted:
	var cid: RID
	var pos: Vector2
	var size: Vector2
	var body: RID
	var shape: Array[RID]
	var door: Array[RID]
	var texture: Texture2D
	var rect: Rect2
	var shutdowned: bool = false
	var disabled: bool = false
