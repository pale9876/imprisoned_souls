@tool
extends EEAD2D
class_name ColorGenerateTestScreen


@export var gradient: GradientTexture1D
@export var size: Vector2i = Vector2(256, 126)
@export var guideline_margin: float = 15.


var background_cid: RID
var generator_cid: RID
var guideline_cid: RID


func create_gradient(width: int) -> GradientTexture1D:
	var texture: GradientTexture1D = GradientTexture1D.new()
	
	texture.gradient = Gradient.new()
	texture.gradient.interpolation_mode = Gradient.GRADIENT_INTERPOLATE_CONSTANT
	
	var offsets: PackedFloat32Array = []
	var colors: PackedColorArray = []
	
	offsets.resize(7)
	colors.resize(7)
	
	for i: int in range(7):
		offsets[i] = float(i) * (1. / 7.)
	
	colors[0] = Color.WHITE
	colors[1] = Color.YELLOW
	colors[2] = Color.GREEN_YELLOW
	colors[3] = Color.PURPLE
	colors[4] = Color.RED
	colors[5] = Color.BLUE
	colors[6] = Color.BLACK
	
	texture.gradient.offsets = offsets
	texture.gradient.colors = colors
	texture.width = width
	
	return texture


func create() -> void:
	if init: kill()
	
	gradient = create_gradient(size.x)
	
	background_cid = RenderingServer.canvas_item_create()
	generator_cid = RenderingServer.canvas_item_create()
	guideline_cid = RenderingServer.canvas_item_create()
	
	RenderingServer.canvas_item_set_parent(background_cid, get_canvas_item())
	RenderingServer.canvas_item_set_parent(generator_cid, get_canvas_item())
	RenderingServer.canvas_item_set_parent(guideline_cid, get_canvas_item())

	RenderingServer.canvas_item_add_rect(
		background_cid, Rect2(Vector2(), Vector2(size)), Color.BLACK
	)
	
	RenderingServer.canvas_item_add_texture_rect(
		generator_cid, Rect2(Vector2(), Vector2(float(size.x), float(size.y) / 3. * 2.)), gradient
	)
	
	var circle: PackedVector2Array = PackedVector2Array()
	circle.resize(65)
	var radius: float = (float(size.y) - guideline_margin) / 2.
	for i: int in range(64):
		circle[i] = Vector2.from_angle(TAU / float(64) * float(i)) * radius
	circle[64] = circle[0]
	
	RenderingServer.canvas_item_set_transform(
		guideline_cid, Transform2D(0., Vector2(float(size.x) / 2., float(size.y / 2.)))
	)
	RenderingServer.canvas_item_add_polyline(
		guideline_cid, circle, [], .5, false
	)
	RenderingServer.canvas_item_add_line(
		guideline_cid, - Vector2.from_angle(PI) * radius, Vector2.from_angle(PI) * radius, Color.WHITE, .5, false
	)
	RenderingServer.canvas_item_add_line(
		guideline_cid, Vector2.UP * radius, Vector2.DOWN * radius, Color.WHITE, .5, false
	)
	
	init = true


func kill() -> void:
	RenderingServer.free_rid(guideline_cid)
	RenderingServer.free_rid(generator_cid)
	RenderingServer.free_rid(background_cid)
	
	init = false
