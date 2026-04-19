@tool
extends EEAD
class_name Squad

@export_category("Informations")
@export var has_body: bool = false
@export var unit_information: UnitInformation = UnitInformation.new()
@export var path_scope: PathScope = PathScope.new()
@export var max_count: int = 3


@export_category("Option")
@export var pre_init: bool = false
@export var xsorting: bool = true


var leader: SquadMember
var members: Array[SquadMember]
var message_log: PackedStringArray
var path: Curve2D


func create() -> void:
	if init:
		kill()

	if path_scope:
		create_path()
	
	if Engine.is_editor_hint():
		path_scope.draw_path(get_canvas_item())
	elif !Engine.is_editor_hint():
		members.resize(max_count)
	
	init = true


func kill() -> void:
	RenderingServer.canvas_item_clear(get_canvas_item())


func add_member(unit_info: UnitInformation, offset: float, index: int = -1) -> void:
	var member: SquadMember = SquadMember.new()
	member.cid = RenderingServer.canvas_item_create()
	RenderingServer.canvas_item_set_parent(member.cid, get_canvas_item())
	
	if index < 0:
		for i:int in range(members.size()):
			if !members[i]:
				members[i] = member
				break
		var init_pos: Vector2 = path.sample_baked(path.get_baked_length() * offset)
		
		if has_body:
			var _body: RID = PhysicsServer2D.body_create()
			PhysicsServer2D.body_set_mode(_body, PhysicsServer2D.BODY_MODE_KINEMATIC)
			member.body = _body
			
			var _shape: RID = PhysicsServer2D.rectangle_shape_create()
			member.shape = _shape
		
			PhysicsServer2D.body_set_state(_body, PhysicsServer2D.BODY_STATE_TRANSFORM, Transform2D())
		
		
	elif index > 0 or !members[index]:
		members[index] = member


func set_leader(member: SquadMember) -> void:
	leader = member


func sort() -> void:
	members.sort_custom(func(a: SquadMember, b: SquadMember) -> bool: return a.z < b.z)
	
	for i: int in members.size():
		RenderingServer.canvas_item_set_draw_index(members[i].cid, i)


# OVERRIDE
func _process(delta: float) -> void:
	pass


# OVERRIDE
func _physics_process(delta: float) -> void:
	pass


func create_path() -> void:
	path = Curve2D.new()
	
	if path_scope.path_type == PathScope.PATH_TYPE_LINE:
		path.point_count = 2
		path.set_point_position(0, path_scope.from)
		path.set_point_position(1, path_scope.to)
