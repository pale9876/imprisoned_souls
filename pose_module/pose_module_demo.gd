extends Node2D


@export var pose_information: PoseInformation


var pose_module: PoseModule


func _enter_tree() -> void:
	pose_module = PoseModule.new()
	pose_module.init_data(pose_information.data, pose_information.init_pose, {"duration": 5.})


func _process(delta: float) -> void:
	pose_module.update(delta)


func _physics_process(delta: float) -> void:
	pose_module.tick(delta)
