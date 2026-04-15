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
@export var front_hair: Texture2D
@export var front_hair_color: Color = Color.WHITE

@export var right_side_hair: Texture2D
@export var right_side_hair_color: Color = Color.WHITE

@export var left_side_hair: Texture2D
@export var left_side_hair_color: Color = Color.WHITE

@export var back_hair: Texture2D
@export var back_hair_color: Color = Color.WHITE

@export_category("Face")
@export var face: Texture2D
@export var face_color: Color = Color.WHITE

@export var eye: Texture2D
@export var eye_color: Color = Color.WHITE

@export_category("Body")
@export var top: Texture2D
@export var bottom: Texture2D
