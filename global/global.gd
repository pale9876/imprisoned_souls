extends Node


# Save Path
const DEFAULT_SAVE_DATA_PATH: String = "res://savedata/autosave.res"


# Import
const Player: Script = preload("uid://c2uxhumgng18h")
const MainScene: Script = preload("uid://cplgj2iixr7f6")
const PlayerCamera: Script = preload("uid://b7phyhue4y3yg")
const Hud: Script = preload("uid://dgntyiu05self")
const Ingame: Script = preload("uid://lf1g8r7wbov3")
const Channel: Script = preload("uid://bc33hejnp7byc")


# Scene
const PLAYER_SCENE: PackedScene = preload("uid://br4srsyh160du")

signal debug_toggled()
signal save_complete()

var data: Data

var player: Player
var player_camera: PlayerCamera
var current_data_name: String
var main_scene: MainScene


func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	player = PLAYER_SCENE.instantiate() as Player


func _enter_tree() -> void:
	get_tree().set_auto_accept_quit(false)
	
	if load_data():
		data = Data.new()


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_CLOSE_REQUEST:
			save_data()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("toggle_debug"):
		debug_toggled.emit()


func save_data(path: String = "") -> void:
	var err: Error = ResourceSaver.save(
		data, DEFAULT_SAVE_DATA_PATH if path.is_empty() else path
	)
	
	if err != OK:
		printerr("SaveError => ", err)
	else:
		print("Global Data Save Complete")
	
	save_complete.emit()


func load_data(path: String = "") -> bool:
	var exist: bool = ResourceLoader.exists(DEFAULT_SAVE_DATA_PATH if path.is_empty() else path)
	
	if exist:
		var _data := ResourceLoader.load(
			DEFAULT_SAVE_DATA_PATH if path.is_empty() else path, "Resource"
		)
		if _data:
			data = _data as Data
			print("Data Load Complete")
	
	return exist


func get_channel() -> Channel:
	return main_scene.channel


func get_ingame_scene() -> Ingame:
	return main_scene.ingame


func get_hud() -> Hud:
	return main_scene.hud



class PlayerClassData extends Resource:
	pass


class Data extends Resource:
	var class_selected: String = ""
	var achieve: Dictionary[String, bool] = { }
	var class_data: Dictionary[String, Dictionary] = {
		"Predetor" : {},
		"Executioner" : {},
		"Chimera" : {},
		"Trickster" : {},
		"Puppeteer" : {},
		"Exorcist" : {},
	}


	func add_achieved() -> void:
		pass


	func update_class_data(c_name: String, property: String, value: Variant) -> bool:
		if class_has_property(c_name, property):
			class_data[c_name][property] = value
			return true
		
		return false
	
	
	func has_class(c_name: String) -> bool:
		return class_data.has(c_name)
	
	
	func class_has_property(c_name: String, property: String) -> bool:
		if has_class(c_name):
			return class_data[c_name].has(property)
		
		return false
	

	func get_class_data(c_name: String) -> Dictionary:
		return class_data[c_name]
	
	
	func get_class_property(c_name: String, property_name: String) -> Variant:
		return class_data[c_name][property_name]
	
