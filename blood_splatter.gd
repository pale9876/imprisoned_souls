@tool
extends Node2D
class_name BloodSplatter


@export var amount: int = 125
@export var max_size: float = 15.
@export var min_size: float = 3.


var _arr: Array[P]



func emit() -> void:
	pass

func kill() -> void:
	pass


class P extends RefCounted:
	var cid: RID
	
	var stream: Stream
	pass


class Stream extends RefCounted:
	pass
