@tool
extends EditorInspectorPlugin
class_name CollideInfoEditorPlugin


const COLLIDER_DISABLED_COLOR: Color = Color(0.41, 0.332, 0.303, 0.471)
const COLLIDER_ENABLED_COLOR: Color = Color(0.548, 0.74, 0.689, 0.471)

const NOTIFICATION_COLLIDER_INFO_UPDATED: int = 21100


#func _can_handle(obj: Object) -> bool:
	#return is_unit(obj) or is_hurtbox(obj)
#
#
#func is_hurtbox(obj: Object) -> bool:
	#return obj is Hurtbox
#
#
#func is_unit(obj: Object) -> bool:
	#return obj is ManganiaUnit2D
#
#
#func _parse_property(
		#obj: Object,
		#type: Variant.Type,
		#name: String,
		#hint_type: PropertyHint,
		#hint_string: String,
		#usage_flags: int,
		#wide: bool
	#) -> bool:
#
	#if (obj is ManganiaUnit2D) or (obj is Hurtbox):
		#if name == "collider":
			#var multi_shape_property: MultiShapeProperty = MultiShapeProperty.new(obj)
			#add_property_editor(name, multi_shape_property)
			#
			#return true
#
	#return false
#
#
#class MultiShapeProperty extends EditorProperty:
	#const NOTIFICATION_PROPERTY_VALUE_CHANGED: int = 2001
	#
	#var edit: Object
	#
	#var _window: MultiShapeEditorWindow
	#var show_editor_btn: Button = Button.new()
	#var property_container: VBoxContainer
	#var add_collide_info_btn: Button = Button.new()
#
	#func edit_can_handle() -> bool:
		#if edit:
			#return (edit is ManganiaUnit2D)
		#return false
#
	#func has_info(res: CollideInfo) -> bool:
		#var result: int = property_container.get_children().find_custom(
			#func(node: Node) -> bool:
				#if node is HBoxContainer:
					#return node.get_info() == res
				#return false
		#)
		#
		#return result != -1
#
	#func _init(obj: Object) -> void:
		#edit = obj
		#
		#show_editor_btn.text = "View Info"
		#
		#add_child(show_editor_btn)
		#add_focusable(show_editor_btn)
		#
		#show_editor_btn.button_up.connect(_show_editor_btn_pressed)
		#_window = MultiShapeEditorWindow.new()
		#
		#var back_margin: MarginContainer = MarginContainer.new()
		#var scroll_container: ScrollContainer = ScrollContainer.new()
		#var margin_container: MarginContainer = MarginContainer.new()
		#var vbox_container: VBoxContainer = VBoxContainer.new()
#
		#add_child(_window)
		##_window.add_child(scroll_container)
		#_window.add_child(back_margin)
		#back_margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		#back_margin.size_flags_vertical = Control.SIZE_EXPAND_FILL
		#back_margin.add_child(scroll_container)
		#scroll_container.add_child(margin_container)
		#margin_container.add_child(vbox_container)
#
		## Set Margin
		#margin_container.add_theme_constant_override("margin_top", 5)
		#margin_container.add_theme_constant_override("margin_left", 5)
		#margin_container.add_theme_constant_override("margin_bottom", 5)
		#margin_container.add_theme_constant_override("margin_right", 5)
		#margin_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		#margin_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
#
		## Set VBox
		#vbox_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		#vbox_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
#
		#add_collide_info_btn.button_up.connect(
			#_add_collider_btn_pressed
		#)
		#add_collide_info_btn.text = "Add Collide Info"
		#add_collide_info_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		#
		## Set property container
		#property_container = VBoxContainer.new()
		#property_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		#property_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
		#vbox_container.add_child(property_container)
		#vbox_container.add_child(add_collide_info_btn)
#
#
	#func _notification(what: int) -> void:
		#match what:
			#NOTIFICATION_PROPERTY_VALUE_CHANGED:
				#pass
				#
			#NOTIFICATION_COLLIDER_INFO_UPDATED:
				#if edit:
					#if edit is ManganiaUnit2D:
						#edit.notification(ManganiaUnit2D.NOTIFICATION_COLLIDER_CHANGED)
					#elif edit is Hurtbox:
						#edit.notification(Hurtbox.NOTIFICATION_COLLIDER_CHANGED)
#
#
	#func _show_editor_btn_pressed() -> void:
		#_window.popup_centered(Vector2i(820, 360))
#
#
	#func clear_properties() -> void:
		#if property_container.get_child_count() > 0:
			#for node: Node in property_container.get_children():
				#node.queue_free()
#
#
	#func _update_property() -> void:
		#if edit_can_handle():
			#clear_properties()
			#
			#for res: CollideInfo in edit.collider:
				##if !res or has_info(res): continue
				#
				#var background_rect: ColorRect = ColorRect.new()
				#var margin_container: MarginContainer = MarginContainer.new()
				#var info_container: HBoxContainer = HBoxContainer.new()
				#
				##info_container.res = res
				#
				## Create CollideInfo Hbox Container
				#margin_container.add_child(background_rect)
				#background_rect.color = COLLIDER_DISABLED_COLOR if res.disabled else COLLIDER_ENABLED_COLOR
				#background_rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
				#background_rect.size_flags_vertical = Control.SIZE_EXPAND_FILL
				#margin_container.add_child(info_container)
				#info_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
				#property_container.add_child(margin_container)
				#
				#margin_container.add_theme_constant_override("margin_top", 5)
				#margin_container.add_theme_constant_override("margin_left", 5)
				#margin_container.add_theme_constant_override("margin_bottom", 5)
				#margin_container.add_theme_constant_override("margin_right", 5)
				##margin_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
				#
				## Set CollideInfo Name
				#var shape_name_edit: LineEdit = LineEdit.new()
				#shape_name_edit.text = res.name
				#shape_name_edit.placeholder_text = "CollideName"
				#shape_name_edit.text_submitted.connect(
					#func(new_text: String) -> void:
						#res.name = new_text
						#print("collide info name changed")
				#)
				#info_container.add_child(shape_name_edit)
				#
				#var shape_rid_label: Label = Label.new()
				#info_container.add_child(shape_rid_label)
				#shape_rid_label.text = str(res._shape)
				#
				#var pos_value_edits: Array[SpinBox] = set_vector_value(info_container, res.position, "Position")
				#var pos_x_edit: SpinBox = pos_value_edits[0]
#
				#pos_x_edit.value_changed.connect(
					#func(value: float) -> void: res.position = Vector2(value, res.position.y)
				#)
				#
				#var pos_y_edit: SpinBox = pos_value_edits[1]
				#pos_y_edit.value_changed.connect(
					#func(value: float) -> void: res.position = Vector2(res.position.x, value)
				#)
				#
				##set_data(hbox, "Size", res.size)
				#var size_value_edits: Array[SpinBox] = set_vector_value(info_container, res.size, "Size")
				#var size_x_edit: SpinBox = size_value_edits[0]
				#size_x_edit.value_changed.connect(
					#func(value: float) -> void: res.size = Vector2(value, res.size.y)
				#)
				#var size_y_edit: SpinBox = size_value_edits[1]
				#size_y_edit.value_changed.connect(
					#func(value: float) -> void: res.size = Vector2(res.size.x, value)
				#)
				#
#
				#var toggle_changed: Callable = func(toggle: bool, property: StringName, message: String) -> void:
					#res.set(property, toggle)
					#print(message)
#
				#var disabled_checkbox: CheckBox = set_toggle(info_container, "Disabled", res.disabled)
				#disabled_checkbox.toggled.connect(
					#func(toggle: bool) -> void:
						#res.disabled = toggle
						#background_rect.color = COLLIDER_DISABLED_COLOR if toggle else COLLIDER_ENABLED_COLOR
						#print("Collide info disabled toggle Changed")
				#)
				#
				#var delete_btn: Button = Button.new()
				#delete_btn.text = "Delete"
				#delete_btn.button_up.connect(
					#func() -> void:
						#if edit.collider.has(res): edit.collider.erase(res)
						#margin_container.queue_free.call_deferred()
				#)
				#info_container.add_child(delete_btn)
#
		#notification(NOTIFICATION_COLLIDER_INFO_UPDATED)
#
#
	#func set_toggle(at: Control, value_name: String, value: bool) -> CheckBox:
		#var checkbox: CheckBox = CheckBox.new()
#
		#checkbox.text = value_name
		#checkbox.button_pressed = value
#
		#at.add_child(checkbox)
		#
		#return checkbox
#
#
	#func set_vector_value(at: Control, value: Vector2, label_text: String) -> Array[SpinBox]:
		#var vector_hbox: HBoxContainer = HBoxContainer.new()
		#var vector_label: Label = Label.new()
		#vector_label.text = label_text
		#vector_hbox.add_child(vector_label)
		#
		#var arr: Array[SpinBox] = []
		#
		#for i: int in range(2):
			#var spin_box: SpinBox = SpinBox.new()
			#
			#spin_box.update_on_text_changed = true
			#spin_box.suffix = "X" if i == 0 else "Y"
			#spin_box.allow_greater = true
			#spin_box.allow_lesser = true
			#spin_box.step = .01
			#spin_box.value = value.x if i == 0 else value.y
			#vector_hbox.add_child(spin_box)
			#
			#arr.push_back(spin_box)
#
		#at.add_child(vector_hbox)
		#
		#return arr
#
#
	#func _add_collider_btn_pressed() -> void:
		#if edit is ManganiaUnit2D:
			##edit.create_collider(&"new_collider")
			#
			## clear infos
			#
			#_update_property()
			#print("collide info updated")
#
#
	#class MultiShapeEditorWindow extends PopupPanel:
		#func _init() -> void:
			#title = "Multi Shape Editor"
		#
		#func _notification(what: int) -> void:
			#match what:
				#NOTIFICATION_ENTER_TREE:
					#pass
				#
				#NOTIFICATION_WM_CLOSE_REQUEST:
					#print("MultiShape (Collider Info) Editor Closed")
