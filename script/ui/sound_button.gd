# sound_button.gd
@tool
extends Button
class_name SoundButton



# PLACEHOLDER (SOUNDS)
const PLACEHOLDER_MOUSE_ON: AudioStream = preload("res://placeholder/sound/Retro1.wav")
const PLACEHOLDER_MOUSE_EXIT: AudioStream = preload("res://placeholder/sound/Retro2.wav")
const PLACEHOLDER_CLICKED: AudioStream = preload("res://placeholder/sound/Retro10.wav")
const PLACEHOLDER_DOWNED: AudioStream = preload("res://placeholder/sound/Retro4.wav")
#const PLACEHOLDER_UP: AudioStream


@export var mouse_on: AudioStream = PLACEHOLDER_MOUSE_ON
@export var mouse_exit: AudioStream = PLACEHOLDER_MOUSE_EXIT
@export var clicked: AudioStream = PLACEHOLDER_CLICKED
@export var downed: AudioStream = PLACEHOLDER_DOWNED
#@export var up: AudioStream



func _init() -> void:
	if Engine.is_editor_hint(): return
	
	mouse_entered.connect(
		func() -> void:
			UISound.sound_play(mouse_on)
	)
	
	mouse_exited.connect(
		func() -> void:
			UISound.sound_play(mouse_exit)
	)
	
	button_down.connect(
		func () -> void:
			UISound.sound_play(downed)
	)
	
	#button
	button_up.connect(
		func () -> void:
			UISound.sound_play(clicked, true)
	)
	
