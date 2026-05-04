extends Node


enum {
	INIT,
	READY,
	INGAME,
}


signal start()
signal restart()

signal player_health_changed( value: float )
signal change_camera( cam_name: String )

signal default()


var state: int = INIT
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


class PlayerInformation extends RefCounted:
	var character: Resource
	var character_class: Resource
	var position: Vector2


class SaveData extends Resource:
	pass
