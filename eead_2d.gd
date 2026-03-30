@tool
extends Node2D
class_name EEAD2D


const NOTIFICATION_Z_INDEX_CHANGED: int = 57000


@export var texture: Texture2D
@export var z_value: float:
	set(value):
		z_value = value
		if eri:
			eri.z = value
		notification(NOTIFICATION_Z_INDEX_CHANGED)


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


		NOTIFICATION_Z_INDEX_CHANGED:
			var parent: Node = get_parent()
			
			if parent:
				if parent is EndekaRenderer:
					var _arr: Array[EndekaRenderItem] = parent.objects.duplicate(true)
					var _idx: int = parent.objects.find(eri)
					
					_arr.sort_custom(parent.z_asc)
					
					var _new_idx: int = _arr.find(eri)
					
					if _idx != _new_idx:
						parent.queue_redraw()
