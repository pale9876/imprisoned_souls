@tool
extends MultiMeshInstance2D
class_name AlignedMultiMeshInstance2D
# 패스를 따라 여러개의 스프라이트를 나란히 놓고 싶을 때에 사용함. Path2D를 자식으로 필요함.


@export var instance_texture: Texture2D:
	set(t):
		instance_texture = t
		texture = instance_texture
		if multimesh != null:
			if multimesh.mesh != null:
				var mesh: Mesh = multimesh.get_mesh()
				if mesh is QuadMesh:
					mesh.size = instance_texture.get_size() * Vector2(1., -1.)
		_update()


@export var instance_scale: Vector2 = Vector2.ONE:
	set(value):
		instance_scale = value
		_update()

@export var count: int = 20:
	set = set_count


var _id: int = -1


func _init() -> void:
	_id = -1
	multimesh = MultiMesh.new()
	multimesh.mesh = QuadMesh.new()


func set_count(value: int) -> void:
	count = value
	_update()


func _update() -> void:
	_id = -1
	
	var parent: Node = get_parent()
	
	if parent == null: return
	
	if parent is MeshInstancePath2D:
		var progress_length: float = parent.curve.get_baked_length()
		var step: float = progress_length / float(count - 1)
		
		multimesh.instance_count = count
		multimesh.visible_instance_count = count
		
		for current_progress: float in range(0., progress_length, step):
			_id += 1
			multimesh.set_instance_transform_2d(
				_id,
				Transform2D(
					0.,
					instance_scale,
					0.,
					parent.curve.sample_baked(current_progress)
				)
			)
