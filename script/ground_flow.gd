@tool
extends SubViewportContainer
class_name GroundFlow


const INIT_GRADIENT_TEXTURE: GradientTexture2D = preload("uid://bs8wwomedfv51")
const FIRE_FLOW: Shader = preload("uid://cqm803kpnt7h2")


@export var gradient_texture: GradientTexture2D

@export var color: Color = Color.WHITE:
	set(_color):
		color = _color
		(_texture.material as ShaderMaterial).set_shader_parameter(&"colour", _color)
@export var flow_movement: Vector2 = - Vector2.ONE:
	set(value):
		flow_movement = value
		(_texture.material as ShaderMaterial).set_shader_parameter(&"flow_movement", value)
@export var distortion_movement: Vector2 = Vector2(-.01, -.3):
	set(value):
		distortion_movement = value
		(_texture.material as ShaderMaterial).set_shader_parameter(&"distortion_movement", value)
@export_range(0., 40., .01) var normal_strength: float = 40.:
	set(value):
		normal_strength = value
		(_texture.material as ShaderMaterial).set_shader_parameter(&"normal_strength", value)
@export var distortion_strength: float = .1:
	set(value):
		distortion_strength = value
		(_texture.material as ShaderMaterial).set_shader_parameter(&"distortion_strength", value)



var _subviewport: SubViewport
var _texture: TextureRect


func _init() -> void:
	var _material := ShaderMaterial.new()
	_material.shader = FIRE_FLOW
	
	gradient_texture = INIT_GRADIENT_TEXTURE.duplicate()
	_subviewport = SubViewport.new()
	_texture = TextureRect.new()
	
	_subviewport.render_target_update_mode = SubViewport.UPDATE_WHEN_VISIBLE
	stretch = true
	
	add_child(_subviewport)
	_subviewport.add_child(_texture)
	
	_texture.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_texture.set_texture(gradient_texture)
	_texture.material = _material




	
