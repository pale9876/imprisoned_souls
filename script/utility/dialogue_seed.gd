extends RefCounted
class_name DialogSeed


var dice: float = 0.


func _init() -> void:
	randomize()
	dice = randf()
	
