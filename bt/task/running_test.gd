extends BTAction




func _enter() -> void:
	#var player = blackboard.get_var(&"bt_player")
	#player.last_task = self
	
	#print("이건 한 번 이상 출력되면 안 되는 것")
	print(get_root().get_task_name())


func _tick(delta: float) -> Status:
	print("돌아가고 있는 중")
	
	return RUNNING


func _exit() -> void:
	pass
