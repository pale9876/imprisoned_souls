# portrait.gd
@tool
extends PortraitPartsGroup
class_name Portrait


const _HIDDEN: Color = Color(18.892, 18.892, 18.892, 1.0)
const _RELIEVED: Color = Color(1.0, 1.0, 1.0, 1.0)


enum State {
	IDLE,
	HURT,
	INJURY,
	DEAD,
}


const IDLE := State.IDLE


@export var _hidden: bool = false:
	set(toggle):
		_hidden = toggle
		if Engine.is_editor_hint():
			if is_node_ready():
				if toggle:
					hide_unit()
				else:
					relieved()


@export var state: State = IDLE


func change_state(_state: State) -> void:
	pass


@export_tool_button("Add Group", "Control")
var _add_group: Callable = func() -> void:
	var control := create_parts_group(self)
	add_child(control)
	control.owner = self


func relieved() -> void:
	get_unit_texture().modulate = _RELIEVED


func hide_unit() -> void:
	get_unit_texture().modulate = _HIDDEN


func get_unit_texture() -> Control:
	return get_node(^"Unit") as Control


static func create_parts_group(_owner: Control, _name: StringName = &"") -> Control:
	var control := Control.new()
	if !_name.is_empty():
		control.name = _name
	return control



	
