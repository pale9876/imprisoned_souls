# HACK: 해당 노드가 뷰포트를 생성하고 다른 캔버스를 참조하여 텍스쳐를 생성하고 그리는 일련의 반복동작을 수행하기에
# 부하가 많을 수 있음.
# 장점은 셰이더를 쓰는 것보다 단순함..
# 많은 반사 오프젝트가 필요할 경우에는 해당 오브젝트를 쓰는 것을 피하는 것이 좋음.


@tool
extends EEAD2D
class_name ReflectReplicator2D


@export var reflect_region: Rect2i = Rect2i(Vector2(-100, 0), Vector2(100, 100))

@export_flags_2d_render var cull_mask: int = 1


var _viewport: RID
var _vpt: RID
var cid: RID


func _enter_tree() -> void:
	if !Engine.is_editor_hint():
		create()


func create() -> void:
	if Engine.is_editor_hint() and do_not_test_in_editor: return
	
	if init:
		kill()
		init = false
	
	_viewport = RenderingServer.viewport_create()
	cid = RenderingServer.canvas_item_create()

	RenderingServer.viewport_set_size(
		_viewport, reflect_region.size.x, reflect_region.size.y
	)

	RenderingServer.viewport_attach_canvas(
		_viewport, get_world_2d().canvas
	)

	RenderingServer.viewport_set_canvas_cull_mask(_viewport, cull_mask)
	RenderingServer.viewport_set_active(_viewport, true)
	RenderingServer.viewport_set_parent_viewport(_viewport, get_viewport().get_viewport_rid())
	RenderingServer.viewport_set_update_mode(_viewport, RenderingServer.VIEWPORT_UPDATE_WHEN_PARENT_VISIBLE)
	RenderingServer.viewport_set_clear_mode(_viewport, RenderingServer.VIEWPORT_CLEAR_ALWAYS)
	
	#var _texture: RID = RenderingServer.viewport_get_texture(_viewport)
	#RenderingServer.canvas_item_add_texture_rect(
		#get_canvas_item(),
		#Rect2(Vector2(), reflect_region.size),
		#_texture, false, Color.WHITE
	#)
	#_vpt = _texture

	init = true


func _process(_delta: float) -> void:
	if !Engine.is_editor_hint():
		global_position = get_global_mouse_position()
		pass
	
	if init:
		draw_reflect()
	
	queue_redraw()


func kill() -> void:
	RenderingServer.free_rid(_viewport)
	RenderingServer.free_rid(_vpt)
	RenderingServer.free_rid(cid)


func _exit_tree() -> void:
	if init:
		kill()


func _draw() -> void:
	if Engine.is_editor_hint():
		pass
	
	draw_circle(Vector2(), 4., Color.RED, true)


func draw_reflect() -> void:
	#RenderingServer.canvas_item_clear(get_canvas_item())
	
	#RenderingServer.viewport_set_canvas_transform(
		#_viewport,
		#get_canvas(),
		#Transform2D(0., global_position)
	#)

	#RenderingServer.viewport_set_canvas_transform(
		#_viewport, get_world_2d().canvas,
		#Transform2D(
			#0., - (global_position + Vector2(reflect_region.position))
		#)
	#)
	pass
