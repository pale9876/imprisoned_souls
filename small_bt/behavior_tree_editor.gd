@tool
extends Tree
class_name BehaviorTreeEditor


const NOTIFICATION_TREE_CHANGED: int = 41000

const ROOT_SEQUENCE_COLOR: Color = Color(0.098, 0.7, 0.7, 0.533)
const SEQUENCE_COLOR: Color = Color(0.102, 0.73, 0.73, 0.102)


@export var behaviour_tree: BehaviorTree = null:
	set(res):
		if res != behaviour_tree:
			behaviour_tree = res
			#change_tree(res)


var _root: TreeItem = null


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENTER_TREE:
			if behaviour_tree:
				clear()
				_create_tree()

		NOTIFICATION_TREE_CHANGED:
			if behaviour_tree:
				clear()
				_create_tree()



func _create_tree() -> void:
	_root = _create_root(behaviour_tree.sequence)
	_create_task(_root, behaviour_tree.sequence)


# Recursive
func _create_task(root_item: TreeItem, _task: Task) -> void:
	if _task is Sequence:
		for seq: Task in _task.task:
			var sequence_item: TreeItem = create_item(root_item)
			sequence_item.set_custom_bg_color(0, SEQUENCE_COLOR)
			sequence_item.set_text(0, _task.name)
			_create_task(sequence_item, seq)
	else:
		var task_item: TreeItem = create_item(root_item)
		task_item.set_text(0, _task.name)
		# TODO: Task BG Color가 필요한가?



func _create_root(res: Sequence) -> TreeItem:
	var _item: TreeItem = create_item()
	_item.set_text(0, res.name)
	_item.set_custom_bg_color(0, ROOT_SEQUENCE_COLOR)
	
	return _item


func change_tree(_res: BehaviorTree) -> void:
	behaviour_tree = _res
	notification(NOTIFICATION_TREE_CHANGED)
