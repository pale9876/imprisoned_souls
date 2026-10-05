# hud.gd
extends CanvasLayer


# Import
const PlayerUI: Script = preload("uid://du3jilcytfh0y")
const DialogUI: Script = preload("uid://borjea45xky04")


func _ready() -> void:
	var player_ui := get_player_ui()
	get_player_ui().show()
	get_dialog_ui().hide()
	
	var player := Global.player
	player_ui.get_hp().set_val(player.get_hp_progress())
	player_ui.get_blood().set_val(player.get_blood())

	player.stat.damaged.connect(player_damaged)
	player.stat.healed.connect(player_healed)
	player.stat.dead.connect(player_dead)


func player_damaged() -> void:
	var player := Global.player
	var value: float = player.get_hp_progress()
	get_player_ui().get_hp().set_val(value)


func player_healed() -> void:
	var player := Global.player
	var value: float = player.get_hp_progress()
	get_player_ui().get_hp().set_val(value)


func player_use_blood() -> void:
	var player := Global.player
	get_player_ui().get_blood().set_val(player.get_blood())


func player_dead() -> void:
	get_dialog_ui().hide()
	var tween := fade_out()
	await tween.finished
	get_player_ui().hide()


func fade_out() -> Tween:
	var tween: Tween = create_tween()
	tween.tween_property(
		get_player_ui(), "modulate:a", 0., .75
	).set_ease(Tween.EASE_OUT_IN)
	return tween


func fade_in() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(
		get_player_ui(), "modulate:a", 1., .75
	).set_ease(Tween.EASE_OUT_IN)


func get_player_ui() -> PlayerUI:
	return get_node(^"%PlayerUI") as PlayerUI


func get_dialog_ui() -> DialogUI:
	return get_node(^"%DialogUI") as DialogUI




	
