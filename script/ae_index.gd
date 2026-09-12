extends Node
class_name AEIndex


@export_group("활성화 시")
@export var when_activate: Array[IndexStat]

@export_group("비활성화 시")
@export var when_deactivate: Array[IndexStat]


func activate() -> void:
	var unit := get_unit()
	for index: IndexStat in when_activate:
		var timer: Timer = Timer.new()
		add_child(timer)
		timer.start(index.duration)
		index.apply(unit)
		timer.timeout.connect(
			func() -> void:
				index.remove(unit)
				timer.queue_free.call_deferred()
		)


func deactivate() -> void:
	var unit := get_unit()
	for index: IndexStat in when_activate:
		var timer: Timer = Timer.new()
		add_child(timer)
		timer.start(index.duration)
		index.apply(unit)
		timer.timeout.connect(
			func() -> void:
				index.remove(unit)
				timer.queue_free.call_deferred()
		)


func get_lib() -> AEIndexLibrary:
	return get_parent() as AEIndexLibrary


func get_unit() -> Replicator:
	return get_lib().get_parent() as Replicator
