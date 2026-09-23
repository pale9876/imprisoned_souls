# hitbox_component.gd
@tool
extends Node2D
class_name HitboxComponent



func _enter_tree() -> void:
	set_owner(get_parent())


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
