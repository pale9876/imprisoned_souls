@tool
extends TextureRect
class_name RecoloredTextureRect


const REPLACE_COLOR_SHADER: Shader = preload("uid://ctmcbltwyxhgv")


@export var tolerance: float = .1:
	set(val):
		tolerance = val
		(material as ShaderMaterial).set_shader_parameter(&"tolerance", val)

@export var prev_color: Color = Color.BLACK:
	set(_color):
		prev_color = _color
		(material as ShaderMaterial).set_shader_parameter(&"prev_color", _color)

@export var new_color: Color = Color.BLACK:
	set(_color):
		new_color = _color
		(material as ShaderMaterial).set_shader_parameter(&"new_color", _color)



func _init() -> void:
	var _material := ShaderMaterial.new()
	_material.shader = REPLACE_COLOR_SHADER

	material = _material







	
