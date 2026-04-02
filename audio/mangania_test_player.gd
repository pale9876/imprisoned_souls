@tool
extends ManganiaUnit2D


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	var input_vector: Vector2 = Input.get_vector("left", "right", "up", "down")

	if input_vector != Vector2():
		_move(input_vector.normalized() * 300. * delta)
