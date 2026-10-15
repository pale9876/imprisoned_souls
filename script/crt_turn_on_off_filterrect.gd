@tool
extends FilterRect
class_name CRTTurnOnOffFilter


const CRT_TURN_ON_OFF_SHADER: Shader = preload("uid://dxn8hlrd3ett5")


@export_range(0., 1., .01) var progress: float:
	set(val):
		progress = val
		(material as ShaderMaterial).set_shader_parameter(&"progress", val)


func _init() -> void:
	shader = CRT_TURN_ON_OFF_SHADER
	progress = 0.
