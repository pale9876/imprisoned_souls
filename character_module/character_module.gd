@tool
extends Resource
class_name CharacterModule


enum Type
{
	CHILD,
	YOUTH,
	ADULT,
}


const TYPE_CHILD: Type = Type.CHILD
const TYPE_YOUTH: Type = Type.YOUTH
const TYPE_ADULT: Type = Type.ADULT


@export_category("Base")
@export var type: Type = TYPE_CHILD

@export_category("Hair")
@export var front_hair: AtlasTexture = AtlasTexture.new()
@export var front_hair_color: Color = Color.WHITE

@export var right_side_hair: AtlasTexture = AtlasTexture.new()
@export var right_side_hair_color: Color = Color.WHITE

@export var left_side_hair: AtlasTexture = AtlasTexture.new()
@export var left_side_hair_color: Color = Color.WHITE

@export var back_hair: AtlasTexture = AtlasTexture.new()
@export var back_hair_color: Color = Color.WHITE


@export_category("Face")
@export var face: AtlasTexture = AtlasTexture.new()
@export var face_color: Color = Color.WHITE

@export var eye: AtlasTexture = AtlasTexture.new()
@export var eye_color: Color = Color.WHITE

@export_category("Body")
@export var top: AtlasTexture = AtlasTexture.new()
@export var bottom: AtlasTexture = AtlasTexture.new()


@export_category("Accessory")
@export var front_accessory: AtlasTexture = AtlasTexture.new()
@export var back_accessory: AtlasTexture = AtlasTexture.new()
