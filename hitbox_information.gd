@tool
extends CollideInfo
class_name HitboxInformation

enum Type {
	NONE = 0,
	SHORT_RANGE,
	LONG_RANGE,
}

@export var damage: int = 30
@export var type: Type = Type.NONE
