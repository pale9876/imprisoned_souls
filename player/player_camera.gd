# player_camera.gd
extends Camera2D
class_name PlayerCamera


# Import


@export var time_scale: float = 2.25
@export var target: Node2D
@export var pin_offset: Vector2 = Vector2(0., - 50.)


var follow_speed: float = 100. # px/sec
var force: Vector2
var time: float
var within: Array[Node2D] = []


func _enter_tree() -> void:
	Global.player_camera = self
	
	var player := get_player()
	target = player
	global_position = player.global_position
	
	make_current()


func _exit_tree() -> void:
	target = null


func _process(_delta: float) -> void:
	if target:
		if !within.is_empty():
			var center: Vector2 = get_center_within()
			var progress: float = minf(225. / global_position.distance_to(center), 3.)
			zoom = zoom.move_toward(progress * Vector2.ONE , 10. )
		else:
			zoom = zoom.move_toward(Vector2.ONE, 10.)
		
		global_position = global_position.move_toward(
			target.global_position, follow_speed * time_scale
		) + pin_offset


func get_center_within() -> Vector2:
	var n: int = within.size() + 1
	var total: Vector2 = target.global_position
	for point: Node2D in within:
		total += point.global_position
	var result := total / n + pin_offset
	
	return result


func _physics_process(delta: float) -> void:
	if time > 0.:
		force = - force
		
		offset = offset.lerp(force, randf_range(.125, .225))
		force = force.lerp(Vector2(), randf_range(.095, .225))
		time = maxf(0., time - (delta * time_scale))



func shake(_force: Vector2, _time: float) -> void:
	force = _force
	time = _time


func get_player() -> Player:
	return Global.player
