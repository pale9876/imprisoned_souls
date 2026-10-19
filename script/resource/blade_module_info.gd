# blade_module_info.gd
extends Resource
class_name BladeModuleInfo


@export var name: StringName
@export_multiline() var description: String

@export var allowed: Array[IngameClassifiedData.BattleClass] = [
	IngameClassifiedData.BattleClass.PREDATOR,
	IngameClassifiedData.BattleClass.EXECUTIONER,
	IngameClassifiedData.BattleClass.CHIMERA,
	IngameClassifiedData.BattleClass.TRICKSTER,
	IngameClassifiedData.BattleClass.PUPPETEER,
	IngameClassifiedData.BattleClass.EXORCIST,
	IngameClassifiedData.BattleClass.TWINS,
] # 0 == ANY, 모션 호환 가능한 클래스


@export_group("무기 호환")
@export var activate_by_usable_weapons_only: bool = false
@export var weapon_compatibility: IngameClassifiedData.WeaponType = IngameClassifiedData.WeaponType.NONE
@export var enter_command: Array[String] # 진입 커맨드


@export_group("데이터")
@export var animation: Animation
@export var sprite_motion: PackedScene
@export var hitbox: PackedScene
@export var target_state: PackedScene





	
