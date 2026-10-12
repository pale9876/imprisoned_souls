# foreground.gd
extends CanvasLayer
class_name Foreground


func get_fade_inout_rect() -> FadeInOutRect:
	return get_node(^"FadeinoutRect") as FadeInOutRect
