@tool
extends SoundButton


# Import
const VariableStatisticsProgress: Script = preload("uid://dvcrrp6wpmrtp")
const StatAttrContainer: Script = preload("uid://5kps1ydik3il")


# Placeholder
const PLACEHOLDER_EXECUTIONER: Texture = preload("uid://clcjxox00b83s")
const PLACEHOLDER_PREDATOR: Texture = preload("uid://cw7fw44ky8xln")
const PLACEHOLDER_TRICKSTER: Texture = preload("uid://clf6um28evr5d")


@export var class_info: ClassInformation


func _init() -> void:
	super()
	class_info = ClassInformation.new()


func _enter_tree() -> void:
	if Engine.is_editor_hint(): return
	
	var ui_info := get_class_ui_info()
	get_class_label().text = ui_info.name
	get_icon().texture = ui_info.icon


func _ready() -> void:
	if Engine.is_editor_hint(): return
	
	mouse_entered.connect(
		func() -> void:
			var ui_info := get_class_ui_info()
			var meta: Dictionary[String, Variant] = class_info.get_class_meta()
			
			get_portrait().texture = ui_info.portrait
			get_class_description().text = ui_info.description
			
			for attr: String in meta:
				get_stat_attr_container().set_attr(attr, meta[attr])
	)
	
	mouse_exited.connect(
		func() -> void:
			var meta: Dictionary[String, Variant] = class_info.get_class_meta()
			
			get_portrait().texture = null
			get_class_description().text = ""
			
			for attr: String in meta:
				get_stat_attr_container().clear()
	)
	


func get_class_ui_info() -> ClassUIInfo:
	return class_info.ui_info


func get_class_label() -> Label:
	return get_node(^"%ClassLabel") as Label


func get_class_description() -> RichTextLabel:
	return get_node(^"%ClassDescription") as RichTextLabel


func get_portrait() -> TextureRect:
	return get_node(^"%ClassPortrait") as TextureRect


func get_icon() -> TextureRect:
	return get_node(^"%Icon") as TextureRect


func get_stat_attr_container() -> StatAttrContainer:
	return get_node(^"%StatAttrContainer") as StatAttrContainer


	
