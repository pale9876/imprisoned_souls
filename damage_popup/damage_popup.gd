extends RefCounted
class_name DamagePopup


var cid: RID
var text_shape: RID
var value: int
var duration: float = .3
var curve: Curve


func popup() -> void:
	pass


func kill() -> void:
	RenderingServer.free_rid(cid)
	var text_server: TextServer = TextServerManager.get_primary_interface()
	text_server.free_rid(text_shape)
