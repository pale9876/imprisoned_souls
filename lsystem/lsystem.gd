@tool
extends RefCounted
class_name LSystem


enum Constants {
	X = -1,
	F = 0, # F
	f = 1, # f
	PLUS = 2, # +
	MINUS = 3, # -
	OR = 4, # |
	PUSH_STACK = 5, # [
	POP_STACK = 6, # ]
	INCREMENT_LINE_WIDTH = 7, # #
	DECREMENT_LINE_WIDTH = 8, # !
	DOT = 9,# @
	OPEN_POLYGON = 10, # {
	CLOSE_POLYGON = 11, # }
	DECREMENT_TURNING_ANGLE, #(
	INCREMENT_TURNING_ANGLE, #)
}


const VARIABLES: Array[Constants] = [
	Constants.F,
	Constants.f
]

const OPERATOR: Array[Constants] = [
	Constants.PLUS,
	Constants.MINUS,
	Constants.OR,
	Constants.PUSH_STACK,
	Constants.POP_STACK,
	Constants.INCREMENT_LINE_WIDTH,
	Constants.DECREMENT_LINE_WIDTH,
	
]


var cid: RID
var state: PackedInt32Array
var colors: Dictionary[LSystem.Constants, Color]
var position: Vector2
var direction: Vector2
var length: float
var stack: Array[Dictionary] = []
var rule: Dictionary[int, PackedInt32Array] = {}
var lines: PackedVector2Array = PackedVector2Array()

static func parse(axiom: String) -> PackedInt32Array:
	var result: PackedInt32Array = []
	result.resize(axiom.length())
	for i: int in range(axiom.length()):
		result[i] = parse_char(axiom[i]) as int

	return result


static func parse_char(chr: String) -> Constants:
	match chr:
		"F":
			return Constants.F
		"f":
			return Constants.f
		"+":
			return Constants.PLUS
		"-":
			return Constants.MINUS
		"|":
			return Constants.OR
		"[":
			return Constants.PUSH_STACK
		"]":
			return Constants.POP_STACK
		"#":
			return Constants.INCREMENT_LINE_WIDTH
		"!":
			return Constants.DECREMENT_LINE_WIDTH
	return Constants.X
