@tool
extends Resource
class_name AnimatedPart


@export var name: String = ""
@export var texture: AtlasTexture
@export var frame_size: Vector2 = Vector2(64., 64.)
@export var frame: int = 0:
	set = set_frame
@export var size: Vector2 = Vector2(32., 32.)
@export var max_force: float = 300.
@export var min_force: float = 100.
@export var direction: Vector2 = Vector2(1., -1.)
@export var angle_range: float = 30.
@export_range(0., 1., .001) var friction: float = .155
@export_range(0., 1., .001) var bounce: float = .235

# [0]: start frame, [1]: end frame, [2]: start progress
@export var animation: Dictionary[String, Array] = {
	"idle" : [0, 0, 0],
	"roll" : [1, 4, 3],
}

@export_flags_2d_physics var mask: int = 1


func set_frame(value: int) -> void:
	frame = value
	
	if texture:
		texture.region = Rect2(
			Vector2(frame_size.x * float(value), 0.), frame_size
		)
