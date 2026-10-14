# information.gd for unit.stat
@tool
extends Resource
class_name UnitInformation


enum Race {
	UNKNOWN = 0,
	UMONEIRA, # Human, Normal Ear, DEFAULT
	NAITAM, # FoxEar, Tail
	RYUKYU_MONOS, # DogEar, Tail
	GUOREO, # Long or Big Horn
	MONGOLIANA_CHILD, # Long Ear
	MIXED, # 혼혈
	
	DICLONIUS, # ? 디클로니우스
}


enum Nation { # s = simillar
	UNKNOWN = 0,
	SOLINIA, # s(Korea), DEFAULT
	MANDALIA, # s(Chinese)
	EMPIRE_ARIMIN, # s(Japanese)
	
	SLOVONICA, # s(Russia)
	SUBORTEAR, # s(German)
	SALO, # s(Italy)
}


enum CharacterClass {
	NONE = 0, # DEFAULT
	
	# Unit (with Player)
	PREDATOR,
	EXECUTIONER,
	CHIMERA,
	TRICKSTER,
	PUPPETEER,
	EXORCIST,
	TWIN,
	
	# NPC
	OFFICER, # 인사 및 사무부
	CLEANER, # 청소부
	CLEANER_TEAM_LEADER, # 청소부 관리인
	COUNTER, # 대응팀
	COUNTER_TEAM_LEADER, # 대응 분대장
	
	IMPERIOR_ORDER,
	IMPERIOR_ORDER_LEADER,
	
	CIVILIAN, # 민간인
	SUBJECT, # 피실험자
	
	CUSTOM, # 사용자 정의
}


@export_group("캐릭터 정보")
@export var mosaiced_name: StringName = &"Unknowned"
@export var mosaiced: bool = false
@export var last_name: StringName = &"Unnamed"
@export var first_name: StringName = &"Unnamed"
@export var is_replicant: bool = true # replicant가 아닐 시, NPC 진영
@export var unique: bool = false
@export var cannot_terminate: bool = false
@export var race: Race = Race.UMONEIRA
@export var nation: Nation = Nation.SOLINIA
@export var chara_class: CharacterClass = CharacterClass.NONE


@export_group("초기 스탯")
@export var speed: float = 125. # px / sec, 초당 픽셀 이동
@export var hp: int = 75


#@export_group("etc 메타데이터")
#@export var meta: Dictionary[String, Variant] = {
	# ! 이곳에 기록되어야 할 정도
	# - 해당 캐릭터의 성격 및 전투 기록
	# - 부모의 인종 데이터
#}


#func add_meta(d_name: String, data: Variant) -> void:
	#set_meta(d_name, data)
	#meta[d_name] = data


#func (d_name: String) -> void:
	#if has_meta(d_name):
		#remove_meta()


func get_full_name() -> String:
	var ret: String = ""
	
	if Nation.SOLINIA:
		ret = first_name + " " + last_name
	else:
		ret = last_name + " " + first_name
	
	return ret


	
