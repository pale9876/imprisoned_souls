extends Node


func roll_dice() -> float:
	randomize()
	return randf()
