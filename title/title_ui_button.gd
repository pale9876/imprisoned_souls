# title_ui_button.gd
@tool
extends SoundButton


@onready var anim: AnimationPlayer = $AnimationPlayer


func _init() -> void:
	super()
	if Engine.is_editor_hint(): return
	
	mouse_entered.connect(
		func() -> void:
			anim.play(&"hover")
	)
	
	mouse_exited.connect(
		func() -> void:
			pass
	)


#func _ready() -> void:
	#anim.play(&"Idle")
	#anim.animation_finished.connect(
		#func(_anim_name: StringName) -> void:
			#if _anim_name == &"":
				#pass
			#
	#)


	
