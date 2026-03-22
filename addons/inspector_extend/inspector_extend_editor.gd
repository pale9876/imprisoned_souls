@tool
extends EditorInspectorPlugin
class_name InspectorExtendPlugin


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
			var data: Array = obj.collider
			var multi_shape_property: MultiShapeProperty = MultiShapeProperty.new(obj, data)
			add_property_editor(name, multi_shape_property)
			
			return true

	return false


class MultiShapeProperty extends EditorProperty:
	const NOTIFICATION_PROPERTY_VALUE_CHANGED: int = 2001
	
	var _window: MultiShapeEditorWindow

	var show_editor_btn: Button = Button.new()

	var edit: Object
	var data: Variant

	var property_container: VBoxContainer

	func _init(obj: Object, _data: Variant = null) -> void:
		edit = obj
		if _data: data = _data
		show_editor_btn.text = "View Info"
		
		add_child(show_editor_btn)
		add_focusable(show_editor_btn)
		
		show_editor_btn.button_up.connect(_show_editor_btn_pressed)
		_window = MultiShapeEditorWindow.new()

		var margin_container: MarginContainer = MarginContainer.new()

		_window.add_child(margin_container)
		add_child(_window)
		
		margin_container.add_theme_constant_override("margin_top", 5)
		margin_container.add_theme_constant_override("margin_left", 5)
		margin_container.add_theme_constant_override("margin_bottom", 5)
		margin_container.add_theme_constant_override("margin_right", 5)
		
		property_container = VBoxContainer.new()
		margin_container.add_child(property_container)
		


	func _notification(what: int) -> void:
		match what:
			NOTIFICATION_PROPERTY_VALUE_CHANGED:
				pass


	func _show_editor_btn_pressed() -> void:
		_window.popup_centered(Vector2i(400, 400))
		



	func clear_properties() -> void:
		for node: Node in property_container.get_children():
			node.queue_free()


	func _update_property() -> void:
		clear_properties()

		if data is Array:
			for res: Variant in data:
				if res is CollideInfo:
					var hbox: HBoxContainer = HBoxContainer.new()
					property_container.add_child(hbox)
					
					set_data(hbox, "Name", res.name)
					
					var label: Label = Label.new()
					hbox.add_child(label)
					label.text = str(res.shape_rid)
					
					set_data(hbox, "Position", res.position)
					set_data(hbox, "Size", res.size)
					set_data(hbox, "Disabled", res.disabled)
		
		var add_collider_btn: Button = Button.new()
		property_container.add_child(add_collider_btn)
		add_collider_btn.text = "Add Collider"
		add_collider_btn.button_up.connect(_add_collider_btn_pressed)

	func _add_collider_btn_pressed() -> void:
		if edit is ManganiaUnit2D:
			edit.collider.push_back(
				edit.create_collider(&"NewCollider")
			)
			_update_property()
			print("updated")


	func set_data(attr_container: HBoxContainer, v_name: String, value: Variant) -> void:
		var line_edit: LineEdit = LineEdit.new()
		line_edit.placeholder_text = v_name
		if value:
			line_edit.text = str(value)
		attr_container.add_child(line_edit)


	class MultiShapeEditorWindow extends PopupPanel:
		func _init() -> void:
			title = "Multi Shape Editor"
		
		func _notification(what: int) -> void:
			match what:
				NOTIFICATION_ENTER_TREE:
					pass
				
				NOTIFICATION_WM_CLOSE_REQUEST:
					print("MultiShape (Collider Info) Editor Closed")
