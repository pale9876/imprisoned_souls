@tool
extends Resource
class_name LegionInstance


@export var shader: ShaderMaterial = ShaderMaterial.new()
@export var position: Vector2 = Vector2(0., 0.):
	set(value):
		position = value
		if ci_rid.is_valid():
			RenderingServer.canvas_item_set_transform(
				ci_rid, Transform2D(0., position)
			)
@export var size: Vector2i = Vector2i(128, 128)
@export var texture: Texture2D


var ci_rid: RID


static func create_instance(parent: RID) -> LegionInstance:
	var instance: LegionInstance = LegionInstance.new()
	instance.init_instance(parent)

	return instance


func init_instance(parent: RID) -> void:
	ci_rid = RenderingServer.canvas_item_create()
	RenderingServer.canvas_item_set_parent(ci_rid, parent)
	RenderingServer.canvas_item_set_material(ci_rid, shader.get_rid())


func update() -> void:
	RenderingServer.canvas_item_clear(ci_rid)

	RenderingServer.canvas_item_add_texture_rect(
		ci_rid,
		Rect2(-(texture.get_size() / 2.), texture.get_size()),
		texture
	)

	RenderingServer.canvas_item_set_transform(
		ci_rid, Transform2D(0., position)
	)



func remove_instance() -> void:
	RenderingServer.canvas_item_clear(ci_rid)
	
	RenderingServer.free_rid(ci_rid)
