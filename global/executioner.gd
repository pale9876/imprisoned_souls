extends Node


var events: Array[Event] = []


func _physics_process(delta: float) -> void:
	if !events.is_empty():
		for ev: Event in events:
			_execute(ev)


func _execute(ev: Event) -> bool:
	if !Global.main_scene: return false
	
	ev.info
	
	return true


func append_ev(_from: Node, _to: Node, _ev: Dictionary) -> void:
	var ev: Event = Event.create_ev(_from, _to, _ev)
	events.push_back(ev)


class Event:
	var from: Node
	var to: Node
	var info: Dictionary

	static func create_ev(_from: Node, _to: Node, _info: Dictionary) -> Event:
		var ev: Event = Event.new()
		ev.from = _from
		ev.to = _to
		ev.info = _info
		return ev
