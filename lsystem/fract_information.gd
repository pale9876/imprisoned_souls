@tool
extends Resource
class_name FractInformation


@export var axiom: String = "F+F+F+F"
@export var rules: Dictionary[String, String] = {
	"F": "F+F-F-FF+F+F-F",
	"X": "F-[[X]+X]+F[+FX]-X"
}
@export_range(1, 5, 1) var step: int = 3
@export var init_pos: Vector2 = Vector2()
@export var direction: Vector2 = Vector2.UP:
	set(value):
		direction = value
	get:
		return direction if direction.is_normalized() else direction.normalized()
@export var colors: Dictionary[String, Color] = {
	"F": Color.AQUA,
}
@export var length: float = 50.
@export var turn_angle: float = 90.
@export var line_color: Color = Color.WHITE
