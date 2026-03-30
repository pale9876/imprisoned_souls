@tool
extends Node2D
class_name EEAD2D


@export var texture: Texture2D
@export var z_value: float:
	set(value):
		z_value = value
		if eri:
			eri.z = value


var eri: EndekaRenderItem


func _process(delta: float) -> void:
	pass


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENTER_TREE:
			eri = EndekaRenderItem.new()
			eri.texture = texture
			eri.ci_rid = RenderingServer.canvas_item_create()
			eri.z = z_value
			eri.xform = get_transform()
			

		NOTIFICATION_TRANSFORM_CHANGED:
			if eri: eri.xform = get_transform()


		NOTIFICATION_EXIT_TREE:
			RenderingServer.free_rid(eri.ci_rid)
