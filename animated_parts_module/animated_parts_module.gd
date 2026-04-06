@tool
extends Node2D
class_name AnimatedPartsModule


@export_enum("FLOATING", "GROUNDED") var mode: int = 0

@export var parts: Array[AnimatedPart]
@export var auto_emit: bool = false
@export var init_force: float = 600.
@export var radial_range: float
@export var snap_length: float = 1.

@export var gravity: float = 970.

var arr: Array[P] = []

@export_tool_button("Emit", "2D") var _emit: Callable = emit

var _finished: bool = false


func emit() -> void:
	if !arr.is_empty():
		kill()
	
	arr.resize(parts.size())
	
	for i: int in range(parts.size()):
		var part: P = P.new()
		arr[i] = part
		
		part.body = PhysicsServer2D.body_create()
		PhysicsServer2D.body_set_mode(part.body, PhysicsServer2D.BODY_MODE_KINEMATIC)
		PhysicsServer2D.body_set_state(part.body, PhysicsServer2D.BODY_STATE_TRANSFORM, Transform2D(get_global_transform()))
		PhysicsServer2D.body_set_space(part.body, get_world_2d().space)
		
		var shape: RID = PhysicsServer2D.rectangle_shape_create()
		var ray: RID = PhysicsServer2D.separation_ray_shape_create()
		
		part.shape = shape
		part.seperate_ray = ray
		part.size = parts[i].size / 2.
		part.bounce = parts[i].bounce
		part.friction = parts[i].friction
		part.mask = parts[i].mask
		
		
		PhysicsServer2D.shape_set_data(shape, part.size)
		#PhysicsServer2D.shape_set_data(
			#ray, {"length" : part.size.y + snap_length, "slide_on_slope" : false}
		#)
		PhysicsServer2D.body_add_shape(part.body, shape, Transform2D(), false)
		#PhysicsServer2D.body_add_shape(part.body, ray, Transform2D(0., Vector2(0., - part.size.y / 2.)), false)
		PhysicsServer2D.body_attach_object_instance_id(part.body, get_instance_id())
		PhysicsServer2D.body_set_collision_mask(part.body, parts[i].mask)
		
		part.cid = RenderingServer.canvas_item_create()
		
		part.texture = parts[i].texture
		RenderingServer.canvas_item_set_transform(part.cid, Transform2D())
		RenderingServer.canvas_item_set_parent(part.cid, get_canvas_item())
		#RenderingServer.canvas_item_add_rect(part.cid, Rect2(- parts[i].size / 2., parts[i].size), Color.RED)
		part.texture.draw(part.cid, - part.texture.get_size() / 2.)
		
		part.position = position
		part.global_position = global_position
		
		part.velocity = Vector2.from_angle(
			randf_range(parts[i].direction.angle() - (parts[i].angle_range / 2.), parts[i].direction.angle() + (parts[i].angle_range / 2.))
		) * randf_range(parts[i].min_force, parts[i].max_force)

		part.animation = parts[i].animation
		part.change_animation("roll")



func _physics_process(delta: float) -> void:
	if !_finished:
		var fin: bool = true
		
		for p: P in arr:
			if !p.finished:
				if p.mode == 0:
					p.velocity *= 1. - p.friction
				elif p.mode == 1:
					if !p.on_floor:
						p.velocity.y += gravity * delta
				
				var param: PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()
				param.shape_rid = p.shape
				param.motion = p.velocity * delta
				param.exclude = get_body_rids()
				param.collide_with_bodies = true
				param.collide_with_areas = false
				param.transform = Transform2D(0., p.global_position)

				var test: PackedFloat32Array = get_world_2d().direct_space_state.cast_motion(param)
				
				if test[1] < 1.:
					var rest_info = get_world_2d().direct_space_state.get_rest_info(param)
					var normal: Vector2 = rest_info["normal"]
					var point: Vector2 = rest_info["point"]
					if absf(Vector2.DOWN.angle_to(p.velocity)) < 45.:
						p.on_floor = true
						p.velocity = p.velocity.bounce(normal) * p.bounce
						p.change_animation("idle")
					p.global_position += test[0] * param.motion
					
				else:
					p.on_floor = false
					p.on_wall = false
					p.global_position += param.motion
				
				if p.velocity.length() < 1.:
					p.finished = true
				else:
					fin = false

				if fin:
					_finished = true

				p.position = p.global_position - global_position
				
				RenderingServer.canvas_item_set_transform(
					p.cid, Transform2D(0., p.position)
				)
				
				if p.animation[p.anim][0] != p.animation[p.anim][1]:
					if !p.anim_stop:
						if p.progress > 0:
							p.progress -= 1

						if p.progress == 0:
							RenderingServer.canvas_item_clear(p.cid)
							p.frame += 1
			
							if p.frame > p.get_end_frame():
								p.frame = p.animation[p.anim][0]
			
							p.progress = p.animation[p.anim][2]
					
							p.texture.draw(p.cid, - p.texture.get_size() / 2.)


func get_body_rids() -> Array[RID]:
	var result: Array[RID] = []
	for p: P in arr:
		result.push_back(p.body)
	
	return result


func _exit_tree() -> void:
	kill()


func kill() -> void:
	if !arr.is_empty():
		for p: P in arr:
			PhysicsServer2D.free_rid(p.shape)
			PhysicsServer2D.free_rid(p.seperate_ray)
			PhysicsServer2D.free_rid(p.body)
			RenderingServer.free_rid(p.cid)
	
	_finished = false


class P extends RefCounted:
	var texture: AtlasTexture
	
	var mode: int = 0
	var body: RID
	var cid: RID
	var shape: RID
	var seperate_ray: RID
	
	var on_wall: bool = false
	var on_floor: bool = false
	var size: Vector2
	var bounce: float
	var friction: float
	var velocity: Vector2 = Vector2()
	#var _collided: bool = false
	var mask: int = 1
	
	var global_position: Vector2 = Vector2()
	var position: Vector2 = Vector2()
	
	var anim_stop: bool = false
	var frame: int = 0: set = set_frame
	var animation: Dictionary[String, Array]
	var progress: int = 0
	var anim: String = "idle"

	var finished: bool = false


	func change_animation(anim_name: String) -> void:
		if !animation.has(anim_name): return
		
		RenderingServer.canvas_item_clear(cid)
		
		anim = anim_name
		frame = animation[anim][0]
		progress = animation[anim][2]
		
		texture.draw(cid, - texture.get_size() / 2.)


	func get_end_frame() -> int:
		return animation[anim][1]


	func set_frame(value: int) -> void:
		frame = value
		
		if texture:
			texture.region = Rect2(
				Vector2(float(frame) * texture.get_size().x, 0.), Vector2(texture.get_size())
			)
		
