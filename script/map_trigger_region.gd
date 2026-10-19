extends Area2D


func _init() -> void:
	body_entered.connect(
		func(body: Node2D) -> void:
			if body is Player:
				_triggered()
	)
	
	body_exited.connect(
		func(body: Node2D) -> void:
			if body is Player:
				pass
	)


func _triggered() -> void:
	pass






	
