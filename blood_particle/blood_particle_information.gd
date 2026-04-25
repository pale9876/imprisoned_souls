@tool
extends Resource
class_name BloodParticleInformation


@export var has_stream: bool = false
@export var amount: int = 45

@export_category("Size Range")
@export var max_size: float = 5.
@export var min_size: float = 1.

@export_category("Init Force Range")
@export var max_force: float = 300.
@export var min_force: float = 0.

@export_category("Direction")
@export var direction: Vector2 = Vector2.RIGHT:
	get:
		return direction.normalized() if !direction.is_normalized() else direction


@export var angle_range: float = 30.:
	set(value):
		angle_range = value


@export_category("Tween / Curve")
@export var curve: float = .311
@export var scale_curve: Curve = Curve.new()
