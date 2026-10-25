extends Resource
class_name WeaponInformation


@export var name: StringName
@export var icon: Texture2D
@export_multiline() var description: String
@export var type: GlobalClassified.WeaponType = GlobalClassified.WeaponType.NONE
@export var ae_stat: AEIndexStatInformation
@export var scene: PackedScene

	
