extends Node


signal blink()


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

@onready var ingame: Ingame = %Ingame
@onready var hud: Hud = %HUD
@onready var title: Title = %Title
@onready var anim: AnimationPlayer = $AnimationPlayer


var is_in_game: bool = false
var _tresv: TReservation

func _ready() -> void:
	ingame.process_mode = Node.PROCESS_MODE_DISABLED
	
	ingame.hide()
	hud.hide()
	
	anim.play("turn_on")

	GSignal.start.connect(on_start)
	Global.main_scene = self
	
	title.show()


func on_start() -> void:
	ingame.show()
	hud.show()
	
	title.hide()

	ingame.process_mode = Node.PROCESS_MODE_INHERIT

	is_in_game = true


func transition(from: Control, to: Control) -> void:
	if _tresv:
		return
	
	_tresv = TReservation.new(from, to)
	anim.play("transition")
	
	await blink
	
	_tresv.from.visible = false
	_tresv.to.visible = true
	_tresv = null


func exec_transition() -> void:
	blink.emit()


func get_world() -> World:
	return ingame.get_world()


func _option_close() -> void:
	if !is_in_game:
		title.show()


func _option_open() -> void:
	if !is_in_game:
		title.hide()


func get_background() -> CanvasLayer:
	return get_node(^"%Background")


func get_foreground() -> CanvasLayer:
	return get_node(^"%Foreground")


func get_filter_layer() -> CanvasLayer:
	return get_node(^"FilterLayer")


func get_dialog_ui() -> DialogUI:
	return hud.dialog_ui


func get_anim() -> AnimationPlayer:
	return get_node(^"AnimationPlayer")


class TReservation:
	var from: Control
	var to: Control
	
	func _init(_from: Control, _to: Control) -> void:
		from = _from
		to = _to
	
