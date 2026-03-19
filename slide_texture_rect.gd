@tool
extends Control
class_name SlideTextureRect


const NOTIFICATION_TEXTURE_ADDED: int = 1000
const NOTIFICATION_TEXTURE_CLEARED: int = 1001

signal texture_changed()

@export var transition_curve: Curve = Curve.new()
@export var auto_slide: bool = false
@export var time: float = 3.
var _time: float = .0


@export_custom(PROPERTY_HINT_ARRAY_TYPE, "", PROPERTY_USAGE_DEFAULT)
var _texture: Array[Texture2D]

@warning_ignore("unused_private_class_variable")
@export_tool_button("Add texture", "Texture2D")
var _add_texture_btn: Callable = _editor_add_texture

@warning_ignore("unused_private_class_variable")
@export_tool_button("Clear Textures", "Node")
var _clear_btn: Callable = _clear


@export var offset: float = 0.:
	get: return abs(offset)
	set(value):
		offset = value
		queue_redraw()


var _hold: bool = false


func _process(delta: float) -> void:
	pass


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_MOUSE_EXIT:
			_hold = false
		
		NOTIFICATION_ENTER_TREE:
			_time = time
		
		NOTIFICATION_PROCESS:
			var _delta: float = get_process_delta_time()

			if auto_slide:
				_time -= _delta

			if _time < 0.:
				_time = time
				_slide_next()
		
			if Engine.is_editor_hint(): return
			_hold = DisplayServer.mouse_get_button_state() == MOUSE_BUTTON_LEFT and !auto_slide

		NOTIFICATION_DRAW:
			var canvas_item_rid: RID = get_canvas_item()
			RenderingServer.canvas_item_clear(canvas_item_rid)
			
			if !_texture.is_empty():
				# draw texture
				var current_idx: int = int(offset) % _texture.size()
				var bg_texture: Texture2D = _texture[current_idx]
				var target_texture: Texture2D = _texture[(current_idx + 1) % _texture.size()]
				
				RenderingServer.canvas_item_add_texture_rect_region(
					canvas_item_rid, Rect2(Vector2(), get_size()),
					bg_texture.get_rid(), Rect2(Vector2(), bg_texture.get_size()),
				)
				
				var _texture_progress: float = clampf(
					offset - floor(offset), 0., 1.
				)

				var _sz: Vector2 = get_size()
				_sz.x *= _texture_progress
				
				var target_size: Vector2 = target_texture.get_size()
				target_size.x *= _texture_progress
				
				RenderingServer.canvas_item_add_texture_rect_region(
					canvas_item_rid,
					Rect2(Vector2(), _sz),
					target_texture.get_rid(),
					Rect2(Vector2(), target_size)
				)


		NOTIFICATION_TEXTURE_ADDED:
			if Engine.is_editor_hint():
				print("Texture Added")

		NOTIFICATION_TEXTURE_CLEARED:
			if Engine.is_editor_hint():
				print("Texture Cleared")

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if _hold:
			var dragged: Vector2 = event.relative
			offset += dragged.x * .001



func _slide_next() -> void:
	var current_idx: int = int(floorf(offset))
	var next_idx: int = current_idx + 1
	
	var tween: Tween = create_tween()
	
	if transition_curve:
		tween.tween_property(
			self, "offset", float(next_idx), 1.
		).set_custom_interpolator(
			func(value: float) -> float: return transition_curve.sample_baked(value)
		)
	else:
		tween.tween_property(
			self, "offset", float(next_idx), .6
		).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	
	await tween.finished
	
	texture_changed.emit()


func _clear() -> void:
	_texture.clear()
	notification(NOTIFICATION_TEXTURE_CLEARED)
	notify_property_list_changed()


func _editor_add_texture() -> void:
	var img: Array[Texture2D] = await ImageSelector.editor_get_image()
	
	if !img.is_empty():
		for tex: Texture2D in img:
			_texture.push_back(tex)
		
		notification(NOTIFICATION_TEXTURE_ADDED)
		notify_property_list_changed()
		queue_redraw()
