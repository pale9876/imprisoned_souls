@tool
extends RefCounted
class_name BladeJudgeWorker


enum AtkType {
	KNOCKBACK,
	AERIAL,
	PUSHBACK,
	BLOWUP,
	DOWN_ATTACK,
	POUND,
	GRAB,
}


enum DefType {
	IDLE,
	EXPOSE,
	DELAY,
	GUARD,
}

enum ArmorState{
	NONE = 0,
	SHORT,
	LONG,
}


enum AtkRange {
	NONE = 0,
	SHORT,
	LONG,
}


enum Block {
	PASS,
	BY_ARMOR,
	BY_STATE,
	CRASHED,
}


enum Result {
	NONE,
	KNOCKBACKED,
	AIRBORN,
	BOUNDED,
	DOWNHIT,
	POUNDED,
	GRABED,
	BLOCKED,
}


func _init(initial: Result) -> void:
	pass


static func judge(def: DefType, def_state: ArmorState, atk: AtkType, a_range: AtkRange) -> Result:
	var result: Result = Result.NONE
	
	
	
	return result


static func check_range_with_armor(def_state: ArmorState, a_range: AtkRange) -> Block:
	var result: Block = Block.PASS
	
	match a_range:
		AtkRange.SHORT:
			if def_state == ArmorState.SHORT:
				return Block
		AtkRange.LONG:
			if def_state == ArmorState.LONG:
				return Block

	return result


static func on_idle(atk: AtkType, def_state: ArmorState, a_range: AtkRange) -> Result:
	var result: Result = Result.NONE
	
	match atk:
		AtkType.KNOCKBACK:
			result = Result.KNOCKBACKED
		AtkType.AERIAL:
			result = Result.AIRBORN
	
	return result


static func on_expose() -> Result:
	var result: Result = Result.NONE
	
	return result
