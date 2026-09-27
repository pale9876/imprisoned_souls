extends Node


# Import
const Channel: Script = preload("uid://bc33hejnp7byc")
const Ingame: Script = preload("uid://lf1g8r7wbov3")
const Option: Script = preload("uid://b6wu325meysae")
const Title: Script = preload("uid://dtu3imugbu0pm")
const Hud: Script = preload("uid://dgntyiu05self")
const DialogUI: Script = preload("uid://borjea45xky04")
#const StartMap: Script = preload("uid://di5e7qxe7d0dj")
const World = preload("uid://dpn1opeegcme2")


# Scenes
#const START_MAP: PackedScene = preload("uid://ccd41t1qrjttn")

@onready var ingame: Ingame = $Ingame
@onready var hud: Hud = $HUD
#@onready var option: Option = $Option
@onready var channel: Channel = $Channel
@onready var title: Title = %Title


var is_in_game: bool = false


func _ready() -> void:
	ingame.process_mode = Node.PROCESS_MODE_DISABLED
	
	ingame.hide()
	hud.hide()
	channel.hide()
	
	title.turn_on()

	GSignal.start.connect(on_start)
	Global.main_scene = self


func on_start() -> void:
	ingame.show()
	hud.show()
	
	title.hide()
	channel.hide()

	ingame.process_mode = Node.PROCESS_MODE_INHERIT
	
	
	#var start_map := START_MAP.instantiate() as StartMap
	#ingame.add_child(start_map)
	#ingame.add_child(Global.player_camera)
	Global.player_camera.target = Global.player
	var init_map: Map = ingame.get_world().init_map
	init_map.add_unit(Global.player)
	Global.player.global_position = init_map.get_start_spawn_position().global_position
	Global.player.input_state.unlock()
	
	is_in_game = true


func get_world() -> World:
	return ingame.get_world()


func _option_close() -> void:
	if !is_in_game:
		title.show()
	
	#option.hide()


func _option_open() -> void:
	if !is_in_game:
		title.hide()
	#option.show()


func get_dialog_ui() -> DialogUI: return hud.dialog_ui
