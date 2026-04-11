@tool
extends Resource
class_name UnitInformation


@export var name: String = ""
@export var icon: Texture2D
@export var speed: float = 200.
@export var weight: float = 1.
@export_range(0., 2., 0.01) var dash_scale: float = 1.5
@export var jump_force: float = 350.
@export var acceleration: float = 3350.
@export var friction: float = 2250.
@export var collider: Dictionary[String, Vector2] = {"idle" : Vector2(10., 10.)}
