@tool
extends RefCounted
class_name SquadMember


var position: Vector2
var z: float
var cid: RID

var body: RID
var shape: RID
var space: RID
var behavior_tree: BehaviorTree

var hurtbox: RID
var hurtbox_shape: RID

var awareness: RID
var awareness_shape: RID


func moved(has_body: bool = false) -> void:
	if has_body:
		PhysicsServer2D.body_set_state(body, PhysicsServer2D.BODY_STATE_TRANSFORM, get_transform())

	PhysicsServer2D.area_set_transform(hurtbox, get_transform())
	PhysicsServer2D.area_set_transform(awareness, get_transform())


	


func get_transform() -> Transform2D:
	return Transform2D(0., position)
