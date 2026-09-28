# sprite_component.gd
@tool
extends Node2D


# Import
const DirectionModuler: Script = preload("uid://dghhexdudu0xy")


@export var current: Node2D:
	set(node):
		current = node
		if node and node.is_inside_tree():
			for child: Node in get_children():
				if child is Node2D:
					child.visible = node == child


@export var offset: Vector2 = Vector2(0., -64.):
	set(value):
		offset = value
		for node: Node in get_children():
			if node is Node2D:
				node.position = offset


@export var cursor_frame: int = 0:
	set(value):
		if current != null:
			pass


var force: Vector2


var time: float:
	set(value):
		time = maxf(0., value)

var time_scale: float:
	set(value):
		time_scale = maxf(0., value)


func _physics_process(delta: float) -> void:
	if !Engine.is_editor_hint():
		if time > 0.:
			force = - force
			
			position = position.lerp(force, randf_range(.125, .225))
			force = force.lerp(Vector2(), randf_range(.095, .225))
			time -= delta * time_scale


func has_module(_name: String) -> bool:
	return get_node(NodePath(_name)) in get_children()


func shake(_force: Vector2, _duration: float, _scale: float) -> void:
	force = _force
	time = _duration


func change(sprite_name: String) -> void:
	if has_module(sprite_name):
		var karada := get_node(NodePath(sprite_name)) as Node2D
		current = karada


func is_sprite(node: Node) -> bool:
	return node is KaradaModule or node is Sprite2D
