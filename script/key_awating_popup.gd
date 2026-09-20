extends PopupPanel


const InputChangeOptionEditor: Script = preload("uid://dh785lhqeohnd")


func _init() -> void:
	close_requested.connect(
		func() -> void:
			var editor := get_opt_editor()
			
			if editor.get_pair() != null:
				editor.clear()
	)


func _input(event: InputEvent) -> void:
	if Engine.is_editor_hint(): return
	
	if event is InputEventKey:
		var editor := get_opt_editor()
		
		if event.is_pressed() and editor.get_pair() != null:
			editor.get_pair().change_inputmap(event)
			editor.clear()


func get_opt_editor() -> InputChangeOptionEditor:
	return get_parent() as InputChangeOptionEditor

	
