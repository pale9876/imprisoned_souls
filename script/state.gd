extends RefCounted
class_name Debite


signal face_changed()


var face: Vector2i = Vector2i.RIGHT:
	set(value):
		if value != face:
			face = value if value.x != 0. else Vector2i(face.x, value.y)
			face_changed.emit()


var direction: Vector2 = Vector2():
	set(value):
		if direction != value:
			direction = value
