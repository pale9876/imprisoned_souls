@tool
extends CollideInformation
class_name HitboxInformation


enum Type {
	NONE = 0,
	SHORT_RANGE,
	LONG_RANGE,
}

@export_category("Spec")
@export var hitrange: float = 10.
@export var damage: int = 30
@export var type: Type = Type.NONE

@export_category("Preview")
@export var duration: float = 1.
