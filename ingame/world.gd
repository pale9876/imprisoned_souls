# world.gd
@tool
extends Node2D


# Const
const TILE_SIZE: int = 16


# Import
const Ingame: Script = preload("uid://lf1g8r7wbov3")
const MapKeikai = preload("uid://o348jlsiq2tc")


@export var tile_size: int = TILE_SIZE
@export var init_region: Region


var guidance: Dictionary[Rect2i, Region] = {
	
}


var current_region: Array[Region] = []


func append_region(region: Region) -> void:
	current_region.push_back(region)
	set_keikai()


func region_disable(region: Region) -> void:
	current_region.erase(region)


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	for node: Node in get_children():
		if node is Region:
			if !guidance.values().has(node):
				var rect: Rect2i = node.get_region()
				guidance[rect] = node
	
	append_region(init_region)



func add(_guide: MapGuidance) -> void:
	#assert(!has_overlapped(_guide.region), "해당 맵에 겹치는 부분이 존재합니다.")
	if has_overlapped(_guide.region):
		printerr("해당 맵이 다른 맵과 겹치는 영역이 존재합니다.")
		return
	
	var region := _guide.scene.instantiate() as Region
	guidance[_guide.region] = region
	add_child(region)


func erase(_loc: Vector2i) -> void:
	var region := get_region(_loc)
	guidance.erase(region.location)
	region.queue_free()


func has_overlapped(rect: Rect2i) -> bool:
	var ks: Array[Rect2i] = guidance.keys()
	for reg: Rect2i in ks:
		if rect.intersection(reg):
			return true
	
	return false


func get_region(_loc: Vector2i) -> Region:
	for rect: Rect2i in guidance.values():
		if rect.has_point(_loc):
			return guidance[rect]
	
	return null


func clear() -> void:
	current_region.clear()


func get_ingame() -> Ingame:
	return get_parent() as Ingame


func set_keikai() -> void:
	var locs: PackedVector2Array = PackedVector2Array()
	var dests: PackedVector2Array = PackedVector2Array()
	locs.resize(current_region.size())
	dests.resize(current_region.size())
	
	for i: int in range(current_region.size()):
		var _region: Region = current_region[i]
		locs[i] = Vector2(_region.location)
		dests[i] = Vector2(_region.location + _region.size)
	
	locs.sort()
	dests.sort()
	
	var min_point: Vector2 = locs[0]
	var max_point: Vector2 = dests[0]
	
	var _left: int = int(min_point.x * tile_size)
	var _right: int = int(max_point.x * tile_size)
	var _ceil: int = int(min_point.y * tile_size)
	var _floor: int = int(max_point.y * tile_size)
	
	var val: Vector4i = Vector4i(_left, _right, _ceil, _floor)
	get_keikai().set_keikai(val)


func get_keikai() -> MapKeikai:
	return get_node(^"%Keikai") as MapKeikai
	
	
	
