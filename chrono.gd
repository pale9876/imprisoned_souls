extends Node


const DAYTIME: int = 86400


var progress: float = 0.
var second: float = 0.


func _init() -> void:
	progress = get_current_progress_from_sys()
	second = get_current_total_second()


func _process(delta: float) -> void:
	second += delta
	progress = second / DAYTIME


func get_current_total_second() -> float:
	var _systime: Dictionary = Time.get_datetime_dict_from_system()
	
	var _hour := float(_systime["hour"] as int)
	var _min := float(_systime["minute"] as int)
	var _sec := float(_systime["second"] as int)
	
	return (_hour * 60. * 60.) + (_min * 60.) + _sec



func get_current_progress_from_sys() -> float:
	return get_current_total_second() / DAYTIME


	
