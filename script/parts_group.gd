# 항상 Upper / Lower / Weapon으로 나누어집니다.
@tool
extends Node2D
class_name PartsGroup


@export var parts_order: Dictionary[String, Array] = {
	"Default" : ["Upper", "Lower", "Weapon"]
}
@export var order: String = "Default"



	
