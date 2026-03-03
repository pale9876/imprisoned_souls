@tool
extends Resource
class_name HitboxInfo



enum Type {
	중거리 = 0,
	근거리 = 1,
	원거리 = 1 << 1,
	잡기 = 1 << 2,
}

@export var damage: float = 30.
@export_range(0.01, 1., .01) var upgrade_value: float = .1
@export_flags("근거리", "원거리") var type: int = 0:
	set(value):
		type = value
