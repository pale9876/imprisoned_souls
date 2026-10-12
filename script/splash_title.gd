extends Control
class_name SplashTitle


const DEFAULT_SAVE_PATH: String = "res://splash_img.jpg"



func _ready() -> void:
	var img := await get_splash_img()
	
	img.save_jpg(
		DEFAULT_SAVE_PATH, 1.
	)


func get_splash_img() -> Image:
	await RenderingServer.frame_post_draw
		
	var img := get_viewport().get_texture().get_image()
	return img
