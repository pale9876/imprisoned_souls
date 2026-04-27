@tool
extends EEAD
class_name CharacterTest


@export var init_animation: StringName = &"idle"
@export var sprite_information: SpriteInformation = SpriteInformation.new()

func create() -> void:
	if init: kill()
	
	sprite_information.draw(get_canvas_item())


func kill() -> void:
	RenderingServer.canvas_item_clear(get_canvas_item())


func _process(delta: float) -> void:
	pass


class Sprite:
	var cid: RID
	var texture: Texture2D
	var size: Vector2i
	var frame: int
	var shader: ShaderMaterial


class FrameKey:
	pass


class CharacterAnimation:
	var cid: RID
	var play: bool = false
	var current: Sprite = null
	var sprites: Array[Sprite]
	
	static func create() -> CharacterAnimation:
		var ref: CharacterAnimation = CharacterAnimation.new()
		
		ref.cid = RenderingServer.canvas_item_create()
		
		return ref
	
	func kill() -> void:
		RenderingServer.free_rid(cid)
