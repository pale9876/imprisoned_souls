@tool
extends Node2D
class_name EndekaRenderer


# HACK
# 매 렌더링 프레임마다 Z값에 따라 EndekaRenderItem을 내림차순으로 정렬하고
# EndekaRenderItem 오브젝트들을 드로우합니다.
# 성능에 문제가 있는지는 아직 확인되지 않았습니다. (있기는 하겠지)


var objects: Array[EndekaRenderItem] = []


func _process(_delta: float) -> void:
	pass


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_READY:
			objects = []
			for node: Node in get_children():
				if node is EEAD2D:
					add_obj(node.eri)

		NOTIFICATION_PROCESS:
			pass

		NOTIFICATION_DRAW:
			RenderingServer.canvas_item_clear(get_canvas_item())

			if objects.size() > 1:
				_sort_by_z()

				for obj: EndekaRenderItem in objects:
					draw_obj(obj)


func add_obj(res: EndekaRenderItem) -> void:
	if objects.has(res): return
	
	RenderingServer.canvas_item_set_parent(res.ci_rid, get_canvas_item())
	
	objects.push_back(res)


func remove_obj(res: EndekaRenderItem) -> void:
	if !objects.has(res): return
	
	objects.erase(res)


func draw_obj(obj: EndekaRenderItem) -> void:
	if obj.texture:
		RenderingServer.canvas_item_add_texture_rect(
			get_canvas_item(),
			Rect2(obj.xform.origin - (obj.texture.get_size() / 2.), obj.texture.get_size()),
			obj.texture
		)


func _sort_by_z() -> void:
	objects.sort_custom(
		func(a: EndekaRenderItem, b: EndekaRenderItem) -> bool:
			return a.z < b.z
	)


func z_asc(a: EndekaRenderItem, b: EndekaRenderItem) -> bool:
	return a.z < b.z
