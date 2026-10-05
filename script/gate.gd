extends Node2D


enum {
	OPEN,
	CLOSE,
	DESTRUCTED,
}


const GatePieces = preload("uid://cqsgfwe3foqbx")
const GATE_PIECES: PackedScene = preload("uid://ctqwupgm3vj38")


@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_polygon_2d: CollisionPolygon2D = $StaticBody2D/CollisionPolygon2D


func _ready() -> void:
	await get_tree().create_timer(1.).timeout
	
	#spawn_pieces()


func spawn_pieces(hit_point: Vector2, force: Vector2) -> void:
	sprite_2d.hide()
	collision_polygon_2d.disabled = true
	collision_polygon_2d.hide()
	
	var pieces := GATE_PIECES.instantiate() as GatePieces
	add_child(pieces)
	
	pieces.apply_force(force, hit_point)
	pieces.apply_torque(hit_point, force)



	
