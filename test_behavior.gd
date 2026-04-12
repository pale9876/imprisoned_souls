extends Node


const SUCCESS: BT.Status = BT.Status.SUCCESS
const RUNNING: BT.Status = BT.Status.RUNNING
const FAILED: BT.Status = BT.Status.FAILURE


var bt: BehaviorTree


func _enter_tree() -> void:
	bt = BehaviorTree.new()
	
	var mini_seq: MiniSequence = MiniSequence.new()
	bt.set_root_task(mini_seq)
	mini_seq.add_child(MiniTask.new())


func _physics_process(delta: float) -> void:
	bt.get_root_task().execute(delta)


class MiniSequence extends BTSequence:
	pass


class MiniTask extends BTAction:
	func _enter() -> void:
		print("Hello")
	
	func _tick(delta: float) -> Status:
		if elapsed_time > 1.:
			return SUCCESS
		return RUNNING
	
	
	func _exit() -> void:
		print("Good bye")
