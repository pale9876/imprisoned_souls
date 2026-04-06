@tool
extends Node2D
class_name Squad2D


@export var leader: SquadMember
@export var members: Array[SquadMember]
@export var message_log: PackedStringArray

@export var max_count: int = 3


# OVERRIDE
func _process(delta: float) -> void:
	pass


# OVERRIDE
func _physics_process(delta: float) -> void:
	pass


class M extends RefCounted:
	var body: RID
	var shape: RID

	var hurtbox: RID
	var hurtbox_shape: RID

	var awareness: RID
	var awareness_shape: RID
