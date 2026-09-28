extends Node


const INPUT_POSTPONE: int = 10


signal punch()
signal kick()


var input_cache: PackedStringArray = PackedStringArray()
var prev_input_dir: int = 0


var _postpone: int = 0:
	set(value):
		_postpone = maxi(value, 0)
		
var direction: Vector2 = Vector2.ZERO:
	set(value):
		if !_lock:
			direction = value
var _duration: float = 0.:
	set(value):
		_duration = maxf(0., value)
var _lock: bool = false


func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func _physics_process(_delta: float) -> void:
	if _postpone > 0:
		_postpone -= 1
	
	if _postpone == 0:
		clear()
	

func _input(event: InputEvent) -> void:
	if event.is_pressed() and !event.is_echo():
		if Input.is_action_just_pressed(&"left") or Input.is_action_just_pressed(&"right"):
			var input_dir_x: int = int(Input.get_action_strength("right") - Input.get_action_strength("left"))
			if prev_input_dir == input_dir_x:
				input_cache.push_back("front")
				#print("push back front")
			else:
				prev_input_dir = input_dir_x
				clear()
				input_cache.push_back("front")
				#print("cache clear and push back front")
			
		elif Input.is_action_just_pressed(&"down"):
			input_cache.push_back("down")
		elif Input.is_action_just_pressed(&"up"):
			input_cache.push_back("up")
		
		if Input.is_action_just_pressed(&"attack"):
			input_cache.push_back("attack")
			punch.emit()
		if Input.is_action_just_pressed(&"kick"):
			input_cache.push_back("kick")
			kick.emit()
		
		_postpone = INPUT_POSTPONE



func clear() -> void:
	input_cache.clear()


func get_cached() -> PackedStringArray:
	return input_cache


func lock() -> void:
	_lock = true


func unlock() -> void:
	_lock = false


func locked() -> bool:
	return _duration > 0.
