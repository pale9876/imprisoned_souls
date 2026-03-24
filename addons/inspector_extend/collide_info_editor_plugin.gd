@tool
extends EditorInspectorPlugin
class_name CollideInfoEditorPlugin


const NOTIFICATION_COLLIDER_INFO_UPDATED: int = 21100


func _can_handle(obj: Object) -> bool:
	return is_unit(obj) or is_hurtbox(obj)


func is_hurtbox(obj: Object) -> bool:
	return obj is Hurtbox


func is_unit(obj: Object) -> bool:
	return obj is ManganiaUnit2D


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
			var multi_shape_property: MultiShapeProperty = MultiShapeProperty.new(obj)
			add_property_editor(name, multi_shape_property)
			
			return true

	return false


class MultiShapeProperty extends EditorProperty:
	const NOTIFICATION_PROPERTY_VALUE_CHANGED: int = 2001
	
	var edit: Object
	
	var _window: MultiShapeEditorWindow
	var show_editor_btn: Button = Button.new()
	var property_container: VBoxContainer

	func _init(obj: Object) -> void:
		edit = obj
		
		show_editor_btn.text = "View Info"
		
		add_child(show_editor_btn)
		add_focusable(show_editor_btn)
		
		show_editor_btn.button_up.connect(_show_editor_btn_pressed)
		_window = MultiShapeEditorWindow.new()

		var scroll_container: ScrollContainer = ScrollContainer.new()
		var margin_container: MarginContainer = MarginContainer.new()

		_window.add_child(margin_container)
		margin_container.add_child(scroll_container)
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
		if edit is ManganiaUnit2D:
			for res: CollideInfo in edit.collider:
				# Create CollideInfo Hbox Container
				var info_container: CollideInfoContainer = CollideInfoContainer.new()
				info_container.res = res
				property_container.add_child(info_container)
				
				# Set CollideInfo Name
				var shape_name_edit: LineEdit = LineEdit.new()
				shape_name_edit.text = res.name
				shape_name_edit.placeholder_text = "CollideName"
				shape_name_edit.text_submitted.connect(
					func(new_text: String) -> void:
						info_container.res.name = new_text
						print("collide info name changed")
				)
				info_container.add_child(shape_name_edit)
				
				var shape_rid_label: Label = Label.new()
				info_container.add_child(shape_rid_label)
				shape_rid_label.text = str(res._shape)
				
				#Set Position Data
				var pos_value_edits: Array[LineEdit] = set_vector_value(info_container, res.position, "Position")
				var pos_x_edit: LineEdit = pos_value_edits[0]
				var vec2_value_changed: Callable = func(new_text: String, property: StringName, xy: bool, message: String = "") -> void:
					if new_text.is_valid_float():
						res.set(
							property, Vector2(new_text.to_float(), res.get(property).y) if xy else Vector2(res.get(property).x, new_text.to_float())
						)
						
						print(message)

				var toggle_changed: Callable = func(toggle: bool, property: StringName) -> void:
					pass

				pos_x_edit.text_submitted.connect(
					vec2_value_changed.bind(&"position", true, "collider info position X value changed")
				)
				
				var pos_y_edit: LineEdit = pos_value_edits[1]
				pos_y_edit.text_submitted.connect(
					vec2_value_changed.bind(&"position", false, "collider info position Y value changed")
				)
				
				
				#set_data(hbox, "Size", res.size)
				var size_value_edits: Array[LineEdit] = set_vector_value(info_container, res.size, "Size")
				var size_x_edit: LineEdit = size_value_edits[0]
				size_x_edit.text_submitted.connect(
					vec2_value_changed.bind(&"size", true, "collider info size X value changed")
				)
				var size_y_edit: LineEdit = size_value_edits[1]
				size_y_edit.text_submitted.connect(
					vec2_value_changed.bind(&"size", false, "collider info size Y value changed")
				)
				
				#set_data(hbox, "Disabled", res.disabled)
				var disabled_checkbox: CheckBox = set_toggle(info_container, "Disabled", res.disabled)
				disabled_checkbox.toggled.connect(
					func(toggle: bool) -> void:
						pass
				)

		var add_collider_btn: Button = Button.new()
		add_collider_btn.text = "Add Collider"
		add_collider_btn.button_up.connect(_add_collider_btn_pressed)
		property_container.add_child(add_collider_btn)


	func set_toggle(at: Control, value_name: String, value: bool) -> CheckBox:
		var checkbox: CheckBox = CheckBox.new()

		checkbox.text = value_name
		checkbox.button_pressed = value

		at.add_child(checkbox)
		
		return checkbox


	func set_vector_value(at: Control, value: Vector2, label_text: String) -> Array[LineEdit]:
		var vector_hbox: HBoxContainer = HBoxContainer.new()
		var vector_label: Label = Label.new()
		vector_label.text = label_text
		vector_hbox.add_child(vector_label)
		
		var vector_x_edit: LineEdit = LineEdit.new()
		vector_x_edit.placeholder_text = "X"
		vector_x_edit.text = str(value.x)
		vector_hbox.add_child(vector_x_edit)

		var vector_y_edit: LineEdit = LineEdit.new()
		vector_y_edit.placeholder_text = "Y"
		vector_y_edit.text = str(value.y)
		vector_hbox.add_child(vector_y_edit)

		at.add_child(vector_hbox)
		
		return [vector_x_edit, vector_y_edit]


	func _add_collider_btn_pressed() -> void:
		if edit is ManganiaUnit2D:
			edit.collider.push_back(
				edit.create_collider(&"new_collider")
			)
			# clear infos
			_update_property()
			print("collide info updated")


	class CollideInfoContainer extends HBoxContainer:
		var res: CollideInfo = null
		
		func get_info() -> CollideInfo:
			return res


	class MultiShapeEditorWindow extends PopupPanel:
		func _init() -> void:
			title = "Multi Shape Editor"
		
		func _notification(what: int) -> void:
			match what:
				NOTIFICATION_ENTER_TREE:
					pass
				
				NOTIFICATION_WM_CLOSE_REQUEST:
					print("MultiShape (Collider Info) Editor Closed")
