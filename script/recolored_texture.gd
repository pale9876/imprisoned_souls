@tool
extends TextureRect
class_name RecoloredTextureRect


const REPLACE_COLOR: Shader = preload("uid://ctmcbltwyxhgv")


@export var tolerance: float = .55:
	set(val):
		tolerance = val
		(material as ShaderMaterial).set_shader_parameter(&"tolerance", val)

@export var prev_color: Color:
	set(_color):
		prev_color = _color
		prev_color

@export var new_color: Color:
	set(_color):
		new_color = _color
		



func _init() -> void:
	if !material:
		material = ShaderMaterial.new()
		material.shader = REPLACE_COLOR.duplicate()


	
