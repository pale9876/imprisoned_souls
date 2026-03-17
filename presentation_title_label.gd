@tool
extends Label
class_name PresentationSceneTitleLabel


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENTER_TREE:
			if text.is_empty(): text = "Title"
			
			if !label_settings:
				label_settings = LabelSettings.new()
				label_settings.font_size = 32

			var parent: Node = get_parent()
			if parent is PresentationScene:
				pass
