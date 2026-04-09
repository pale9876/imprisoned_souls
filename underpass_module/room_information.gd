extends Resource
class_name RoomInformation


@export var name: String
@export var type: Orientation = HORIZONTAL
@export var pos: Vector2
@export var size: Vector2
@export var modulate: Color = Color.WHITE
@export var material: ShaderMaterial
@export var closed: bool = false
@export var disabled: bool = false
