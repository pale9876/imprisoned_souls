@tool
extends Node2D
class_name AnimatedPartsModule


@export var parts: Array[AnimatedPart]
@export var auto_emit: bool = false
@export var init_force: float = 600.
@export var radial_range: float
@export var auto_deceleration: bool = true
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
		part.size = parts[i].size
		part.bounce = parts[i].bounce
		part.friction = parts[i].friction
		
		PhysicsServer2D.shape_set_data(shape, Vector2(parts[i].size))
		PhysicsServer2D.shape_set_data(
			ray, {"length" : part.size.y + snap_length, "slide_on_slope" : true}
		)
		PhysicsServer2D.body_add_shape(part.body, shape, Transform2D(), false)
		PhysicsServer2D.body_add_shape(part.body, ray, Transform2D(0., Vector2(0., 0.)), false)
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
				if !p.on_floor:
					p.velocity.y += gravity * delta

				var param: PhysicsTestMotionParameters2D = PhysicsTestMotionParameters2D.new()
				var result: PhysicsTestMotionResult2D = PhysicsTestMotionResult2D.new()

				param.recovery_as_collision = true
				param.collide_separation_ray = true
				param.from = Transform2D(0., p.global_position)
				param.motion = p.velocity * delta
				param.exclude_bodies = get_body_rids()
					
				var test: bool = PhysicsServer2D.body_test_motion(
					p.body, param, result
				)

				if test:
					#print(result.get_collision_local_shape())
					
					if absf(Vector2.DOWN.angle_to(result.get_travel())) < 45.:
						if result.get_collision_normal().cross(Vector2.RIGHT):
							p.on_floor = true
							p.change_animation("idle")
							
							p.global_position = Vector2(
								result.get_collision_point().x, result.get_collision_point().y - (p.size.y / 2.)
							)
						else:
							p.on_wall = true
							p.global_position += result.get_collision_unsafe_fraction() * param.motion

					p.velocity = p.velocity.bounce(result.get_collision_normal())
					#print(p.velocity)
				else:
					p.on_wall = true
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
	var _collided: bool = false
	
	var global_position: Vector2 = Vector2()
	var position: Vector2 = Vector2()
	
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
		
