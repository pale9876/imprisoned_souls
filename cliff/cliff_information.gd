extends Resource
class_name CliffInformation


const MIN_STEP: int = 8
const MAX_STEP: int = 256


@export_category("Ground Area")
@export var size: Vector2
@export var texture: GradientTexture2D


@export_category("Ground Line")
@export var has_area_outline: bool = true
@export var outline_color: Color = Color.WHITE
@export var width: float = - 1.


@export_category("Cliff")
@export var gradient: GradientTexture1D
@export_range(MIN_STEP, MAX_STEP) var step: int = 32
@export var min_height: float = 30.:
	set(value):
		min_height = maxf(0., value)
@export var max_height: float = 100.:
	set(value):
		max_height = maxf(min_height, value)
