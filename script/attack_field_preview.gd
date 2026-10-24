@tool
extends Sprite2D


enum Type {
	FIELD,
	REGION,
}

@export var type: Type = Type.FIELD
@export var width: float
@export var height: float
@export var color: Color = Color.WHITE


func _init() -> void:
	var gradient_texture_2d := GradientTexture2D.new()

	gradient_texture_2d.gradient = Gradient.new()
	



func create_field_gradient() -> Gradient:
	return Gradient.new()




	
