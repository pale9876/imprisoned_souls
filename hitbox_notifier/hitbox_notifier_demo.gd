@tool
extends Endeka

func hitbox_notifier_engage(pos: Vector2, info: HitboxInformation) -> void:
	pos = Vector2()
	info.duration = 1.
