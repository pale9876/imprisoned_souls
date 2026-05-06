extends CanvasLayer


# title buttons
@onready var start: Button = %Start
@onready var option: Button = %Option

# class buttons
@onready var class_predator: TextureButton = %ClassPredator
@onready var class_executioner: TextureButton = %ClassExecutioner

# ui layer
@onready var main_title: Control = %MainTitle
@onready var select_class: Control = %SelectClass
@onready var option_panel: Control = %OptionPanel
@onready var background: Node2D = %Background

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	background.show()
	main_title.show()
	select_class.hide()
	option_panel.hide()
	
	start.button_up.connect(
		func() -> void:
			pass
	)
	
	option.button_up.connect(
		func() -> void:
			option_panel.show()
			
	)


#func select_class_mode() -> void:
	#main_title.hide()
	#select_class.show()
#
	#class_predator.pressed.connect(select_class_predator)
	#class_executioner.pressed.connect(select_class_executioner)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
