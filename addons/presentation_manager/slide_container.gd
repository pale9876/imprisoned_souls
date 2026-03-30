@tool
extends Control
class_name SlideContainer


var screens: Array[Control] = []


@export var _slide_tween_curve: Curve = Curve.new()
@export var _progress: float = 0.


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_CHILD_ORDER_CHANGED:
			screens = []
			
			var childs: Array[Control] = []
			
			for node: Node in get_children():
				if node is Control:
					childs.push_back(node)
			screens = childs
			
			_update()

		NOTIFICATION_RESIZED:
			_update()


func _update() -> void:
	var pos: Vector2 = global_position

	for i: int in range(screens.size()):
		var current: Control = screens[i]
		screens[i].set_size(self.get_size())
		screens[i].set_global_position(pos)
		pos.x += size.x
