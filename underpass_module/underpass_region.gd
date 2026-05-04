extends RefCounted
class_name Region


var cid: RID
var type: RoomInformation.Orientation
var pos: Vector2
var size: Vector2
var body: RID
var segments: Array[RID]
var door: Array[RID]
var texture: Texture2D
var rect: Rect2
var closed: bool = false
var disabled: bool = false
var rid: RID
var link: RID

func kill() -> void:
	RenderingServer.free_rid(cid)
	PhysicsServer2D.free_rid(body)
	
	for s: RID in segments:
		PhysicsServer2D.free_rid(s)
