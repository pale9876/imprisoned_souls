extends Node2D
class_name TraitorMustBeDead


@export var player: Player
@export var legion: Legion
@export var ingame_canvas: CanvasLayer
@export var camera: MultiCamera

@onready var start_btn: Button = %Start
@onready var title: CanvasLayer = %Title
@onready var character_icon: CharacterProfile = %CharacterIcon
@onready var hp_progress: GradientProgress2D = %HpProgress

func _ready() -> void:
	ingame_canvas.process_mode = Node.PROCESS_MODE_DISABLED
	legion.target = player
	player.transform = Transform2D(0., Vector2(640., 360.) / 2.)
	character_icon.texture = player.unit_information.icon
	
	
	start_btn.pressed.connect(start)


func start() -> void:
	ingame_canvas.process_mode = Node.PROCESS_MODE_INHERIT
	title.hide()
	
	camera.add_cam(
		"Player", player.global_position, 1., player, Color(0.398, 0.428, 0.48, 0.271)
	)
	
	camera.current = "Player"


func end() -> void:
	ingame_canvas.process_mode = Node.PROCESS_MODE_DISABLED
