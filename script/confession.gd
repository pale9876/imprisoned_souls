# confession.gd
extends AEIndex


# Scene
const ConfessionDebuffScene: PackedScene = preload("uid://bc7w4sc5lem0w")

# Import
const ConfessionDebuff: Script = preload("uid://drvol4efs3hvb")

# Const
const DEBUFF_INDEX_NAME: StringName = &"ConfessionDebuff"


@onready var confession_area: Area2D = $ConfessionArea


var entered_units: Array[Node2D] = []


func _ready() -> void:
	confession_area.body_entered.connect(
		func(body: Node2D) -> void:
			if body is Unit:
				apply_debuff(body)
	)

	confession_area.body_exited.connect(
		func(body: Node2D) -> void:
			if body is Unit and entered_units.has(body):
				remove_debuff(body)
	)


func enable(_act_result: ActionResult = null) -> bool:
	return entered_units.size() >= 2


func apply_debuff(unit: Unit) -> void:
	var debuff: ConfessionDebuff = create_debuff()
	unit.get_ae_library().add_index(debuff)


func remove_debuff(unit: Unit) -> void:
	var target_ae_lib: AEIndexLibrary = unit.get_ae_library()
	
	if target_ae_lib.has_index(NodePath(DEBUFF_INDEX_NAME)):
		var debuff := target_ae_lib.get_ae(DEBUFF_INDEX_NAME)
		target_ae_lib.remove_index(debuff)


func create_debuff() -> ConfessionDebuff:
	var debuff: ConfessionDebuff = ConfessionDebuffScene.instantiate() as ConfessionDebuff
	debuff.name = DEBUFF_INDEX_NAME
	debuff.link = self
	
	return debuff


func _update() -> void:
	if enable():
		pass
