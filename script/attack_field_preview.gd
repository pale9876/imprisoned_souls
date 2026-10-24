@tool
extends Sprite2D


enum FieldType {
	GROUND,
	WAVE,
}


@export var type: FieldType = FieldType.GROUND:
	set(_type):
		type = _type
		texture = create_field_gradient()

@export var width: int = 64:
	set(val):
		width = val
		(texture as GradientTexture2D).width = width
		offset = Vector2(width / 2., - (height / 2.))

@export var height: int = 64:
	set(val):
		height = val
		(texture as GradientTexture2D).height = height
		offset = Vector2(width / 2., - (height / 2.))

@export var color: Color = Color.WHITE:
	set(_color):
		color = _color
		(texture as GradientTexture2D).gradient.colors = [color, color * Color.TRANSPARENT]

@export_range(-1, 1, 2) var face: int = 1:
	set(value):
		face = value

@export_range(0., 1. , .001) var progress: float = 0.:
	set(value):
		progress = value
		(texture as GradientTexture2D).gradient.offsets = [0., progress]


func _init() -> void:
	texture = create_field_gradient()


func create_field_gradient() -> GradientTexture2D:
	var _texture := GradientTexture2D.new()
	var gradient := Gradient.new()
	_texture.fill = GradientTexture2D.FILL_RADIAL
	gradient.colors = [Color.WHITE, Color.TRANSPARENT]
	
	_texture.width = width
	_texture.height = height
	
	match type:
		FieldType.WAVE:
			_texture.fill_from = Vector2(0., .5)
			_texture.fill_to = Vector2(1., .5)

		FieldType.GROUND:
			_texture.fill_from = Vector2(.5, 1.)
			_texture.fill_to = Vector2(.5, 0.)
	
	_texture.gradient = gradient
	
	return _texture


	
