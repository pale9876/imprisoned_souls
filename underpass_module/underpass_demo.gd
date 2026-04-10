@tool
extends EEAD2D
class_name UnderpassModule


@export var underpass_line: Array[RoomInformation]


var arr: Array[A] = []


func create() -> void:
	if !underpass_line.is_empty():
		arr.resize(underpass_line.size())
		
		for i: int in range(underpass_line.size()):
			var a: A = A.new()
			
			a.cid = RenderingServer.canvas_item_create()
			RenderingServer.canvas_item_set_parent(a.cid, get_canvas_item())
			
			a.body = PhysicsServer2D.body_create()
			PhysicsServer2D.body_set_mode(a.body, PhysicsServer2D.BODY_MODE_STATIC)
			PhysicsServer2D.body_set_state(a.body, PhysicsServer2D.BODY_STATE_TRANSFORM, Transform2D(0., a.pos))
			PhysicsServer2D.body_set_space(a.body, get_world_2d())
			
			var area_rect: Rect2 = Rect2(underpass_line[i].pos, underpass_line[i].size)
			a.rect = area_rect
			
			a.shape.resize(4)
			a.door.resize(2)
			
			var polygon: PackedVector2Array = PackedVector2Array([
				Vector2(0., 0.),
				Vector2(0., a.size.y),
				a.size,
				Vector2(a.size.x, 0.),
				Vector2(0., 0.)
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
			
			if underpass_line[i].type == HORIZONTAL:
				PhysicsServer2D.body_set_shape_disabled(a.body, 0, false)
				PhysicsServer2D.body_set_shape_disabled(a.body, 2, false)
			elif underpass_line[i].type == VERTICAL:
				PhysicsServer2D.body_set_shape_disabled(a.body, 1, false)
				PhysicsServer2D.body_set_shape_disabled(a.body, 3, false)
			
			arr[i] = a


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
	var body: RID
	var shape: Array[RID]
	var door: Array[RID]
	var texture: Texture2D
	var rect: Rect2
	var shutdowned: bool = false
	var disabled: bool = false
