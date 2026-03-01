extends Node
class_name Inventory


signal used_item(used: ItemBase)


var cache: Dictionary[ItemBase, Dictionary] = {}


func add_item(item: ItemBase) -> void:
	if !cache.has(item):
		var dict: Dictionary = {
			"amount" : 1
		}
		cache[item] = dict
	
	cache[item]["amount"] += 1


func use_item(item: ItemBase, usage: int, effect: Dictionary) -> bool:
	if cache.has(item):
		if cache[item].has("amount"):
			if cache[item]["amount"] > usage:
				cache[item]["amount"] -= usage
				used_item.emit(item)
				
				if cache[item]["amount"] == 0:
					cache.erase(item)
			
			return true
	
	return false


func remove_item(item: ItemBase, amount: int) -> bool:
	if cache.has(item):
		if cache[item]["amount"] < amount:
			cache[item]["amount"] -= amount
			return true
			
	return false
