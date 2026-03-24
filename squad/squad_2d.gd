@tool
extends Node2D
class_name Squad2D


@export var members: Array[SquadMember]

@export var message_log: PackedStringArray


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	pass



func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENTER_TREE:
			if !Engine.is_editor_hint(): return
		
			if !members.is_empty():
				for member: SquadMember in members:
					member.create_body(get_world_2d().space, global_position)
		
		NOTIFICATION_PHYSICS_PROCESS:
			pass


		NOTIFICATION_DRAW:
			pass
