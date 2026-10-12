@tool
extends Control
class_name PortraitUnit



@export var _hidden: bool = false:
	set(toggle):
		_hidden = toggle
		if is_node_ready():
			for _texture: RecoloredTextureRect in get_textures():
				(_texture.material as ShaderMaterial).set_shader_parameter(
					&"new_color", Color.WHITE
				)

@export var group: Dictionary[String, TextureColoringGroupInformation]



func get_textures() -> Array[RecoloredTextureRect]:
	var _arr: Array[RecoloredTextureRect] = []
	_arr.assign(find_children("", "RecoloredTextureRect", true, false))
	return _arr




	
