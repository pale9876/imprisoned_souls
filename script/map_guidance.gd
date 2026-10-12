extends Resource
class_name MapGuidance


@export var name: StringName
@export var scene: PackedScene
@export var location: Vector2i = Vector2i()
@export var size: Vector2i = Vector2i.ONE
@export var entry: Dictionary[StringName, Vector2]
@export var floor_offset: float = 8.



func get_region() -> Rect2i:
	return Rect2i(location, size)


func create_entry() -> Array[Marker2D]:
	var result: Array[Marker2D] = []
	
	for entry_name: StringName in entry:
		var marker := Marker2D.new()
		marker.position = entry[entry_name]
		marker.name = entry_name
		result.push_back(marker)
	
	return result


func create_map() -> Region:
	var _map := scene.instantiate() as Region
	_map.name = name
	_map.location = location
	_map.size = size
	
	return _map
