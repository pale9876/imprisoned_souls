@tool
extends Area2D
class_name Hurtbox2D


enum State {
	통상 = 0,
	하단회피 = 1,
	상단회피 = 1 << 1,
	원거리면역 = 1 << 2,
	근거리면역 = 1 << 3,
}


@export var _root: Node = null
@export var flip: bool:
	set(toggle):
		flip = toggle
		scale.x = - scale.x

@export var init_shape: Array[NotificationShape2D] = []

@export_flags(
	"하단회피", "상단회피",
	"원거리면역", "근거리면역",
) var state: int = State.통상

@export var danger: bool = false

@export_flags_2d_physics var mask: int = 0: set = set_mask


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_POSTINITIALIZE:
			monitoring = false
			monitorable = true
		
		NOTIFICATION_ENTER_TREE:
			var _parent: Node = get_parent()
			if _parent != null:
				if _parent is Character:
					_parent.hurtbox = self
					_root = _parent
					if !Engine.is_editor_hint():
						pass

		NOTIFICATION_READY:
			if !init_shape.is_empty():
				change_shapes(
					get_init_shapes()
				)

		NOTIFICATION_VISIBILITY_CHANGED:
			monitorable = visible
			
			for node: Node in get_children():
				if init_shape.has(node):
					node.visible = true
				node.visible = visible

		NOTIFICATION_EXIT_TREE:
			if get_root():
				if _root:
					if _root is Character:
						_root.hurtbox = null
					_root = null

		NOTIFICATION_CHILD_ORDER_CHANGED:
			pass


func get_init_shapes() -> PackedStringArray:
	var result: PackedStringArray = []
	for child: Node in get_children():
		if child is NotificationShape2D and init_shape.has(child):
			result.push_back(child.name)

	return result

func set_mask(value: int) -> void:
	mask = value
	collision_mask = mask


func change_shape(s_name: StringName) -> bool:
	var _index: int = _find_shape(s_name)
	var result: bool = _index > -1
	
	return result


func _find_shape(node_name: StringName) -> int:
	var result: int = -1

	for n: Node in get_children():
		if n is NotificationShape2D:
			var is_equal: bool = node_name == n.name
			n.visible = is_equal
			if is_equal:
				result = n.get_index()
				#_current = n

	return result


func change_shapes(shape_names: Array[StringName]) -> void:
	var cache: PackedInt64Array = []
	var children: Array[Node] = get_children()
	
	for shape_name: StringName in shape_names:
		var node: Node = get_node_or_null(NodePath(shape_name))
		if node:
			var node_idx: int = node.get_index()
			cache.push_back(node_idx)
	
	for node: Node in children:
		if node is NotificationShape2D:
			node.visible = cache.has(node.get_index())


func get_root() -> Node:
	return _root
