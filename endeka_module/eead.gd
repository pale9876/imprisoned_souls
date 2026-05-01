@tool
extends Node
class_name EEAD

# INFO
# Z축을 실수값으로 받는 2D 객체입니다.

const UV_DEFAULT: PackedVector2Array = [
	Vector2(),
	Vector2(1., 0.),
	Vector2(1., 1.),
	Vector2(0., 1.)
]


@export_category("Warning")
@export var do_not_test_in_editor: bool = false


@export_category("2.5")
@export var pin: bool = false
@export var z_value: float:
	set(value):
		if !pin:
			if get_parent() and get_parent() is Endeka:
				var parent: Endeka = get_parent() as Endeka
				z_value = clampf(value, parent.min_z, parent.max_z)
				parent.notification(Endeka.NOTIFICATION_EEAD_Z_VALUE_CHANGED)
			else:
				z_value = value
@export var position: Vector2 = Vector2():
	set(value):
		position = value
		RenderingServer.canvas_item_set_transform(get_canvas_item(), transform)
		if get_parent() is Endeka or get_parent() is CanvasLayer:
			if get_parent().ysorting:
				get_parent().notification(Endeka.NOTIFICATION_EEAD_Z_VALUE_CHANGED)
@export var scale: Vector2 = Vector2.ONE:
	set(value):
		scale = value
		RenderingServer.canvas_item_set_transform(get_canvas_item(), transform)
@export var rotation: float = 0.:
	set(value):
		rotation = value
		RenderingServer.canvas_item_set_transform(get_canvas_item(), transform)
@export var skew: float = 0.:
	set(value):
		skew = value
		RenderingServer.canvas_item_set_transform(get_canvas_item(), transform)


var transform: Transform2D:
	get:
		return Transform2D(deg_to_rad(rotation), scale, deg_to_rad(skew), position)


var cached_items: Array[RID]


@export var visible: bool = true:
	set(toggle):
		visible = toggle
		RenderingServer.canvas_item_set_visible(canvas_item, toggle)
@export var auto_init: bool = false
@export_tool_button("Create", "2D") var _create: Callable = create


var init: bool = false
var canvas_item: RID


func get_canvas_item() -> RID:
	return canvas_item


func get_canvas() -> RID:
	return get_parent().get_canvas()


func _init() -> void:
	canvas_item = RenderingServer.canvas_item_create()


func free() -> void:
	if init:
		RenderingServer.free_rid(canvas_item)


func _notification(what: int) -> void:
	if what == NOTIFICATION_ENTER_TREE:
		if get_parent() is Endeka:
			RenderingServer.canvas_item_set_parent(get_canvas_item(), get_canvas())
		
		if auto_init:
			create()

	elif what == NOTIFICATION_EXIT_TREE:
		RenderingServer.canvas_item_set_parent(get_canvas_item(), RID())


func create_canvas_item() -> RID:
	var cid: RID = RenderingServer.canvas_item_create()
	cached_items.push_back(cid)
	return cid


func remove_item(rid: RID) -> bool:
	if cached_items.has(rid):
		RenderingServer.canvas_item_clear(rid)
		RenderingServer.free_rid(rid)
		cached_items.erase(rid)
		return true
	
	return false


func clear() -> void:
	for item: RID in cached_items:
		RenderingServer.canvas_item_clear(item)
		RenderingServer.free_rid(item)
	
	cached_items.clear()


# OVERRIDE
func create() -> void:
	pass


# OVERRIDE
func kill() -> void:
	pass
