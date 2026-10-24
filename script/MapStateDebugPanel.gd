extends MenuButton


@export var target_map: Map


func _init() -> void:
	var popup_item := get_popup()
	popup_item.id_pressed.connect(
		func(id: int) -> void:
			text = popup_item.get_item_text(id)
			target_map.change_state(id)
	)




	
