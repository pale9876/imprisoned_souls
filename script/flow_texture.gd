@tool
extends Sprite2D
class_name FlowTexture


const FLOW_SHADER: Shader = preload("uid://cqm803kpnt7h2")
const INIT_GRADIENT_TEXTURE: GradientTexture2D = preload("uid://bs8wwomedfv51")


@export var _map: Map
@export var gradient_texture: GradientTexture2D = INIT_GRADIENT_TEXTURE
@export var color: Color = Color.WHITE:
	set(_color):
		color = _color
		(_sprite.material as ShaderMaterial).set_shader_parameter(&"colour", _color)
@export var flow_movement: Vector2 = Vector2(0., -1.):
	set(value):
		flow_movement = value
		(_sprite.material as ShaderMaterial).set_shader_parameter(&"flow_movement", value)
@export var distortion_movement: Vector2 = Vector2(0., -1.2):
	set(value):
		distortion_movement = value
		(_sprite.material as ShaderMaterial).set_shader_parameter(&"distortion_movement", value)
@export_range(0., 40., .01) var normal_strength: float = 12.:
	set(value):
		normal_strength = value
		(_sprite.material as ShaderMaterial).set_shader_parameter(&"normal_strength", value)
@export var distortion_strength: float = .1:
	set(value):
		distortion_strength = value
		(_sprite.material as ShaderMaterial).set_shader_parameter(&"distortion_strength", value)


var _subviewport: SubViewport
var _sprite: Sprite2D
var _tween: Tween

func _init() -> void:
	_sprite = Sprite2D.new()
	_subviewport = SubViewport.new()
	
	var _material := ShaderMaterial.new()
	_material.shader = FLOW_SHADER
	_sprite.material = _material
	
	_sprite.centered = false
	_sprite.texture = gradient_texture
	
	_subviewport.add_child(_sprite)
	add_child(_subviewport)

	var _vt = _subviewport.get_texture()
	texture = _vt



func _enter_tree() -> void:
	if Engine.is_editor_hint(): return
	
	_map.state_changed.connect(
		func() -> void:
			var _color := _map.get_state_color()
			_tween = create_tween()
			_tween.tween_property(self, "color", _color, .55)
	)



func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		(texture as ViewportTexture).viewport_path = NodePath(^"")


	
