@tool
extends Resource
class_name SkillInformation

@export var enable: bool = false
@export var name: StringName
@export var icon: Texture
@export_multiline var description: String
@export var ae_index_scene: PackedScene
