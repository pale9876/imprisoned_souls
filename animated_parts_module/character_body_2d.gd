@tool
extends CharacterBody2D


const NOTIFICATION_TEXTURE_CHANGED: int = 44000


@export var texture: Texture2D:
	set(_texture):
		texture = _texture
		notification(NOTIFICATION_TEXTURE_CHANGED)

@export var stat: UnitStat
@export var skills: Array[Skill]


@export var z_value: float:
	set(value):
		z_value = value


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENTER_TREE:
			set_notify_transform(true)
		
		NOTIFICATION_TRANSFORM_CHANGED:
			for child in get_children():
				if child is Node2D:
					child.notification(NOTIFICATION_TRANSFORM_CHANGED)


func add_skill(skill: Skill) -> void:
	pass


func change_collider(c_name: StringName) -> void:
	for node: Node in get_children():
		if node is NotificationShape2D:
			node.visible = (node.name == c_name)


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	var input_vector: Vector2 = Input.get_vector("left", "right", "up", "down")
	
	if input_vector != Vector2():
		pass
	else:
		pass
	
	
	move_and_slide()
