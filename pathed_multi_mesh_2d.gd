@tool
extends Path2D
class_name PathedMultiMesh2D


@export var texture: Texture
@export var multimesh: MultiMesh

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENTER_TREE:
			pass

		
		NOTIFICATION_EXIT_TREE:
			pass


		NOTIFICATION_DRAW:
			pass
