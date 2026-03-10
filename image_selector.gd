@tool
extends Node

# 툴 전용 스크립트.
# 인스펙터상 이미지를 불러옵니다.

var file_dialog: ImageFileDialog = null


func _notification(what: int) -> void:
	pass


func open_file_dialog() -> void:
	file_dialog = ImageFileDialog.new( FileDialog.FILE_MODE_OPEN_FILE )
	
	EditorInterface.popup_dialog_centered(
		file_dialog, Vector2i( 640, 480 )
	)


func editor_get_image() -> Array[Texture2D]:
	var result: Array[Texture2D] = []
	
	open_file_dialog()
	
	await file_dialog.select_finished
	
	if !file_dialog.result.is_empty():
		for path: String in file_dialog.result:
			var res: Resource = ResourceLoader.load(path)
			if res is Texture2D:
				result.push_back(res)
	
	file_dialog.queue_free.call_deferred()
	
	return result


func get_rect_image() -> void:
	
	pass


func get_file_dialog() -> EditorFileDialog: return file_dialog


class ImageFileDialog extends EditorFileDialog:
	signal select_finished()
	
	var result: PackedStringArray = []
	
	
	func _init(mode: FileMode) -> void:
		access = FileDialog.ACCESS_RESOURCES
		file_mode = mode
		filters = ["*.jpg", "*.png", "*.jpeg", "*.webp"]

		file_selected.connect(_on_file_selected)
		files_selected.connect(_on_files_selected)
	
	
	func _on_file_selected(path: String) -> void:
		if !path.is_empty():
			result.push_back(path)
		select_finished.emit()
	
	
	func _on_files_selected(paths: PackedStringArray) -> void:
		result = paths
		select_finished.emit()
