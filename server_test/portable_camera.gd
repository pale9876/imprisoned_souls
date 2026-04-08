extends Camera2D





# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var put: Vector2 = Input.get_vector("left","right","up","down")
	if put != Vector2():
		global_position += put * 100. * delta

	if Input.is_action_pressed("zoom_in"):
		zoom += Vector2.ONE * delta
	elif Input.is_action_pressed("zoom_out"):
		zoom -= Vector2.ONE * delta


func _control() -> void:
	pass
