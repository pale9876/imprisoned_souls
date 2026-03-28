@tool
extends EditorPlugin


var popup: PopupPanel

var authorization: ChzzkAuthorization


func _enter_tree() -> void:
	popup = PopupPanel.new()
	EditorInterface.get_editor_main_screen().add_child(popup)
	
	authorization = ChzzkAuthorization.new()
	authorization.state = create_state()
	
	create_popup()

	add_tool_menu_item("Chzzk Api", func() -> void: popup_window())


func _exit_tree() -> void:
	remove_tool_menu_item("Chzzk Api")

	if popup:
		popup.queue_free()


func create_popup() -> void:
	var margin_container: MarginContainer = MarginContainer.new()
	
	popup.add_child(margin_container)
	
	margin_container.add_theme_constant_override("margin_top", 5)
	margin_container.add_theme_constant_override("margin_left", 5)
	margin_container.add_theme_constant_override("margin_bottom", 5)
	margin_container.add_theme_constant_override("margin_right", 5) 

	var vbox_container: VBoxContainer = VBoxContainer.new()
	vbox_container.alignment = BoxContainer.ALIGNMENT_CENTER
	
	var client_id_edit: LineEdit = LineEdit.new()
	client_id_edit.text_changed.connect(
		func(text: String) -> void:
			authorization.clientId = text
	)

	var client_secret_edit: LineEdit = LineEdit.new()
	client_secret_edit.text_changed.connect(
		func(text: String) -> void:
			authorization.clientSecret = text
	)

	var uri_edit: LineEdit = LineEdit.new()
	uri_edit.text_changed.connect(
		func(text: String) -> void:
			authorization.redirectUri = text
	)

	client_id_edit.placeholder_text = "Client Id"
	client_secret_edit.placeholder_text = "Client Secret"
	uri_edit.placeholder_text = "Redirect URI"

	margin_container.add_child(vbox_container)
	
	vbox_container.add_child(client_id_edit)
	vbox_container.add_child(client_secret_edit)
	vbox_container.add_child(uri_edit)


func _request_access_token() -> Error:
	var http_client: HTTPClient = HTTPClient.new()
	
	var headers: PackedStringArray = []
	
	var body: String = http_client.query_string_from_dict(
		{
			"clientId" : ""
		}
	)
	
	var error: Error = http_client.request(
		HTTPClient.METHOD_GET, "", headers, body
	)
	
	return OK



func popup_window() -> void:
	popup.popup_centered(Vector2i(480, 120))


func create_state() -> String:
	var result: String = ""
	var str_range: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
	
	for i: int in range(12):
		result += str_range[randi_range(0, str_range.length() - 1)]
	
	return result
