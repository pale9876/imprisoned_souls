@tool
extends Unit
class_name Player


func create() -> void:
	if init:
		kill()
	
	cid = RenderingServer.canvas_item_create()
	RenderingServer.canvas_item_set_parent(cid, get_canvas_item())
	RenderingServer.canvas_item_set_transform(cid, Transform2D())

	if !Engine.is_editor_hint():
		# Init Information to Stat
		stat = Stat.new()
		stat.hp = unit_information.init_hp
		stat.max_hp = unit_information.max_hp
		stat.atk_speed = unit_information.atk_speed
		stat.speed = unit_information.speed
		stat.frict = unit_information.friction
		stat.accel = unit_information.acceleration

		# Init Body
		body = Body.new()
		var _body: RID = PhysicsServer2D.body_create()
		PhysicsServer2D.body_set_mode(_body, PhysicsServer2D.BODY_MODE_KINEMATIC)
		PhysicsServer2D.body_set_space(_body, get_world_2d().space)
		PhysicsServer2D.body_attach_object_instance_id(_body, get_instance_id())
		PhysicsServer2D.body_set_collision_mask(_body, mask)
		PhysicsServer2D.body_set_collision_layer(_body, layer)
		PhysicsServer2D.body_set_state(_body, PhysicsServer2D.BODY_STATE_TRANSFORM, get_global_transform())
		body.rid = _body
		
		
		if !unit_information.collider.is_empty():
			for collider_name: String in unit_information.collider:
				var collider: Collider = Collider.new()
				collider.rid = PhysicsServer2D.rectangle_shape_create()
				PhysicsServer2D.shape_set_data(collider.rid, unit_information.collider[collider_name] / 2.)
				
				body.collider[collider_name] = collider
				
				RenderingServer.canvas_item_add_rect(
					cid, Rect2(- unit_information.collider[collider_name] / 2.,
					unit_information.collider[collider_name]),
					Color.WHITE
				)

		body.shape = body.collider[init_collider].rid
		PhysicsServer2D.body_add_shape(body.rid, body.shape)

		# Create Hurtbox
		_hurtbox = Hurtbox.new()
		_hurtbox.rid = PhysicsServer2D.area_create()
		
		PhysicsServer2D.area_set_space(_hurtbox.rid, get_world_2d().space)
		PhysicsServer2D.area_set_area_monitor_callback(_hurtbox.rid, damaged)
		PhysicsServer2D.area_set_transform(_hurtbox.rid, Transform2D())
		PhysicsServer2D.area_set_monitorable(_hurtbox.rid, true)
		PhysicsServer2D.area_set_collision_mask(_hurtbox.rid, 1)
		PhysicsServer2D.area_set_collision_layer(_hurtbox.rid, 1)
		PhysicsServer2D.area_attach_object_instance_id(_hurtbox.rid, get_instance_id())
		
		_hurtbox.shape = PhysicsServer2D.rectangle_shape_create()
		PhysicsServer2D.area_add_shape(_hurtbox.rid, _hurtbox.shape)
		PhysicsServer2D.shape_set_data(_hurtbox.shape, _hurtbox.size / 2.)
		
	skill_module = SkillModule.new()
	skill_module.init(skill_information, self)
	
	pose_module = PoseModule.new()
	pose_module.init_data(pose_information, self)

	init = true


func kill() -> void:
	if !Engine.is_editor_hint():
		if body:
			for index: int in range(PhysicsServer2D.body_get_shape_count(body.rid)):
				PhysicsServer2D.free_rid(PhysicsServer2D.body_get_shape(body.rid, index))
			PhysicsServer2D.free_rid(body.rid)
		
			for collider_name: String in body.collider:
				PhysicsServer2D.free_rid(body.collider[collider_name].rid)

		if _hurtbox:
			free_hurtbox()
		
		if pose_module: pose_module.kill()
		if skill_module: skill_module.kill()


func _enter_tree() -> void:
	if !init:
		create()


func _exit_tree() -> void:
	if init:
		kill()


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint(): return

	PhysicsServer2D.body_set_state(body.rid, PhysicsServer2D.BODY_STATE_TRANSFORM, get_global_transform())

	pose_module.tick(delta)
	skill_module.tick(delta)

	PhysicsServer2D.area_set_transform(_hurtbox.rid, get_global_transform())
