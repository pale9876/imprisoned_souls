extends Node2D

@onready var marker_2d: Marker2D = $Marker2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var nav_map: RID = get_world_2d().navigation_map
	var path: PackedVector2Array = NavigationServer2D.map_get_path(
		nav_map, marker_2d.global_position, get_global_mouse_position(), true
	)
	print(path)
