@tool
extends EEAD
class_name UnderpassModule


@export var debug_mode: bool = true
@export var size: Vector2 = Vector2(640., 360.)
@export var underpass_line: Array[RoomInformation]
@export_flags_2d_physics var mask: int = 1


var arr: Array[A] = []


func _enter_tree() -> void:
	if !Engine.is_editor_hint():
		create()


func create() -> void:
	if init:
		kill()
	
	RenderingServer.canvas_item_set_parent(get_canvas_item(), get_canvas())
	
	if !underpass_line.is_empty():
		arr.resize(underpass_line.size())
		
		for i: int in range(underpass_line.size()):
			var a: A = A.new()
			
			a.pos = Vector2(underpass_line[i].pos) * size
			a.size = size
			
			a.cid = RenderingServer.canvas_item_create()
			RenderingServer.canvas_item_set_parent(a.cid, get_canvas_item())
			
			a.body = PhysicsServer2D.body_create()
			PhysicsServer2D.body_set_mode(a.body, PhysicsServer2D.BODY_MODE_STATIC)
			PhysicsServer2D.body_set_state(a.body, PhysicsServer2D.BODY_STATE_TRANSFORM, Transform2D(0., Vector2()))
			PhysicsServer2D.body_set_space(a.body, get_viewport().world_2d.space)
			PhysicsServer2D.body_set_collision_mask(a.body, mask)
			
			var area_rect: Rect2 = Rect2(Vector2(), a.size)
			a.rect = area_rect
			
			a.segments.resize(4)
			a.door.resize(2)
			
			var segment_poly: PackedVector2Array = PackedVector2Array([
				a.pos,
				Vector2(a.pos.x, a.pos.y + a.size.y),
				a.pos + a.size,
				Vector2(a.pos.x + a.size.x, a.pos.y),
				a.pos,
			])
			
			var render_poly: PackedVector2Array = PackedVector2Array([
				Vector2(),
				Vector2(0., a.size.y),
				Vector2(a.size),
				Vector2(a.size.x, 0.),
				Vector2(),
			])
			
			# 길이 가로면 1번째, 3번째 세그먼트를 닫아야하고,
			# 세로면 2번째, 4번째 세그먼트를 닫아야함.
			# 길이 가로면 항상 2번째 4번째 세그먼트가 항상 활성화되어야 하고
			# 세로면 1번째 3번째 세그먼트가 항상 활성화되어야함.
			print(segment_poly)
			a.type = underpass_line[i].type
			a.closed = underpass_line[i].closed
			
			for j: int in range(4):
				var segment: RID = PhysicsServer2D.segment_shape_create()
				PhysicsServer2D.shape_set_data(segment, Rect2(segment_poly[j], segment_poly[j + 1]))
				#PhysicsServer2D.body_set_shape_as_one_way_collision(
					#a.body, j, true, .08, Vector2.UP
				#)
				PhysicsServer2D.body_add_shape(
					a.body, segment, Transform2D(), !get_segment_state(a, j)
				)
				print(!get_segment_state(a, j))
				a.segments[j] = segment
			
			if Engine.is_editor_hint() or debug_mode:
				RenderingServer.canvas_item_set_transform(a.cid, Transform2D(0., a.pos))
				RenderingServer.canvas_item_add_rect(
					a.cid, area_rect, Color(0.42, 1.0, 0.913, 0.365)
				)
				
				for j: int in range(4):
					RenderingServer.canvas_item_add_line(
						a.cid, render_poly[j], render_poly[j + 1],
						Color.WHITE if get_segment_state(a, j) else Color.RED
					)
			
			arr[i] = a

	init = true


func kill() -> void:
	if !arr.is_empty():
		for a: A in arr:
			RenderingServer.free_rid(a.cid)
			PhysicsServer2D.free_rid(a.body)
			for s: RID in a.segments:
				PhysicsServer2D.free_rid(s)


func get_segment_state(a: A, i: int) -> bool:
	return (
		!a.closed and (
			(a.type == HORIZONTAL and (i == 1 or i == 3)) or (a.type == VERTICAL and (i == 0 or i == 2))
		)
	)


func area_disabled() -> void:
	pass



func _draw() -> void:
	pass



class A extends RefCounted:
	var cid: RID
	var type: int
	var pos: Vector2
	var size: Vector2
	var body: RID
	var segments: Array[RID]
	var door: Array[RID]
	var texture: Texture2D
	var rect: Rect2
	var closed: bool = false
	var disabled: bool = false
