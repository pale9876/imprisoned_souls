# title.gd
extends CanvasLayer


#signal turn_offed()


@onready var title_ui: Control = %TitleUI
@onready var gate_screen: Control = %GateScreen


func _ready() -> void:
	title_ui.visible = false
	gate_screen.visible = true

	gate_screen.player_entered.connect(
		func () -> void:
			Global.main_scene.transition(gate_screen, title_ui)
	)


func get_main_title_viewport() -> SubViewport:
	return get_node(^"%TitleViewport")
