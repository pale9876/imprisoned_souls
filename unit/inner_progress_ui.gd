@tool
extends Node2D
class_name GradientProgress2D

@export var PROGRESS_SHADER: ShaderMaterial
@export var TRAUMA_SHADER: ShaderMaterial

@export var under_color: Color = Color(0.077, 0.107, 0.16, 1.0)
@export var gradient: GradientTexture1D
@export var progress_color: Color = Color(0.813, 0.016, 0.016, 1.0)
@export var trauma_color: Color = Color(0.322, 0.449, 0.67, 1.0)
@export var over_color: Color = Color.WHITE
@export var height: float = 8.

@export_category("Progress")
@export_range(0., 1., .001) var value: float = 1.
@export var trauma_value: float = 1.
@export var progress_curve: Curve
@export var trauma_curve: Curve


var under_cid: RID
var trauma_progress_cid: RID
var progress_cid: RID
var over_cid: RID

var init: bool = false
@export_tool_button("Create", "2D") var _create: Callable = create


func _enter_tree() -> void:
	if !Engine.is_editor_hint():
		create()


func create() -> void:
	if init:
		kill()
		init = false
	
	under_cid = RenderingServer.canvas_item_create()
	trauma_progress_cid = RenderingServer.canvas_item_create()
	progress_cid = RenderingServer.canvas_item_create()
	over_cid = RenderingServer.canvas_item_create()

	RenderingServer.canvas_item_set_parent(under_cid, get_canvas_item())
	RenderingServer.canvas_item_set_parent(trauma_progress_cid, get_canvas_item())
	RenderingServer.canvas_item_set_parent(progress_cid, get_canvas_item())
	RenderingServer.canvas_item_set_parent(over_cid, get_canvas_item())

	RenderingServer.canvas_item_add_rect(
		under_cid,
		Rect2(- Vector2(float(gradient.width), height) / 2., Vector2(float(gradient.width), height)),
		under_color
	)
	
	RenderingServer.canvas_item_add_texture_rect(
		trauma_progress_cid,
		Rect2(-Vector2(float(gradient.width), height) / 2., Vector2(float(gradient.width), height)),
		gradient.get_rid(),
	)
	RenderingServer.canvas_item_set_modulate(trauma_progress_cid, trauma_color)
	RenderingServer.canvas_item_set_material(trauma_progress_cid, TRAUMA_SHADER.get_rid())
	
	
	RenderingServer.canvas_item_add_texture_rect(
		progress_cid,
		Rect2(- Vector2(float(gradient.width), height) / 2., Vector2(float(gradient.width), height)),
		gradient.get_rid()
	)
	RenderingServer.canvas_item_set_material(progress_cid, PROGRESS_SHADER.get_rid())
	RenderingServer.canvas_item_set_modulate(progress_cid, progress_color)
	
	# Draw Over Texture
	RenderingServer.canvas_item_add_polyline(
		over_cid,
		PackedVector2Array([
			Vector2(- Vector2(float(gradient.width), height) / 2.),
			Vector2((Vector2(float(gradient.width), height) / 2.).x, (- Vector2(float(gradient.width), height) / 2.).y),
			Vector2(Vector2(float(gradient.width), height) / 2.),
			Vector2(- (Vector2(float(gradient.width), height) / 2.).x, (Vector2(float(gradient.width), height) / 2.).y),
			Vector2(- Vector2(float(gradient.width), height) / 2.)
		]),
		[over_color],
		1.
	)
	
	init = true


func change_value(val: float) -> void:
	if val < 0. or val > 1.: return
	
	var progress_tween: Tween = create_tween()
	var trauma_tween: Tween = create_tween()
	
	progress_tween.tween_property(
		self, "value", val, .75
	).set_custom_interpolator(
		func(_val: float) -> float:
			var result: float = progress_curve.sample_baked(_val)
			PROGRESS_SHADER.set_shader_parameter("progress", value)
			return result
	)
	
	trauma_tween.tween_property(
		self, "trauma_value", val, 1.
	).set_custom_interpolator(
		func(_val: float) -> float:
			var result: float = trauma_curve.sample_baked(_val)
			TRAUMA_SHADER.set_shader_parameter("progress", trauma_value)
			return result
	)


func kill() -> void:
	RenderingServer.free_rid(under_cid)
	RenderingServer.free_rid(progress_cid)
	RenderingServer.free_rid(over_cid)
	RenderingServer.free_rid(trauma_progress_cid)


func _exit_tree() -> void:
	if init:
		kill()
