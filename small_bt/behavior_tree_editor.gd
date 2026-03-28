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
				create_tree(behaviour_tree)

		NOTIFICATION_TREE_CHANGED:
			if behaviour_tree:
				clear()
				create_tree(behaviour_tree)


func create_tree(res: BehaviorTree) -> void:
	var root_item: TreeItem = create_item()
	root_item.set_text(0, res.name)
	_create_task(res._root, root_item)


# Recursive
func _create_task(_task: Task, rt: TreeItem = null) -> void:
	if _task is Sequence:
		var _sequence: Sequence = _task as Sequence
		for task: Task in _sequence.task:
			var sequence_item: TreeItem = create_item(rt)
			sequence_item.set_custom_bg_color(0, SEQUENCE_COLOR)
			sequence_item.set_text(0, _task.name)
			_create_task(task, sequence_item)
	else:
		var task_item: TreeItem = create_item(rt) as TreeItem
		#task_item.task = _task
		task_item.set_text(0, _task.name)
		# TODO: Task BG Color가 필요한가?


func change_tree(_res: BehaviorTree) -> void:
	behaviour_tree = _res
	notification(NOTIFICATION_TREE_CHANGED)
