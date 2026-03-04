@tool
extends Node
class_name Inventory


signal used(used: ItemBase, user: StringName)


var cache: Dictionary[ItemBase, Dictionary] = {}


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENTER_TREE:
			var _parent: Node = get_parent()
			if _parent:
				if _parent is Character:
					_parent.inventory = self


func add_item(item: ItemBase) -> void:
	if !cache.has(item):
		var dict: Dictionary = {
			"amount" : 1
		}
		cache[item] = dict
	
	cache[item]["amount"] += 1


func use_item(item: ItemBase, usage: int, effect: Dictionary) -> bool:
	if !cache.has(item):
		printerr("Inventory => 아이템을 소지하고 있지 않습니다.")
		return false
	
	if cache[item].has("amount"):
		if cache[item]["amount"] > usage:
			cache[item]["amount"] -= usage
			
			if cache[item]["amount"] == 0:
				cache.erase(item)
			
			used.emit(item, _get_root().name)
	elif item.unique:
		if cache[item].has("has"):
			var state: bool = cache[item]["has"]
			
			if !state:
				printerr("Inventory => 해당 아이템을 소지하고 있지 않습니다.")
				return false
	
			cache[item]["has"] = false
			used.emit(item, _get_root().name)
	
	
	return true


func remove_item(item: ItemBase, amount: int) -> bool:
	if cache.has(item):
		if cache[item]["amount"] < amount:
			cache[item]["amount"] -= amount
			return true
			
	return false


func _get_root() -> Node:
	return get_parent()
