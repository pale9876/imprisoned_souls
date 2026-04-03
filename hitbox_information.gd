@tool
extends CollideInfo
class_name HitboxInformation



enum Type {
	NONE = 0,
	근거리 = 1,
	원거리 = 1 << 1,
	잡기 = 1 << 2,
}

@export var damage: int = 30
@export var type: Type = Type.NONE
@export_range(0.01, 1., .01) var upgrade_value: float = .1
