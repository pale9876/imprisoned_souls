extends Node2D
class_name TraitorMustBeDead


@export var player: Player
@export var legion: Legion
@export var ingame_canvas: CanvasLayer

@onready var start_btn: Button = %Start
@onready var title: CanvasLayer = %Title

func _ready() -> void:
	ingame_canvas.process_mode = Node.PROCESS_MODE_DISABLED
	legion.target = player
	
	start_btn.pressed.connect(start)


func start() -> void:
	ingame_canvas.process_mode = Node.PROCESS_MODE_INHERIT
	title.hide()


func end() -> void:
	ingame_canvas.process_mode = Node.PROCESS_MODE_DISABLED
