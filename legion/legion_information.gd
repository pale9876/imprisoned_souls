@tool
extends Resource
class_name LegionInformation

@export_category("Informations")
@export var use_nav: bool = false
@export var unit_information: UnitInformation = UnitInformation.new()
@export var hurtbox_information: HurtboxInformation = HurtboxInformation.new()
@export var awareness_information: AwarenessInformation = AwarenessInformation.new()
@export var hitbox_information: HitboxInformation = HitboxInformation.new()
@export var behavior_tree: BehaviorTree
@export var path_update_interval: float = .75
