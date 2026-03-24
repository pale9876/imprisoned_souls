extends Resource
class_name Currency


@export var empire_livre: int
@export var yen: int
@export var point_credit: float

var total_value: int:
	get:
		return get_total_value()


#func get_total_denier() -> int:
	#return (livre * 240) + (sol * 12) + denier


func change_to_livre() -> int:
	return 0

func get_total_value() -> int:
	return 0
