@tool
extends Resource
class_name SkillInformation


enum CastType
{
	RAY,
	SHAPE,
}

enum ATKType
{
	EXPLOSION,
	IMMID
}


const RAYTYPE_CAST: int = CastType.RAY
const SHAPETYPE_CAST: int = CastType.SHAPE


const ATK_EXPLOSION: int = ATKType.EXPLOSION
const ATK_IMMID: int = ATKType.IMMID

@export_category("Skill Name")
@export var name: String = ""

@export_category("Skill Type")
@export var cast_type: CastType = CastType.RAY
@export var attack_type: ATKType = ATKType.EXPLOSION


@export var skill_range: float = 100.
@export var cooldown: float = 1.
@export var position: Vector2
@export var size: float
@export var hitbox_information: HitboxInformation
