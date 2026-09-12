# stat.gd
extends RefCounted
class_name Stat


enum ArmorType {
	NONE = 0,
	VEST,
	STAB_VEST,
}


signal hp_expanded()
signal hp_reduced()
signal damaged()
signal dead()
signal healed()


var armor: ArmorType = ArmorType.NONE
var armor_progress: float = 0.:
	set(val):
		armor_progress = clampf(0., 1., val)
var protected_film: float = 0.:
	set(val):
		protected_film = clampf(0., 1., val)
var chara_class: int = - 1
var name: StringName = &""
var level: int = 0
var hp: int = 10:
	set(value):
		hp = maxi(value, 0)
		if hp == 0:
			dead.emit()
var blood: float = 1.:
	set(val):
		blood = clampf(val, 0., 1.)
var max_hp: int = 10
var speed: float = 0.
var atk: int = 1
var def: int = 1


func hp_get_progress() -> float:
	return float(hp) / float(max_hp)


func hp_expand(val: int) -> void:
	var pg: float = hp_get_progress()
	max_hp += val
	
	var current_hp: int = int(float(max_hp) * pg)
	hp = current_hp
	
	hp_expanded.emit()


func hp_reduce(val: int) -> void:
	max_hp -= val
	
	hp_reduced.emit()


func damage(value: int) -> void:
	hp -= value
	damaged.emit()


func heal(value: int) -> void:
	hp += value
	healed.emit()
