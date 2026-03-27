# HACK: 해당 노드가 뷰포트를 생성하고 다른 캔버스를 참조하여 텍스쳐를 생성하고 그리는 일련의 반복동작을 수행하기에
# 부하가 굉장히 많음;;;
# 장점은 셰이더를 쓰는 것보다 훨씬 더 확실함.
# 많은 반사 오프젝트가 필요할 경우에는 해당 오브젝트를 쓰는 것을 피하는 것이 좋음.


@tool
extends Node2D
class_name ReflectReplicator2D


enum Mode
{
	IDLE,
	PHYSICS,
}


@export var update_mode: Mode = Mode.PHYSICS
@export var polygon: PackedVector2Array
@export var reflect: bool = true:
	set(toggle):
		reflect = toggle

@export var reflect_region: Rect2i = Rect2i(Vector2(-100, 0), Vector2(100, 100)):
	set(region):
		reflect_region = region
		queue_redraw()

# 무한복제 현상을 피하려면 이 객체의 Visibility Layer 값과 Cull Mask 값이 같지 않아야 함.
@export_flags_2d_render var layer: int:
	set(value):
		layer = value
		visibility_layer = layer
@export_flags_2d_render var cull_mask: int


@export_group("DEBUG")
@export var debug: bool = true
@export var color: Color = Color(0.459, 0.597, 0.878, 1.0)


var _viewport: RID


# OVERRIDE
func _process(delta: float) -> void:
	pass


# OVERRIDE
func _physics_process(delta: float) -> void:
	pass


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENTER_TREE:
			if Engine.is_editor_hint(): return
			var canvas: RID = get_world_2d().canvas

			_viewport = RenderingServer.viewport_create()

			RenderingServer.viewport_set_size(_viewport, reflect_region.size.x, reflect_region.size.y)
			RenderingServer.viewport_attach_canvas(_viewport, canvas)

			RenderingServer.viewport_set_canvas_transform(
				_viewport,
				canvas,
				Transform2D(0., - (get_global_transform().origin + Vector2(reflect_region.position)))
			)

			RenderingServer.viewport_set_canvas_cull_mask(_viewport, cull_mask)

			RenderingServer.viewport_set_active(_viewport, true)


		NOTIFICATION_EXIT_TREE:
			if Engine.is_editor_hint(): return
			
			RenderingServer.free_rid(_viewport)


		NOTIFICATION_PROCESS:
			if Engine.is_editor_hint(): return
			
			if update_mode == Mode.IDLE:
				queue_redraw()


		NOTIFICATION_PHYSICS_PROCESS:
			if Engine.is_editor_hint(): return
			
			if update_mode == Mode.PHYSICS:
				queue_redraw()


		NOTIFICATION_DRAW:
			if Engine.is_editor_hint() and debug:
				draw_polyline(
					get_polygon(true), color
				)
				
				draw_rect(
					reflect_region, Color(0.81, 0.716, 0.478, 0.486)
				)

			if !Engine.is_editor_hint():
				draw_reflect()


func draw_reflect() -> void:
	if reflect:
		var canvas_item: RID = get_canvas_item()
		var _texture: RID = RenderingServer.viewport_get_texture(_viewport)

		RenderingServer.canvas_item_clear(canvas_item)

		RenderingServer.canvas_item_add_polygon(
			canvas_item,
			polygon,
			[], # Colors
			[
				Vector2(0., 0.),
				Vector2(0., 1.),
				Vector2(1., 1.),
				Vector2(1., 0.)
			],
			_texture
		)


func get_polygon(closed: bool = false) -> PackedVector2Array:
	var result: PackedVector2Array = polygon.duplicate()
	if closed:
		result.push_back(result[0])
		
	return result


#func _triangulate_polygon(_polygon : PackedVector2Array) -> PackedInt32Array:
	#var size: int = int(polygon.size() / 2.)
	#var result: PackedInt32Array = PackedInt32Array()
	#
	#for i in size - 1:
		#result.append(i)
		#result.append(size * 2 - 1 - i)
		#result.append(size * 2 - 2 - i)
		#result.append(i)
		#result.append(i + 1)
		#result.append(size * 2 - 2 - i)
	#
	#return result
