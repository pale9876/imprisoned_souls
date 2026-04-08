@tool
extends Resource
class_name BloodParticleInformation


@export var amount: int = 45

@export var max_size: float = 5.
@export var min_size: float = 1.

@export var max_force: float = 300.
@export var min_force: float = 0.

@export var direction: Vector2 = Vector2.from_angle(deg_to_rad(90.)):
	get:
		return direction.normalized() if !direction.is_normalized() else direction

@export var angle_range: float = 30.:
	set(value):
		angle_range = value


@export var curve: float = .311
@export var scale_curve: Curve
