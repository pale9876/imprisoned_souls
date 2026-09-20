@tool
extends Control


signal target_key_pressed()


@export var attr_min_height: float = 32.
@export var attr_max_height: float = 32.


var _listening: ChangingPair = null


@onready var action_name_container: VBoxContainer = %ActionNameContainer
@onready var key_attr_list: VBoxContainer = %KeyAttrList
@onready var key_awating_popup: PopupPanel = $KeyAwatingPopup


func _ready() -> void:
	if Engine.is_editor_hint(): return
	
	key_awating_popup.visible = false
	
	add_actions()


func add_actions() -> void:
	var input_map: Dictionary[StringName, Array] = get_current_ingame_input_keys()
	
	for action_name: StringName in input_map:
		var events := input_map[action_name]
		
		var act_label: Label = Label.new()
		act_label.custom_minimum_size.y = attr_min_height
		act_label.text = action_name
		act_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		act_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		action_name_container.add_child(act_label)
		
		var hbox := HBoxContainer.new()
		hbox.custom_minimum_size.y = attr_min_height
		for value: Variant in events:
			var ev := value as InputEvent
			if ev is InputEventKey:
				var key_btn: Button = create_key_btn(action_name, ev)
				hbox.add_child(key_btn)
		
		key_attr_list.add_child(hbox)


func create_key_btn(action_name: StringName, ev: InputEvent) -> Button:
	var btn := Button.new()
	
	btn.text = ev.as_text()
	var callable: Callable = (
		func(act_name: StringName, _ev: InputEvent) -> void:
			_listening = ChangingPair.pair(act_name, _ev.as_text(), _ev)
			key_awating_popup.popup_centered(Vector2i(300, 100))
			print("create pair")
	).bind(action_name, ev)
	
	btn.button_up.connect(callable)
	
	return btn


func get_current_ingame_input_keys() -> Dictionary[StringName, Array]:
	var actions: Array[StringName] = InputMap.get_actions()
	var cache: Dictionary[StringName, Array] = {}
	
	for key: StringName in actions:
		if !key.begins_with("ui_"):
			cache[key] = InputMap.action_get_events(key)

	return cache


func get_pair() -> ChangingPair:
	return _listening


func clear() -> void:
	key_awating_popup.visible = false
	_listening = null


class ChangingPair:
	var action_name: String
	var ev_name: String
	var ev: InputEvent


	static func pair(_act: String, _ev_name: String, _ev: InputEvent) -> ChangingPair:
		var _new_pair: ChangingPair = ChangingPair.new()
		_new_pair.action_name = _act
		_new_pair.ev_name = _ev_name
		_new_pair.ev = _ev
		
		return _new_pair
	
	
	func change_inputmap(_event: InputEvent) -> void:
		if _event is InputEventKey:
			if !_event.is_echo() and _event.is_pressed():
				InputMap.action_erase_event(action_name, ev)
				InputMap.action_add_event(action_name, _event)
