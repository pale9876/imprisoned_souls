extends Node2D


var astargrid: AStarGrid2D


func _enter_tree() -> void:
	astargrid = AStarGrid2D.new()
	astargrid.cell_shape = AStarGrid2D.CELL_SHAPE_SQUARE
