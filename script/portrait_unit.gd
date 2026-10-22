@tool
extends Control
class_name PortraitUnit



@export var _hidden: bool = false:
	set(toggle):
		_hidden = toggle
		if is_node_ready():
			var _container := ($SubViewportContainer as SubViewportContainer)
			_container.modulate = Color(18.892, 18.892, 18.892) if toggle else Color.WHITE


@export var group: Dictionary[String, TextureColoringGroupInformation]



func get_textures() -> Array[RecoloredTextureRect]:
	var _arr: Array[RecoloredTextureRect] = []
	_arr.assign(find_children("", "RecoloredTextureRect", true, false))
	return _arr




	
