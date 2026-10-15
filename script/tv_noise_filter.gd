@tool
extends FilterRect
class_name TVNoiseFilter


const NOISE_SHADER: Shader = preload("uid://ba4s1slehob3e")


@export_range(0., 1., .001) var alpha: float:
	set(val):
		alpha = val
		if material:
			(material as ShaderMaterial).set_shader_parameter("alpha", val)

@export var _toggle: bool = false:
	set(tog):
		_toggle = tog
		visible = tog


func _init() -> void:
	shader = NOISE_SHADER
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	color = Color.BLACK
	alpha = .12


	
