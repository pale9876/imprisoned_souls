@tool
extends ColorRect
class_name FilterRect


const INIT_COLOR: Color = Color.TRANSPARENT


@export var shader: Shader:
	set(val):
		shader = val
		var new_material := ShaderMaterial.new()
		new_material.shader = val
		material = new_material


func _init() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	color = INIT_COLOR
