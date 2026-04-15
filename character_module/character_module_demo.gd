@tool
extends EEAD2D



@export var character_module: CharacterModule
var character: Character


@export_tool_button("Flip", "2D") var _flip: Callable = flip


func create_sprite(texture: Texture2D, draw_index: int, color: Color = Color.WHITE, shader: ShaderMaterial = null) -> SP:
	var sprite: SP = SP.new()
	
	sprite.cid = RenderingServer.canvas_item_create()
	sprite.draw_index = draw_index
	sprite.texture = texture

	RenderingServer.canvas_item_set_parent(sprite.cid, get_canvas_item())
	RenderingServer.canvas_item_add_texture_rect(
		sprite.cid,
		Rect2(- texture.get_size() / 2., texture.get_size()),
		texture.get_rid()
	)
	RenderingServer.canvas_item_set_draw_index(sprite.cid, draw_index)
	RenderingServer.canvas_item_set_use_parent_material(sprite.cid, true)

	if shader:
		sprite.shader = shader
		RenderingServer.canvas_item_set_material(sprite.cid, sprite.shader)
	
	return sprite


func create() -> void:
	if init:
		kill()

	character = Character.new()
	
	var index: int = 0
	
	character.back_hair = create_sprite(
		character_module.back_hair,
		index,
		character_module.back_hair_color
	)
	index += 1
	
	character.left_side_hair = create_sprite(
		character_module.left_side_hair,
		index,
		character_module.left_side_hair_color
	)
	index += 1
	
	character.face = create_sprite(
		character_module.face,
		index,
		character_module.face_color
	)
	index += 1
	
	character.eye = create_sprite(
		character_module.eye,
		index,
		character_module.eye_color
	)
	index += 1
	
	character.right_side_hair = create_sprite(
		character_module.right_side_hair,
		index,
		character_module.right_side_hair_color,
	)
	index += 1
	
	character.front_hair = create_sprite(
		character_module.front_hair,
		index,
		character_module.front_hair_color
	)
	index += 1

	init = true


func flip() -> void:
	scale.x = - scale.x


func swap_draw_index(a: SP, b: SP) -> void:
	var old_left_side_hair_draw_index: int = a.draw_index
	var old_right_side_hair_draw_index: int = b.draw_index
	
	RenderingServer.canvas_item_set_draw_index(a.cid, old_right_side_hair_draw_index)
	RenderingServer.canvas_item_set_draw_index(b.cid, old_left_side_hair_draw_index)


func _enter_tree() -> void:
	create()


func kill() -> void:
	if character:
		if character.right_side_hair:
			RenderingServer.free_rid(character.right_side_hair.cid)

		if character.face:
			RenderingServer.free_rid(character.face.cid)

		if character.left_side_hair:
			RenderingServer.free_rid(character.left_side_hair.cid)

		if character.eye:
			RenderingServer.free_rid(character.eye.cid)

		if character.front_hair:
			RenderingServer.free_rid(character.front_hair.cid)
		

		character = null


class Character extends RefCounted:
	var type: CharacterModule.Type
	
	var front_hair: SP
	var right_side_hair: SP
	var left_side_hair: SP
	var back_hair: SP
	var hair_frame: int = 0
	
	var face: SP
	var eye: SP
	var face_frame: int = 0
	
	var top: SP
	var bottom: SP
	var body_frame: int = 0

	var shader: ShaderMaterial


class SP extends RefCounted:
	var draw_index: int = - 1
	var texture: Texture2D
	var cid: RID
	var color: Color = Color.WHITE
	var frame: int = 0
	var shader: ShaderMaterial
