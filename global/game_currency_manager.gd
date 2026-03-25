@tool
extends Node


const NOTIFICATION_MONETARY_UNIT_ADDED: int = 31000


var cache: Dictionary[StringName, Currency] = {}
var path: String = ""


func _ready() -> void:
	path = ProjectSettings.get("global/currency_resource_path")


func init_monetary(res: Currency) -> bool:
	if !cache.has(res.monetary_name):
		cache[res.monetary_name] = res
		return true
	return false


func get_currency_value(monetary_name: StringName, amount: int) -> float:
	var result: float = 0.

	if cache.has(monetary_name):
		result = cache[monetary_name].currency_value * float(amount)

	return result


func get_total_point(inventory: Dictionary[StringName, int]) -> float:
	var result: float = 0.
	
	for monetary: StringName in inventory:
		result += get_currency_value(monetary, inventory[monetary])
	
	return result
