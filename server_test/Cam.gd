@tool
extends Resource
class_name Cam


var cid: RID

@export var position: Vector2
@export_range(0., 1., .001) var zoom: float = 1.
@export var color: Color
@export var speed: float = 4.5

var target: Node2D
