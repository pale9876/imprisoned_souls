@tool
extends Sprite2D
class_name DrawableArea


# Import
const BoardRect: Script = preload("uid://vopmjvwbt6nj")


@export var width: int = 432
@export var height: int = 208
@export var enable: bool = false


@onready var area_2d: Area2D = $Area2D

@onready var sub_viewport: SubViewport = $DrawBoard/SubViewportContainer/SubViewport
@onready var board_rect: BoardRect = %BoardRect


var _mouse_entered: bool = false


func _ready() -> void:
	clear()
	
	if Engine.is_editor_hint(): return
	
	area_2d.mouse_entered.connect(
		func() -> void:
			_mouse_entered = true
	)
	
	area_2d.mouse_exited.connect(
		func() -> void:
			_mouse_entered = false
	)


func get_draw_rect() -> Vector2i:
	return Vector2i(width, height)


func _input(event: InputEvent) -> void:
	if Engine.is_editor_hint(): return
	
	if enable and _mouse_entered:
		pass
		#sub_viewport.push_input(event)


func clear() -> void:
	board_rect.clear()





	
