@tool
extends Sprite2D


const SHIELD_SHADER: Shader = preload("uid://bd4f5p3v3qtik")


@export_range(0., 1., .01) var progress: float = 0.


func _init() -> void:
	var _texture = GradientTexture2D.new()

	_texture.gradient = Gradient.new()
	_texture.gradient.colors = [Color.WHITE, Color.WHITE * Color.TRANSPARENT]
	_texture.width = 128
	_texture.height = 128

	texture = _texture


func play_blink(enter: Vector2) -> void:
	pass




	
