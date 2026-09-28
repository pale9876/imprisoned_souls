extends RefCounted
class_name ActionResult

enum {
	NONE = 0,
	SUCCESS,
	FAIL,
}

var result: int = NONE
var event: StringName

var from: Node2D
var to: Node2D
