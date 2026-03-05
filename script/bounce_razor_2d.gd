@tool
extends Line2D
class_name BouncableLazer2D


@export var emit: bool = false

@export var init_force: float = 1000.0
@export var direction: Vector2 = - Vector2.ONE.normalized()
@export var margin: float = .001
@export var bound: int = 2
@export_flags_2d_physics var mask: int


var _force: float = 0.


func _enter_tree() -> void:
	_force = init_force



func _set_emit(toggle: bool) -> void:
	emit = toggle
	queue_redraw()


func _physics_process(_delta: float) -> void:
	var mouse_point: Vector2 = Vector2.ZERO
	var _from: Vector2 = global_position
	
	if !Engine.is_editor_hint():
		if Input.is_action_just_pressed("mouse_left"):
			mouse_point = get_global_mouse_position()
			direction = global_position.direction_to(mouse_point)
			emit = true
			clear_points()
		
			var start_point: Vector2 = to_local(global_position)
			add_point(start_point)
	
	if emit:
		while true:
			var _to: Vector2 = _from + direction * _force
			
			var param: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(
				_from,
				_to,
				mask
			)

			var result: Dictionary = get_world_2d().direct_space_state.intersect_ray(param)
			
			if result:
				var collide_point: Vector2 = result["position"]
				var _dist = _from.distance_to(collide_point)
				_force -= _dist
				var local_point: Vector2 = to_local(collide_point)
				add_point(local_point)
				_from = collide_point
				
				var _normal: Vector2 = result["normal"]
				direction = direction.bounce(_normal)
				_from += Vector2.ONE.normalized() * .001 * direction
			else:
				_force = 0.
				_from = _to
				add_point(to_local(_from))
			
			if _force <= 0.:
				_force = init_force
				break
	
		emit = false

func _draw() -> void:
	draw_circle(Vector2.ZERO, 10., Color.WHITE)
