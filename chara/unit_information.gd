@tool
extends Resource
class_name UnitInformation


@export var name: String = ""
@export var icon: Texture2D
@export_range(0, 10000, 1) var max_hp: int = 300
@export var init_hp: int = 0:
	set(value):
		init_hp = clampi(value, 0, max_hp)
@export var atk: int = 3
@export var def: int = 3
@export var speed: float = 200.
@export var atk_speed: float = 1.
@export var weight: float = 1.
@export_range(0., 2., 0.01) var dash_scale: float = 1.5
@export var jump_force: float = 350.
@export var acceleration: float = 3350.
@export var friction: float = 2250.
@export var collider: Dictionary[String, Vector2] = {"idle" : Vector2(10., 10.)}
