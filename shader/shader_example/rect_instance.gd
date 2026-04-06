@tool
extends Resource
class_name LegionInstance

@export var use_nav: bool = false
@export var shader: ShaderMaterial = ShaderMaterial.new()
@export var position: Vector2 = Vector2(0., 0.)
@export var size: Vector2 = Vector2(32., 32.)
@export var frame_size: Vector2 = Vector2(64., 64.)
@export var offset: float = 0.
@export var texture: AtlasTexture
@export var hitbox_info: HitboxInformation

#[0]: start frame, [1]: end frame, [2] progress, [3] [[frame, callable], [frame, callable]]
@export var animation: Dictionary[String, Array] = {
	
}

@export var stat: UnitStat

var hitbox: RID
var hurtbox: RID
var cid: RID
