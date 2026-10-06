# hitbox_component.gd
@tool
extends Node2D
class_name HitboxComponent


@export var _show: Hitbox = null:
	set(node):
		if is_node_ready() and node is Hitbox and has_node(NodePath(node.name)):
			if _show != null:
				_show.visible = false
			_show = node
			node.visible = true


func _find_first_node_in_child() -> Node:
	return get_child(0) if get_child_count() > 1 else null


func _ready() -> void:
	_show = _find_first_node_in_child()


func has_projectile() -> void:
	pass


func has_hitbox(node_path: NodePath) -> bool:
	var node := get_node(node_path)
	if node is Hitbox:
		return true
	
	return false


func add_projectile(hitbox_scene: PackedScene) -> void:
	var _projectile := hitbox_scene.instantiate() as PlayerProjectiledHitbox
	add_child(_projectile)


func is_hit(hitbox_name: StringName, hitbox_shape_name: StringName) -> bool:
	var hitbox_path: NodePath = NodePath(hitbox_name)
	var hitbox_shape_path: NodePath = NodePath(hitbox_shape_name)
	
	if has_hitbox(hitbox_path):
		var hitbox := get_node(hitbox_path) as Area2D
		var hitbox_shape := hitbox.get_node(hitbox_shape_path) as CollisionObject2D
		hitbox_shape
		
	return false


func add_hitbox(hitbox: Node2D) -> void:
	add_child(hitbox)


func get_player_hitbox(node_path: NodePath) -> Hitbox:
	return get_node(node_path) as Hitbox


func get_unit_hitbox(node_path: NodePath) -> Area2D:
	return get_node(node_path) as Area2D
