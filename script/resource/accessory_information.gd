@tool
extends Resource
class_name AccessoryInformation


@export_group("Meta")
@export var name: StringName
@export_multiline() var description: String
@export_multiline() var stat_description: String

@export_group("Resource")
@export var icon: Texture2D
@export var texture: Texture2D
@export var scene: PackedScene
@export var additional_stat: AEIndexStatInformation
