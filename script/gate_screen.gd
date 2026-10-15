@tool
extends Control


signal player_entered()


@export var offset_ratio: float = .75
@onready var enter_btn: Button = %Enter


func _ready() -> void:
	enter_btn.button_up.connect(
		func() -> void:
			player_entered.emit()
	)


func _draw() -> void:
	if !Engine.is_editor_hint(): return
	
	# draw center x
	var center_x: float = size.x / 2.
	var grid_y: float = size.y * offset_ratio
	
	draw_line(
		Vector2(center_x, 0.),
		Vector2(center_x, grid_y),
		Color.WHITE,
	)

	draw_line(
		Vector2(0., grid_y),
		Vector2(size.x, grid_y),
		Color.WHITE
	)
