# unit_generator.gd
extends Node


# Types
const Nation := UnitInformation.Nation
const Race := UnitInformation.Race


const UNIQUE_FNAME: Array[String] = [ # NPC의 이름이기에 제외되는 이름 목록
	"Hachi", # 살해 타겟 이름이라 
	"Eunseo", # 최종 책임관리자 A (Female)
	"Junwoo", # 최종 책임관리자 B (Male)
	"Fuwai", # 
	"Zhan-si Jeong", # 
]


func lname_variants(nation: Nation, race: Race) -> Dictionary[Nation, Array]:
	return {
		Nation.SOLINIA : [
			"Li",
			"Jeong",
			"Na",
			"Yu",
		],
		Nation.EMPIRE_ARIMIN : [
			"Kayayowo",
			"Auko",
			"Noromi",
		],
		Nation.MANDALIA : [
			"Fei",
			"Chen",
			"Wu",
		],
		Nation.SLOVONICA : [
			"Kantas",
			"Aduas",
			"Timon",
		],
		Nation.SUBORTEAR : [
			"Johnahan",
			"Hexsen",
			"Mainz",
			"Koln"
		],
	}




	
