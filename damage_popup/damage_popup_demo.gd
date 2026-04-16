@tool
extends EEAD2D


@export var damage_popup_information: DamagePopupInformation


@export_tool_button("Test", "2D") var _test: Callable = test


var popup_module: PopupModule
var popup: DamagePopup


func _process(delta: float) -> void:
	if !Engine.is_editor_hint():
		if Input.is_action_just_pressed("click"):
			var mouse_pos: Vector2 = get_global_mouse_position()
			damage_popup_create(30, mouse_pos)


func test() -> void:
	damage_popup_create(30, Vector2())


func damage_popup_create(value: int, pos: Vector2) -> void:
	if popup:
		RenderingServer.free_rid(popup.cid)
		
	var text_server: TextServer = TextServerManager.get_primary_interface()
	
	popup = DamagePopup.new()
	popup.cid = RenderingServer.canvas_item_create()
	RenderingServer.canvas_item_set_parent(popup.cid, get_canvas_item())
	
	popup.text_shape = text_server.create_shaped_text(TextServer.Direction.DIRECTION_LTR, TextServer.ORIENTATION_HORIZONTAL)
	text_server.shaped_text_add_string(
		popup.text_shape, str(value), damage_popup_information.font.get_rids(), damage_popup_information.size
	)
	
	var text_size: Vector2 = text_server.shaped_text_get_size(popup.text_shape)
	
	text_server.shaped_text_draw(
		popup.text_shape, popup.cid, pos + (text_size / 2. * Vector2(-1., .5)), -1., -1., Color.RED
	)
	text_server.shaped_text_draw_outline(
		popup.text_shape, popup.cid, pos + (text_size / 2. * Vector2(-1., .5)), -1., -1., 2, Color.WHITE
	)


class TextPopup:
	pass
