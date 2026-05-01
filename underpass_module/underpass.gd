@tool
extends EEAD
class_name Underpass


@export var debug_mode: bool = true
@export var size: Vector2 = Vector2(640., 360.)
@export var underpass_line: Array[RoomInformation]
@export_flags_2d_physics var mask: int = 1


var arr: Array[Region] = []


func _enter_tree() -> void:
	if !Engine.is_editor_hint():
		create()


func region_add_polgon(_arr: PackedVector2Array) -> void:
	var _mesh: NavigationPolygon = NavigationPolygon.new()
	
	var polygon: PackedVector2Array = PackedVector2Array()
	
	_mesh.set_vertices(
		polygon
	)




func create() -> void:
	if init:
		kill()
	
	
	RenderingServer.canvas_item_set_parent(get_canvas_item(), get_canvas())
	
	var navigation_map: RID = get_viewport().world_2d.navigation_map
	
	if !underpass_line.is_empty():
		arr.resize(underpass_line.size())
		
		for i: int in range(underpass_line.size()):
			var _region: Region = Region.new()
			
			# Init Datas
			_region.pos = Vector2(underpass_line[i].pos) * size
			_region.size = size
			
			_region.cid = RenderingServer.canvas_item_create()
			RenderingServer.canvas_item_set_parent(_region.cid, get_canvas_item())
			
			_region.body = PhysicsServer2D.body_create()
			PhysicsServer2D.body_set_mode(_region.body, PhysicsServer2D.BODY_MODE_STATIC)
			PhysicsServer2D.body_set_state(_region.body, PhysicsServer2D.BODY_STATE_TRANSFORM, Transform2D(0., Vector2()))
			PhysicsServer2D.body_set_space(_region.body, get_viewport().world_2d.space)
			PhysicsServer2D.body_set_collision_mask(_region.body, mask)
			
			var area_rect: Rect2 = Rect2(Vector2(), _region.size)
			_region.rect = area_rect
			
			_region.segments.resize(4)
			_region.door.resize(2)
			
			var segment_poly: PackedVector2Array = PackedVector2Array([
				_region.pos,
				Vector2(_region.pos.x, _region.pos.y + _region.size.y),
				_region.pos + _region.size,
				Vector2(_region.pos.x + _region.size.x, _region.pos.y),
				_region.pos,
			])
			
			var render_poly: PackedVector2Array = PackedVector2Array([
				Vector2(),
				Vector2(0., _region.size.y),
				Vector2(_region.size),
				Vector2(_region.size.x, 0.),
				Vector2(),
			])
			
			# 길이 가로면 1번째, 3번째 세그먼트를 닫아야하고,
			# 세로면 2번째, 4번째 세그먼트를 닫아야함.
			# 길이 가로면 항상 2번째 4번째 세그먼트가 항상 활성화되어야 하고
			# 세로면 1번째 3번째 세그먼트가 항상 활성화되어야함.
			_region.type = underpass_line[i].type
			_region.closed = underpass_line[i].closed
			
			for j: int in range(4):
				var segment: RID = PhysicsServer2D.segment_shape_create()
				PhysicsServer2D.shape_set_data(segment, Rect2(segment_poly[j], segment_poly[j + 1]))
				#PhysicsServer2D.body_set_shape_as_one_way_collision(
					#a.body, j, true, .08, Vector2.UP
				#)
				PhysicsServer2D.body_add_shape(
					_region.body, segment, Transform2D(), !get_segment_state(_region, j)
				)
				_region.segments[j] = segment
			
			if Engine.is_editor_hint() or debug_mode:
				RenderingServer.canvas_item_set_transform(_region.cid, Transform2D(0., _region.pos))
				RenderingServer.canvas_item_add_rect(
					_region.cid, area_rect, Color(0.42, 1.0, 0.913, 0.365)
				)
				
				for j: int in range(4):
					RenderingServer.canvas_item_add_line(
						_region.cid, render_poly[j], render_poly[j + 1],
						Color.WHITE if get_segment_state(_region, j) else Color.RED
					)
			
			#NavigationServer2D.region_set_enabled(region_rid, true)
			#NavigationServer2D.region_set_map(region_rid, get_viewport().world_2d.navigation_map)
#
			#navigation_mesh.vertices = PackedVector2Array([
				#Vector2(0.0, 0.0),
				#Vector2(100.0, 0.0),
				#Vector2(100.0, 100.0),
				#Vector2(0.0, 100.0),
			#])
#
			#navigation_mesh.add_polygon(
				#PackedInt32Array([0, 1, 2, 3])
			#)
#
			#NavigationServer2D.region_set_navigation_polygon(region_rid, navigation_mesh)
			
			# Create Region
			var mesh: NavigationPolygon = NavigationPolygon.new()
			var region_rid: RID = NavigationServer2D.region_create()
			NavigationServer2D.region_set_map(
				region_rid, navigation_map
			)
			NavigationServer2D.region_set_enabled(region_rid, true)
			var vertices: PackedVector2Array = PackedVector2Array([
						_region.pos,
						Vector2(_region.pos.x, _region.pos.y + _region.size.y),
						_region.pos + _region.size,
						Vector2(_region.pos.x + _region.size.x, _region.pos.y)
					])
			var polygon: PackedInt32Array = PackedInt32Array([0, 1, 2, 3])
			mesh.set_vertices(vertices)
			mesh.add_polygon(polygon)
			
			# Create Link
			_region.link = NavigationServer2D.link_create()
			

			
			arr[i] = _region
	
	init = true


func kill() -> void:
	if !arr.is_empty():
		for _region: Region in arr:
			RenderingServer.free_rid(_region.cid)
			PhysicsServer2D.free_rid(_region.body)
			for s: RID in _region.segments:
				PhysicsServer2D.free_rid(s)


func get_segment_state(a: Region, i: int) -> bool:
	return (
		!a.closed and (
			(a.type == HORIZONTAL and (i == 1 or i == 3)) or (a.type == VERTICAL and (i == 0 or i == 2))
		)
	)
