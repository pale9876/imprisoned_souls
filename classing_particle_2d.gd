@tool
extends BurstParticles2D


func _finish() -> void:
	if tween:
		tween.kill()
	finished_burst.emit()
	finished = true
