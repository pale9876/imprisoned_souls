@tool
extends Control


@export var attr_min_height: float = 32.
@export var attr_max_height: float = 32.


var _listening: ChangingPair = null


@onready var action_name_container: VBoxContainer = %ActionNameContainer
@onready var key_attr_list: VBoxContainer = %KeyAttrList


func _ready() -> void:
	if Engine.is_editor_hint(): return
	
	add_actions()


func add_actions() -> void:
	var input_map: Dictionary[StringName, Array] = get_current_ingame_input_keys()
	
	for action_name: StringName in input_map:
		var events := input_map[action_name]
		
		var label: Label = Label.new()
		label.custom_minimum_size.y = attr_min_height
		label.text = action_name
		action_name_container.add_child(label)
		
		var hbox := HBoxContainer.new()
		hbox.custom_minimum_size.y = attr_min_height
		for value: Variant in events:
			var ev = value as InputEvent
			var key_btn: Button = create_key_btn(action_name, ev)
			hbox.add_child(key_btn)
		key_attr_list.add_child(hbox)


func _unhandled_input(event: InputEvent) -> void:
	if Engine.is_editor_hint(): return
	
	if event.is_pressed() and _listening != null:
		pass


func _clear() -> void:
	for node: Node in action_name_container.get_children():
		node.queue_free()
	
	for node: Node in key_attr_list.get_children():
		node.queue_free()


func create_key_btn(action_name: StringName, ev: InputEvent) -> Button:
	var btn := Button.new()
	btn.text = ev.as_text()
	var callable: Callable = (
		func(act_name: StringName, _ev: InputEvent) -> void:
			_listening = ChangingPair.new()
			_listening.action_name = act_name
			InputMap.action_erase_event(act_name, ev)
	).bind(action_name, ev)
	
	btn.button_up.connect(callable)
	
	return btn


func change_input(from: String, to: String) -> void:
	var evs := InputMap.action_get_events(from)
	var ev_key = InputEventKey.new()
	
	#InputMap.action_erase_event(from, )
	#InputMap.action_add_event(to, )


func get_current_ingame_input_keys() -> Dictionary[StringName, Array]:
	var actions: Array[StringName] = InputMap.get_actions()
	var cache: Dictionary[StringName, Array] = {}
	for key: StringName in actions:
		if !key.begins_with("ui_"):
			cache[key] = InputMap.action_get_events(key)

	return cache


class ChangingPair:
	var action_name: String = ""
	var ev_name: String = ""
	var ev: InputEvent = null


	
