# shudder.gd
extends AEIndex


@export var atk_increase: int = 40
@export_range(0., 1., .01) var increase_motion_speed: float = .05


func _enter_tree() -> void:
	activate()


func activate() -> void:
	stat.atk = atk_increase
	stat.motion_speed = increase_motion_speed


	
