# blade_module_info.gd
extends Resource
class_name BladeModuleInfo


@export var name: StringName
@export var icon: Texture2D
@export_multiline() var description: String


@export var allowed: Array[GlobalClassified.BattleClass] = [
	GlobalClassified.BattleClass.PREDATOR,
	GlobalClassified.BattleClass.EXECUTIONER,
	GlobalClassified.BattleClass.CHIMERA,
	GlobalClassified.BattleClass.TRICKSTER,
	GlobalClassified.BattleClass.PUPPETEER,
	GlobalClassified.BattleClass.EXORCIST,
	GlobalClassified.BattleClass.TWINS,
] # 0 == ANY, 모션 호환 가능한 클래스
@export var 공중공격: bool = false
@export var 캔슬가능: bool = false


@export_group("무기 호환")
@export var activate_by_usable_weapons_only: bool = false
@export var weapon_compatibility: Array[GlobalClassified.WeaponType]
@export var enter_command: Array[String] # 진입 커맨드


@export_group("데이터")
@export var animation: Animation
@export var sprite_motion: PackedScene
@export var hitbox: PackedScene
@export var target_state: PackedScene




	
