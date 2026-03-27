#@tool
#extends BTPlayer
#class_name EmoteBTModule
#
#
#signal state_changed(str: String)
#
#
#const 유휴: String = "유휴"
#const 패닉: String = "패닉"
#const 공포: String = "공포"
#const 고양됨: String = "고양됨"
#
#var state: String = "유휴"
#
#
#func change_state(str: String) -> void:
	#state = str
	#state_changed.emit(str)
