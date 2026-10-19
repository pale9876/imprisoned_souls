@tool
extends PointLight2D
class_name HallwayLight


@export_range(8, 512, 1) var _width: int = 512:
	set(val):
		_width = val
		(texture as GradientTexture2D).width = _width

@export_range(8, 512, 1) var _height: int = 512:
	set(val):
		_height = val
		(texture as GradientTexture2D).height = _height

@export var _scale: float = 1.:
	set(val):
		_scale = maxf(.001, val)
		texture_scale = _scale


func _init() -> void:
	var gradient_2d := GradientTexture2D.new()
	gradient_2d.gradient = Gradient.new()
	
	gradient_2d.gradient.offsets = [0., .75]
	gradient_2d.gradient.colors = [Color.WHITE, Color.TRANSPARENT]
	gradient_2d.width = _width
	gradient_2d.height = _height
	gradient_2d.fill = GradientTexture2D.FILL_RADIAL
	gradient_2d.fill_from = Vector2(.5, .5)
	gradient_2d.fill_to = Vector2(1., 0.)
	
	texture = gradient_2d



	
