@tool
extends Control
class_name PortraitPartsGroup


@export var _root: Control


@export_tool_button("Add Texture", "TextureRect")
var _add_texture: Callable = func() -> void:
	var texture := create_texture()
	add_child(texture)
	texture.set_owner(self if _root == null or self is Portrait else _root)
	texture.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)


static func create_texture(_name: StringName = &"") -> TextureRect:
	var texture := TextureRect.new()
	texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
	
	if !_name.is_empty():
		texture.name = _name
	
	return texture

	
