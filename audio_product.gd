@tool
extends Node


var listener: Listener = null


func get_distance_to_listener(from: Vector2) -> float:
	return from.distance_to(listener.position)


func get_sound_direction(emitter_pos: Vector2) -> Vector2:
	return listener.direction_to(emitter_pos)
