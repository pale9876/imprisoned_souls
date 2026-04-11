@tool
extends EEAD2D
class_name Player


@export var unit_information: UnitInformation = UnitInformation.new()
@export var skill: Dictionary[String, HitboxInformation]

var _body: RID
var _shape: Dictionary[String, RID]

var _hurtbox: Hurtbox
var _hitbox: Hitbox


func _enter_tree() -> void:
	if !Engine.is_editor_hint():
		create()


func create() -> void:
	if init:
		kill()
	
	_body = PhysicsServer2D.body_create()
	
	for collider_name: String in unit_information.collider:
		_shape[collider_name] = PhysicsServer2D.rectangle_shape_create()


func create_hitbox(information: HitboxInformation, duration: float) -> void:
	var hitbox: RID = PhysicsServer2D.area_create()
	PhysicsServer2D.area_attach_object_instance_id(hitbox, get_instance_id())
	PhysicsServer2D.area_set_area_monitor_callback(hitbox, hit)
	
	var shape: RID = PhysicsServer2D.rectangle_shape_create()
	PhysicsServer2D.area_add_shape(hitbox, shape)


func free_hitbox() -> void:
	pass


func hit(status: PhysicsServer2D.AreaBodyStatus, area_rid: RID, instance_id: int, area_shape_idx: int, self_shape_idx: int) -> void:
	pass


func hurt(status: PhysicsServer2D.AreaBodyStatus, area_rid: RID, instance_id: int, area_shape_idx: int, self_shape_idx: int) -> void:
	pass


func _physics_process(delta: float) -> void:
	pass


func kill() -> void:
	PhysicsServer2D.free_rid(_body)


class Hurtbox extends RefCounted:
	var pos: Vector2
	var size: Vector2
	var duration: float
	var disabled: bool


class Hitbox extends RefCounted:
	var pos: Vector2
	var size: Vector2
	var duration: float
	var disabled: bool
