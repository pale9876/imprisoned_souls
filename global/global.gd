extends Node


enum State {
	INIT,
	READY,
	INGAME,
}


enum Class {
	PREDETOR = 0,
	TRICKSTER = 1,
	EXECUTIONER = 2,
	PUPPETEER = 3,
}


const INIT: State = State.INIT
const READY: State = State.READY
const INGAME: State = State.INGAME


const PREDETOR: Class = Class.PREDETOR
const TRICKSTER: Class = Class.TRICKSTER
const EXECUTIONER: Class = Class.EXECUTIONER
const PUPPETEER: Class = Class.PUPPETEER


signal start()
signal restart()

signal player_health_changed( value: float )
signal change_camera( cam_name: String )

signal default()


var os: String = ""
var player_information: PlayerInformation = PlayerInformation.new()


func _enter_tree() -> void:
	os = OS.get_name()
	print("구동환경: ", os)

	match os:
		_:
			pass


func _ready() -> void:
	pass



func process() -> void:
	pass



class PlayerInformation extends RefCounted:
	var character: Resource
	var character_class: Resource
	var position: Vector2


class SaveData extends Resource:
	pass
