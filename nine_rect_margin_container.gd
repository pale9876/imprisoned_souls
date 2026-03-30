@tool
extends MarginContainer
class_name NinePatchMarginContainer

#const PLACEHOLDER: Texture2D = preload("uid://bcvaoqgahiygm")

enum Margin
{
	LEFT,
	TOP,
	RIGHT,
	BOTTOM,
}


@export var texture: Texture2D:
	set(tex):
		texture = tex
		update_texture()
		queue_redraw()


@export_custom(PROPERTY_HINT_NONE, "", PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_READ_ONLY)
var _region: Rect2


@export_group("Margin")

@export var _margin_left: int = 0:
	set(value):
		_margin_left = value
		set_margin(Margin.LEFT, value)
		queue_redraw()

@export var _margin_top: int = 0:
	set(value):
		_margin_top = value
		set_margin(Margin.TOP, value)
		queue_redraw()

@export var _margin_right: int = 0:
	set(value):
		_margin_right = value
		set_margin(Margin.RIGHT, value)
		queue_redraw()

@export var _margin_bottom: int = 0:
	set(value):
		_margin_bottom = value
		set_margin(Margin.BOTTOM, value)
		queue_redraw()


var canvas_rid: RID

func set_margin(type: Margin, value: int) -> void:
	var _str: String = ""
	
	if value < 0: return
	
	match type:
		Margin.LEFT:
			_str = "margin_left"
		Margin.TOP:
			_str = "margin_top"
		Margin.RIGHT:
			_str = "margin_right"
		Margin.BOTTOM:
			_str = "margin_bottom"
	
	add_theme_constant_override(_str, value)


func update_texture() -> void:
	if texture:
		var texture_size: Vector2 = texture.get_image().get_size()
		_region.size = texture_size



func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENTER_TREE:
			canvas_rid = get_canvas_item()

		NOTIFICATION_RESIZED:
			queue_redraw()


func _draw() -> void:
	if texture:
		var canvas_rect: Rect2 = Rect2(Vector2.ZERO, size)
		var top_left: Vector2 = Vector2(_margin_left, _margin_top)
		var bottom_right: Vector2 = Vector2(_margin_bottom, _margin_right)
		
		RenderingServer.canvas_item_add_nine_patch(
			canvas_rid,
			canvas_rect,
			Rect2(Vector2(), texture.get_size()),
			texture.get_rid(),
			top_left,
			bottom_right,
			RenderingServer.NINE_PATCH_STRETCH,
			RenderingServer.NINE_PATCH_STRETCH,
			false,
			#COLOR()
		)
