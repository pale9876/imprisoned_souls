extends Resource
class_name DamagePopupInformation

@export var font: Font
@export var size: int = 16
@export var scale_tween: Curve = Curve.new()
@export var parabola: Curve = Curve.new()
@export var peak: Vector2 = Vector2(30., -30.)
