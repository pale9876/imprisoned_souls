@tool
extends Node2D
class_name HitParticle


@export var amount: int = 300
@export var life_time: float = .75
@export var particle_life_time: float = 1.5

@export var explosion_curve: Curve
@export var explode_texture: GradientTexture2D
@export var effect_curve: Curve

@export var max_dist: float = 300.
@export var min_dist: float = 50.

@export var max_size: float = 5.
@export var min_size: float = 1.

@export var texture: GradientTexture2D

@export var direction: Vector2 = Vector2(1., 0.):
	set(value):
		direction = value.normalized() if !value.is_normalized() else value

@export var angle_range: float = 30.:
	set(value):
		angle_range = value

@export_category("Center Explosion")
@export var center_scale: Vector2 = Vector2.ONE
@export var center_rotation: float = 30.

var center: C
var spark: Array[S]


var _finished: bool = false


@export_tool_button("Emit", "2D") var _emit: Callable = emit


func emit() -> void:
	if center or !spark.is_empty():
		kill()
	
	# Explode
	if explode_texture:
		center = C.new()
		center.rid = RenderingServer.canvas_item_create()
		RenderingServer.canvas_item_set_parent(center.rid, get_canvas_item())
		RenderingServer.canvas_item_set_transform(
			center.rid, Transform2D(0., Vector2(), 0., Vector2())
		)
		RenderingServer.canvas_item_add_texture_rect(
			center.rid, Rect2(- explode_texture.get_size() / 2., explode_texture.get_size()), explode_texture
		)
		RenderingServer.canvas_item_set_parent(center.rid, get_canvas_item())
	
	# Spark
	spark.resize(amount)

	for i: int in amount:
		var s: S = S.new()
		s.rid = RenderingServer.canvas_item_create()
		
		RenderingServer.canvas_item_set_parent(s.rid, get_canvas_item())
		s.pos = Vector2.from_angle(
			randf_range(
					direction.angle() - deg_to_rad(angle_range) / 2., direction.angle() + deg_to_rad(angle_range) / 2.
				)
			)  * [-1., 1.].pick_random() * randf_range(min_dist, max_dist)
		
		RenderingServer.canvas_item_add_texture_rect(
			s.rid, Rect2(- texture.get_size() / 2., texture.get_size()), texture
		)
		s.size = Vector2.ONE * randf_range(min_size, max_size)
		
		RenderingServer.canvas_item_set_transform(
			s.rid, Transform2D(0., s.size, 0., Vector2())
		)
		
		spark[i] = s
	
	_finished = false


func kill() -> void:
	if explode_texture:
		RenderingServer.free_rid(center.rid)
	
	if !spark.is_empty():
		for s: S in spark:
			RenderingServer.free_rid(s.rid)
	

	spark = []
	center = null


func _process(delta: float) -> void:
	if _finished: return
	
	var explode_animation_finished: bool = false
	var spark_animation_finished: bool = true
	
	var result: bool = false
	
	if explode_texture:
		center.progress = clampf(center.progress + delta, 0., life_time)
		RenderingServer.canvas_item_set_transform(
			center.rid, Transform2D(
				center_rotation, center_scale * explosion_curve.sample_baked(center.progress / life_time), 0., Vector2()
			)
		)
		
		var modul: Color = Color.WHITE
		modul.a = effect_curve.sample_baked(center.progress / life_time)
		RenderingServer.canvas_item_set_modulate(
			center.rid, modul
		)
		
		if center.progress == life_time:
			center.finished = true
		
		if center.finished:
			explode_animation_finished = true
	
	if !spark.is_empty():
		for s: S in spark:
			s.progress = clampf(s.progress + delta, 0., particle_life_time)
			
			var modul: Color = Color.WHITE
			modul.a = effect_curve.sample_baked(s.progress / particle_life_time)
			
			RenderingServer.canvas_item_set_transform(
				s.rid, Transform2D(
						0.,
						s.size * (effect_curve.sample_baked(s.progress / particle_life_time)), 0.,
						s.pos * (explosion_curve.sample_baked(s.progress / particle_life_time))
					)
			)
			
			RenderingServer.canvas_item_set_modulate(s.rid, modul)
			
			if s.progress == particle_life_time:
				s.finished = true
			else:
				spark_animation_finished = false

	if explode_animation_finished and spark_animation_finished:
		result = true

	if result:
		_finished = true
	
	if _finished:
		_finish()


func _finish() -> void:
	kill()
	
	if !Engine.is_editor_hint():
		queue_redraw.call_deferred()


class C extends RefCounted:
	var rid: RID
	var progress: float = 0.
	var finished: bool = false


class S extends RefCounted:
	var rid: RID
	var pos: Vector2
	var size: Vector2 = Vector2.ONE
	var progress: float = 0.
	var finished: bool = false
