extends Resource
class_name OverloadInformation


enum Personality {
	DEFENSIVE, # 방어적
	AGGRESSIVE, # 공격적
}


enum CharacterTag {
	PRIDE, # 오만
	CAUTIOUS, # 신중
	CELERITY, # 민첩함
	DREADNOUGHT, # 두려움없는
	PARANOID, # 편집증적
}


@export var name: StringName
@export var icon: Texture2D
@export_multiline() var description: String
@export var personality: Personality = Personality.DEFENSIVE
@export var character_tag: CharacterTag = CharacterTag.PRIDE
@export var unit_info: UnitInformation


@export_category("유닛 씬")
@export var unit_scene: PackedScene
@export var spawn_pool: Array[PackedScene]
@export var bt: BehaviorTree


	
