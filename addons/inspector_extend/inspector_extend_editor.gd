@tool
extends EditorInspectorPlugin


var _window: MultiShapeEditorWindow
var _editor: Control


func _can_handle(object: Object) -> bool:
	return object is ManganiaUnit2D


func _parse_property(
		obj: Object,
		type: Variant.Type,
		name: String,
		hint_type: PropertyHint,
		hint_string: String,
		usage_flags: int,
		wide: bool
	) -> bool:
	
	if obj is ManganiaUnit2D:
		if name == "collider":
			add_property_editor(name, MultiShapeEditor.new())
			return true
	
	return false


class MultiShapeEditorWindow extends Window:

	func _init() -> void:
		title = "Multi Shape Editor"
		initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_MAIN_WINDOW_SCREEN
	
	func _notification(what: int) -> void:
		match what:
			NOTIFICATION_ENTER_TREE:
				pass
			
			NOTIFICATION_WM_CLOSE_REQUEST:
				pass

class MultiShapeEditor extends EditorProperty:
	var show_editor_btn: Button = Button.new()


	func _init() -> void:
		add_child(show_editor_btn)
		add_focusable(show_editor_btn)
		show_editor_btn.button_up.connect(_show_editor_btn_pressed)


	func _show_editor_btn_pressed() -> void:
		pass
