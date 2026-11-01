# nitra_anime.gd
@tool
extends AnimationPlayer
class_name MotionLibrary


# Import
#const Player: Script = preload("uid://c2uxhumgng18h")


var freeze_frame: int = 0


func get_motion_scale() -> float:
	return Gmotion.get_player_scale() if get_parent() is Player else Gmotion.global_scale


func _enter_tree() -> void:
	if Engine.is_editor_hint(): return
	
	Gmotion.global_motion_scale_changed.connect(global_motion_scale_changed)
	
	if get_parent() is Player:
		Gmotion.player_motion_scale_changed.connect(player_motion_scale_changed)
	
	for lib: StringName in get_animation_library_list():
		remove_animation_library(lib)


func _exit_tree() -> void:
	if Engine.is_editor_hint(): return
	
	Gmotion.global_motion_scale_changed.disconnect(global_motion_scale_changed)
	
	if get_parent() is Player:
		Gmotion.player_motion_scale_changed.disconnect(player_motion_scale_changed)


func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	if freeze_frame == 0:
		if is_paused():
			play()
	else:
		freeze_frame -= 1


func player_motion_scale_changed() -> void:
	speed_scale = get_motion_scale()


func global_motion_scale_changed() -> void:
	speed_scale = get_motion_scale()

func freeze(frame: int) -> void:
	freeze_frame = maxi(frame, 0)
	pause()


func is_paused() -> bool:
	return !is_playing() and is_animation_active()


func is_freezed() -> bool:
	return freeze_frame > 0
