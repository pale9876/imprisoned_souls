extends Control
class_name SplashTitle



func _ready() -> void:
	await RenderingServer.frame_post_draw
	
	var img := get_viewport().get_texture().get_image().save_jpg(
		"res://splash_img.jpg", 1.
	)
