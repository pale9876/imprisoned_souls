@tool
extends Resource
class_name CollideInfo


const NOTIFICATION_POSITION_CHANGED: int = 3201
const NOTIFICATION_SIZE_CHANGED: int = 3202

var _index: int = -1

var _shape: RID
var _owner: Object


@export var name: StringName = &""
@export var position: Vector2 = Vector2():
	set(value):
		position = value
		notification(NOTIFICATION_POSITION_CHANGED)
@export var size: Vector2 = Vector2(10., 10.):
	set(value):
		size = value
		notification(NOTIFICATION_SIZE_CHANGED)
@export var disabled: bool = true


func get_shape_rid() -> RID: return _shape

func get_owner() -> Object: return _owner
func get_index() -> int: return _index


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_POSITION_CHANGED:
			if _owner is ManganiaUnit2D:
				var body_rid: RID = _owner.get_body_rid()
				
				PhysicsServer2D.body_set_shape_transform(
					body_rid, 
					_index,
					Transform2D(0., position - (size / 2.) if _owner.collision_draw_up else position)
				)
				
				_owner.queue_redraw()
		
		NOTIFICATION_SIZE_CHANGED:
			if _owner is ManganiaUnit2D:
				var body_rid: RID = _owner.get_body_rid()
				
				PhysicsServer2D.shape_set_data(
					_shape, size
				)
				
				if _owner.collision_draw_up:
					PhysicsServer2D.body_set_shape_transform(
						body_rid, _index, Transform2D(0., position - (size / 2.))
					)
				
				_owner.queue_redraw()


func set_owner(unit: Object) -> void:
	_owner = unit


static func create(collider_name: StringName) -> CollideInfo:
	var res: CollideInfo = CollideInfo.new()
	
	res.name = collider_name
	res._shape = PhysicsServer2D.rectangle_shape_create()
	res.disabled = true

	return res


func remove() -> void:
	_index = - 1
	_owner = null
	PhysicsServer2D.free_rid(_shape)


func _draw(cid: RID, color: Color) -> void:
	if !disabled:
		RenderingServer.canvas_item_clear(cid)
		
		RenderingServer.canvas_item_add_rect(
			cid, Rect2((position - size / 2.), size), color
		)
