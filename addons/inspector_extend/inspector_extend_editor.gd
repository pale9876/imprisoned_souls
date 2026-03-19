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
			add_property_editor(name, MultiShape.new())
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


class MultiShape extends EditorProperty:
	var show_editor_btn: Button = Button.new()

	func _init() -> void:
		add_child(show_editor_btn)
		add_focusable(show_editor_btn)
		show_editor_btn.button_up.connect(_show_editor_btn_pressed)


	func _show_editor_btn_pressed() -> void:
		pass


class MultishapeEditor extends Control:
	
	var property_conatiner: PropsContainer = null

	func ready() -> void:
		var margin_container: MarginContainer = MarginContainer.new()
		add_child(margin_container)
		margin_container.set_anchors_preset(Control.PRESET_FULL_RECT)
		
		var vbox: VBoxContainer = VBoxContainer.new()
		margin_container.add_child(vbox)
		
		var props_container: PropsContainer = PropsContainer.new()
		property_conatiner = props_container
		vbox.add_child(props_container)
		
	class PropsContainer extends HBoxContainer:
		var data: Dictionary
