extends Node
class_name AEIndexStatInformation


@export_category("추가 스탯")
@export var atk: int = 0
@export_range(0., 1., 0.01) var atk_ratio: float = 0.
@export var def: int = 0
@export_range(0., 1., 0.01) var def_ratio: float = 0.
@export var speed: float = 0.
@export_range(0., 1., 0.01) var speed_ratio: float = 0.
@export_range(0., 1., 0.01) var motion_speed: float = 0.


@export_category("추가 할당 비율 스탯")
@export_range(0., 1., 0.01) var damage_ratio: float = 0.
