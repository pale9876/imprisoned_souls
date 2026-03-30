extends Node


const SCREEN_JOY_PAD: PackedScene = preload("uid://bk1bnhqoyyuuj")


enum {
	INIT,
	READY,
	INGAME,
}


var state: int = INIT
var os: String = ""

var screen_joypad: CanvasLayer = null
var main_scene: Node = null


#func _notification(what: int) -> void:
	#match what:
		#pass


func _enter_tree() -> void:
	os = OS.get_name()
	print("구동환경: ", os)

	match os:
		_:
			pass

func _ready() -> void:
	pass


class SaveData extends Resource:
	pass
