@tool
extends NinePatchMarginContainer
class_name PresentationMainScreen


const NOTIFICATION_HOLDED: int = 17000


var _clicked: bool = false
var _hold: float = 0.:
	set(value):
		_hold = value
		if _clicked and value > 1.7:
			notification(NOTIFICATION_HOLDED)


func _process(_delta: float) -> void:
	pass


func _notification(what: int) -> void:
	super(what)
	
	match what:
		NOTIFICATION_PROCESS:
			var _delta: float = get_process_delta_time()
			_hold += _delta
		
		NOTIFICATION_HOLDED:
			_hold = 0.
			_clicked = false
			_hold_ev_handler()


func _gui_input(event: InputEvent) -> void:
	if Engine.is_editor_hint(): return
	
	if event is InputEventMouseButton:
		if !event.is_echo():
			if event.is_pressed():
				if event.button_index == MOUSE_BUTTON_LEFT:
					_clicked = true
			elif event.is_released():
				if event.button_index == MOUSE_BUTTON_LEFT:
					_clicked = false

		


func _hold_ev_handler() -> void:
	pass
	
	
	
