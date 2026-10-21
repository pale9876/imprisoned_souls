@tool
extends Sprite2D
class_name GroundGradient


const SAFE: Color = Color("587aff")
const DANGER: Color = Color(0.62, 0.11, 0.129, 1.0)
const EVENT: Color = Color(0.587, 0.373, 0.83, 1.0)


const _STATE: Dictionary[String, Color] = {
	"SAFE" : SAFE,
	"DANGER" : DANGER,
	"EVENT" : EVENT,
}


@export_enum("SAFE", "DANGER", "EVENT") var state: String = "SAFE":
	set(type):
		state = type
		change_state(state)

@export var width: int = 64
@export var height: int = 64


var _color: Color = Color("587aff"):
	set(color):
		_color = color
		(texture as GradientTexture2D).gradient.colors = [
			Color.WHITE, _color, Color.TRANSPARENT
		]


var _tween: Tween



func _init() -> void:
	var grad_texture := GradientTexture2D.new()
	grad_texture.gradient = Gradient.new()
	
	grad_texture.gradient.offsets = PackedFloat32Array([0., .1, 1.])
	grad_texture.gradient.colors = [Color.WHITE, _STATE[state], Color.TRANSPARENT]
	grad_texture.width = width
	grad_texture.height = height
	grad_texture.fill_from = Vector2()
	grad_texture.fill_to = Vector2(0., 1.)
	
	texture = grad_texture


func change_state(_state: String, color: Color = Color.TRANSPARENT) -> void:
	if _STATE.has(state):
		_tween = create_tween()
		_tween.tween_property(
			self, "_color", _STATE[state], .45
		).set_ease(Tween.EASE_IN_OUT)
	else:
		_tween = create_tween()
		_tween.tween_property(
			self, "_color", color, .45
		).set_ease(Tween.EASE_IN_OUT)
	


	
