@tool
extends Node


var timers: Array[RFTimer]
var MAX_COUNT: int = 256


func _process(delta: float) -> void:
	if !timers.is_empty():
		for timer: RFTimer in timers:
			timer.left -= delta
			if timer.left == 0.:
				timer.timeout.emit()
				timers.erase(timer)


func create_timer(duration: float = 1.) -> RFTimer:
	var timer: RFTimer = RFTimer.new()
	
	if timers.size() - 1 == MAX_COUNT:
		printerr("만들 수 있는 RF타이머가 한계에 도달하였습니다.")
	else:
		timer.left = duration
		timers.push_back(timer)
	
	return timer

class RFTimer:
	signal timeout()
	
	var left: float = 1.:
		set(value):
			left = maxf(0., value)
