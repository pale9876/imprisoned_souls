@tool
extends Node2D
class_name Pillar


@export var texture: Texture2D:
	set(_texture):
		texture = _texture
		_sprite.texture = texture

@export var width: int = 64:
	set(val):
		width = val
		_collision.polygon = get_polygon()
@export var height: int = 512:
	set(val):
		height = val
		_sprite.position = Vector2(0., - float(height) / 2.)
		_collision.polygon = get_polygon()

@export_flags_2d_physics var mask: int = 8:
	set(value):
		mask = value
		_body.collision_mask = mask


@export_category("DEBUG")
@export var visible_collision: bool = false:
	set(toggle):
		visible_collision = toggle
		_collision.visible = toggle
	get:
		return visible_collision


var _sprite: Sprite2D
var _body: StaticBody2D
var _collision: CollisionPolygon2D


func _init() -> void:
	_sprite = Sprite2D.new()
	_sprite.position = Vector2(0., - float(height) / 2.)

	_body = StaticBody2D.new()
	_body.collision_mask = mask
	_collision = CollisionPolygon2D.new()
	_collision.polygon = get_polygon()
	_collision.visible = false

	add_child(_sprite)
	_body.add_child(_collision)
	add_child(_body)


func get_polygon() -> PackedVector2Array:
	var x := width / 2.
	
	var lb: Vector2 = Vector2(-x, 0.)
	var rb: Vector2 = Vector2(x, 0.)
	var lt: Vector2 = Vector2(-x, - height)
	var rt: Vector2 = Vector2(x, - height)

	return PackedVector2Array([lb, rb, rt, lt])










	
