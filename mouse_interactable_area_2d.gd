@tool
extends Node2D
class_name MouseInteractableArea2D


const IMAGE_PLACEHOLDER: Texture2D = preload("uid://bcx1k44j24ime")


const NOTIFICATION_MOUSE_ENTERED: int = 1500
const NOTIFICATION_MOUSE_EXITED: int = 1501
const NOTIFICATION_MOUSE_CLICKED: int = 1502
const _NOTIFICATION_MOUSE_CLICK_RELEASED: int = 1503
const NOTIFICATION_MOUSE_DRAGGED: int = 1504


@export var texture: Texture2D

@export var size: Vector2 = Vector2(10., 10.)
@export var color: Color = Color(0.0, 0.627, 0.639, 0.376)

var _shape: Shape2D

var _mouse_enter: bool = false
var _click: bool = false


# OVERRIDE
func _process(delta: float) -> void:
	pass

# OVERRIDE
func _physics_process(delta: float) -> void:
	pass


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENTER_TREE:
			_shape = RectangleShape2D.new()
			_shape.size = size
		
		NOTIFICATION_PROCESS:
			var result: bool = _shape.get_rect().has_point(
				get_viewport().get_mouse_position()
			)
			_is_mouse_entered(result)

			if _mouse_enter:
				if DisplayServer.mouse_get_button_state() & MOUSE_BUTTON_LEFT:
					_is_mouse_clicked(true)
				else:
					_is_mouse_clicked(false)

		NOTIFICATION_MOUSE_ENTERED:
			if Engine.is_editor_hint(): return
			#print("mouse entered")
			pass
		
		NOTIFICATION_MOUSE_EXITED:
			#print("mouse exited")
			pass

		NOTIFICATION_MOUSE_CLICKED:
			#print("mouse clicked")
			pass

		_NOTIFICATION_MOUSE_CLICK_RELEASED:
			#print("mouse _click released")
			pass

		NOTIFICATION_MOUSE_DRAGGED:
			print("mouse dragged")
			pass


		NOTIFICATION_DRAG_BEGIN:
			pass


func _is_mouse_entered(toggle: bool) -> bool:
	if _mouse_enter != toggle:
		_mouse_enter = toggle
		if toggle:
			notification(NOTIFICATION_MOUSE_ENTERED)
		else:
			notification(NOTIFICATION_MOUSE_EXITED)
	
	return _mouse_enter


func _is_mouse_clicked(state: bool) -> bool:
	if _click != state:
		_click = state
		if state:
			notification(NOTIFICATION_MOUSE_CLICKED)
		else:
			notification(_NOTIFICATION_MOUSE_CLICK_RELEASED)

	return _click


func _draw() -> void:
	var canvas_item_rid: RID = get_canvas_item()
	
	if texture:
		pass
	
	if _shape:
		_shape.draw(canvas_item_rid, color)
		#RenderingServer.canvas_item_add_texture_rect(
			#canvas_item_rid,
		#)
