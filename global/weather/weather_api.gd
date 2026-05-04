extends Node


const WINTER_BRIGHTNESS_CURVE: Curve = preload("uid://dbugn338oegsq")
const MAX_SEC: float = 60. * 60. * 24.

var time_scale: float = 1.

var _current: float = 0.


func _init() -> void:
	var sys_time: Dictionary = Time.get_datetime_dict_from_system(true)
	# year, month, day, weekday, hour, minute, second, and dst (Daylight Savings Time).
	
	var year: int = sys_time["year"]
	var month: int = sys_time["month"]
	var day: int = sys_time["day"]
	var hour: int = sys_time["hour"]
	var minute: int = sys_time["minute"]
	var sec: int = sys_time["second"]
	
	_current = get_time_from_sys()
	
	print(
		"현재 시간 => ",
		year, "년 ",
		month, "월 ",
		day, "일 ",
		hour, "시간 ",
		minute, "분 ",
		sec, "초"
	)


func _process(delta: float) -> void:
	_elapsed(delta * time_scale)


func get_time_from_sys() -> float:
	var sys_time: Dictionary = Time.get_datetime_dict_from_system(true)
	
	var _hour: int = sys_time["hour"]
	var _minute: int = sys_time["minute"]
	var _second: int = sys_time["second"]
	
	var h_to_s: float = float(_hour) * 60. * 60.
	var m_to_s: float = float(_minute) * 60.
	var current_sec_value: float = float(_second) + h_to_s + m_to_s
	
	return current_sec_value


func get_day_bright() -> float:
	var result: float = _current / MAX_SEC
	
	return WINTER_BRIGHTNESS_CURVE.sample_baked(result)


func _elapsed(sec: float) -> void:
	_current += sec
	if MAX_SEC < _current:
		var remainder: float = _current - MAX_SEC
		_current = remainder
