extends Control


# Import
const TitleUiButton: Script = preload("uid://chmqpyka2hi81")
const ClassList: Script = preload("uid://cdgr4w6hpl2ud")
const CharacterList: Script = preload("uid://dq6jdkets46eg")
const RadioButtonContainer: Script = preload("uid://dgxb13iyu7nlx")
const GateScreen: Script = preload("uid://bpje5fqosbd7a")


@onready var gate_screen: GateScreen = %GateScreen
@onready var ingame_option_ui: Control = %IngameOptionUI
#@onready var enter_btn: Button = %Enter
@onready var title_screen: TextureRect = %TitleScreen


func _ready() -> void:
	ingame_option_ui.visible = false
	
	var _first_page := first_page()
	var _second_page := second_page()
	
	_first_page.show()
	title_ui().show()
	
	_second_page.hide()
	get_achievements().hide()
	get_chara_settings().hide()
	get_class_settings().hide()
	
	get_start_btn().button_up.connect(
		func() -> void:
			GSignal.start.emit()
	)
	
	get_map_editor_btn().button_up.connect(
		func() -> void:
			pass
	)
	
	get_ingame_option_btn().button_up.connect(
		func() -> void:
			ingame_option_ui.visible = true
			
	)

	get_profile_btn().button_up.connect(
		func() -> void:
			_first_page.hide()
			_second_page.show()
	)
	
	get_class_btn().button_up.connect(
		func() -> void:
			get_class_settings().show()
			get_main_ui().hide()
	)
	

	get_chara_radio_containers().toggled.connect(
		func() -> void:
			pass
	)
	
	initialize()
	
	gate_screen.get_enter_btn().button_up.connect(
		func () -> void:
			gate_screen.visible = false
			get_main_ui().visible = true
			title_screen.visible = true
	)



func initialize() -> void:
	title_screen.visible = false
	get_main_ui().visible = false
	gate_screen.visible = true



func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_cancel"):
		if second_page().visible:
			first_page().show()
			second_page().hide()


# Get (UI)

func get_chara_list() -> CharacterList:
	return get_node(^"%CharacterList") as CharacterList


func get_chara_radio_containers() -> RadioButtonContainer:
	return get_chara_list().get_radio_btn_container()


func get_main_ui() -> Control:
	return get_node(^"%MainUI") as Control


func get_achievements() -> Control:
	return get_node(^"%PlayerAchievements") as Control


func get_chara_settings() -> Control:
	return get_node(^"%CharacterSettings") as Control


func get_class_list() -> ClassList:
	return get_node(^"%ClassList") as ClassList


func first_page() -> Control:
	return get_node(^"%FirstPage") as Control


func get_start_btn() -> Button:
	return get_node(^"%Start") as Button


func get_ingame_option_btn() -> Button:
	return get_node(^"%Option") as Button


func get_profile_btn() -> Button:
	return get_node(^"%Profile") as Button


func get_achievement_btn() -> Button:
	return get_node(^"%Achievement") as Button


func get_map_editor_btn() -> Button:
	return get_node(^"%MapEditor") as Button


func get_class_btn() -> Button:
	return get_node(^"%Class") as Button


func get_class_settings() -> Control:
	return get_node(^"%ClassSettings") as Control


func title_ui() -> Control:
	return get_node(^"%TitleUI") as Control


func second_page() -> Control:
	return get_node(^"%SecondPage") as Control
	
	
