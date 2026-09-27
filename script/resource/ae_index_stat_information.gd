extends Resource
class_name AEIndexStatInformation


@export_group("추가 스탯")
@export var atk: int = 0
@export var def: int = 0
@export var speed: int = 0


@export_group("비율 스탯")
@export_range(- 1., 1., 0.01) var atk_ratio: float = 0.
@export_range(- 1., 1., 0.01) var def_ratio: float = 0.
@export_range(- 1., 1., 0.01) var speed_ratio: float = 0.
@export_range(- 1., 1., 0.01) var motion_speed: float = 0.
@export_range(- 1., 1., 0.01) var give_damage: float = 0.
@export_range(- 1., 1., 0.01) var take_damage: float = 0.
