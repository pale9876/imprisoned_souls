# title.gd
extends CanvasLayer


signal turn_offed()


func _init() -> void:
	visible = false
	
	visibility_changed.connect(
		func () -> void:
			if visible:
				turn_on()
			else:
				turn_off()
	)
	
	


func _enter_tree() -> void:
	turn_on()
	


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_CLOSE_REQUEST:
			turn_off()


func turn_on() -> void:
	get_anim().play(&"turn_on")


func turn_off() -> void:
	var anim := get_anim()
	anim.play(&"turn_off")
	
	await anim.animation_finished
	turn_offed.emit()



func _input(event: InputEvent) -> void:
	get_main_title_viewport().push_input(event)


func get_anim() -> AnimationPlayer:
	return get_node(^"AnimationPlayer")



func get_main_title_viewport() -> SubViewport:
	return get_node(^"%TitleViewport")
