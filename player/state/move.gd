# player/state/move.gd
extends PlayerState


@export var footstep_sound: AudioStreamRandomizer


func _enter_tree() -> void:
	#add_library()
	pass



func _enter() -> void:
	var player := get_player()
	
	play(&"move")
	player.state.face = player.get_input_direction()


func _update(_delta: float) -> void:
	var player := get_player()

	player.velocity.x = move_toward(
		player.velocity.x, player.get_input_direction().x * 350., 12.25
	)

	move_and_slide()
	
	if !is_on_floor():
		change_state(get_state(^"Fall"))
		return

	if Input.is_action_just_pressed(&"jump"):
		player.velocity.y = -450.
		change_state(get_state(^"Jump"))
		return

	var input_dir: Vector2 = player.get_input_direction()
	if player.state.face.x != input_dir.x:
		player.state.face.x = int(input_dir.x)
		
	if input_dir.x == 0.:
		change_state(get_state(^"Idle"))



func play_footstep() -> void:
	var player := get_player()
	var shadow := get_player().get_shadow()
	var channel := Global.get_channel()
	
	# Create PhysicsPointQueryParameters2D
	var point_param := PhysicsPointQueryParameters2D.new()
	point_param.position = shadow.global_position
	point_param.collide_with_bodies = true
	point_param.collision_mask = 4
	
	var result: Array[Dictionary]= player.get_world_2d().direct_space_state.intersect_point(point_param, 1)
	if !result.is_empty():
		var object := result[0]["collider"] as Object
		if object is Floor:
			if object.type == Floor.Type.CONCRETE:
				channel.play(
					footstep_sound,
					player.global_position,
					&"SFX",
					player
				)


	
