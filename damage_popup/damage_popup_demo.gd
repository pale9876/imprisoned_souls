@tool
extends EEAD2D


@export var damage_popup_information: DamagePopupInformation


@export_tool_button("Test", "2D") var _test: Callable = test


var popup_module: PopupModule
var popup: DamagePopup


func _physics_process(delta: float) -> void:
	if !Engine.is_editor_hint():
		if Input.is_action_just_pressed("click"):
			var mouse_pos: Vector2 = get_global_mouse_position()
			damage_popup_create(30, mouse_pos)


func test() -> void:
	damage_popup_create(30, Vector2())


func damage_popup_create(value: int, pos: Vector2, color: Color = Color.WHITE, outline_color: Color = Color.RED) -> void:
	if popup:
		popup.kill()
		
	var text_server: TextServer = TextServerManager.get_primary_interface()
	
	popup = DamagePopup.new()
	popup.cid = RenderingServer.canvas_item_create()
	popup.text_shape = text_server.create_shaped_text(TextServer.Direction.DIRECTION_LTR, TextServer.ORIENTATION_HORIZONTAL)
	popup.scale_curve = damage_popup_information.scale_tween
	popup.parabola = damage_popup_information.parabola
	
	RenderingServer.canvas_item_set_interpolated(popup.cid, false)
	
	text_server.shaped_text_add_string(
		popup.text_shape, str(value),
		damage_popup_information.font.get_rids(), damage_popup_information.size
	)
	
	text_server.shaped_text_draw(
		popup.text_shape, popup.cid,
		Vector2(), #pos + (text_size / 2. * Vector2(-1., .5)),
		-1., -1., Color.RED, 1.
	)
	
	text_server.shaped_text_draw_outline(
		popup.text_shape, popup.cid,
		Vector2(), #pos + (text_size / 2. * Vector2(-1., .5)),
		-1., -1., 2, Color.WHITE, 1.
	)
	
	var text_size: Vector2 = text_server.shaped_text_get_size(popup.text_shape)
	
	RenderingServer.canvas_item_set_parent(popup.cid, get_canvas_item())
	RenderingServer.canvas_item_set_transform(
		popup.cid, Transform2D(0., pos + (text_size / 2. * Vector2(-1., .5)))
	)

	var tween: Tween = create_tween()
	tween.tween_property(
		popup, "size", Vector2(), popup.duration
	).set_custom_interpolator(
		func(val: float) -> float:
			var result: float = popup.parabola.sample_baked(val)
			RenderingServer.canvas_item_set_transform(
				popup.cid, Transform2D(0., Vector2.ONE * result, 0., pos)
			)
			return result
	)
	
	await tween.finished
	
	popup.kill()
