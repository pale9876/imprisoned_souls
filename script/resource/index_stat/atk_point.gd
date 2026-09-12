extends IndexStat
class_name ATKPoint


@export var point: int = 0


func apply(unit: Replicator) -> void:
	unit.stat.atk += point


func remove(unit: Replicator) -> void:
	unit.stat.atk -= point
