extends CanvasLayer
class_name Channel


var _bgm: BGMPlayer


func get_camera() -> Camera3D:
	return get_node(^"Camera3D") as Camera3D


func get_listener() -> ChannelListener:
	return get_camera().get_node(^"ChannelListener") as ChannelListener


func _init() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE


func play_sfx(_stream: AudioStream, position: Vector2) -> void:
	var sfx := SFXPlayer.new(_stream)
	pos_to_vec3(position)
	add_child(sfx)


func play_bgm(_stream: AudioStream, position: float = 0.) -> void:
	if is_bgm_playing():
		_bgm.fade_out()
	
	_bgm = BGMPlayer.new(_stream)
	_bgm.fade_in(position)


func is_bgm_playing() -> bool:
	if _bgm != null:
		if _bgm.is_playing():
			return true
	
	printerr("Channel >> 현재 BGM이 재생중입니다.")
	return false


static func pos_to_vec3(pos: Vector2, z_value: float = 0.) -> Vector3:
	return Vector3(pos.x, - pos.y, z_value) / 50.



class SFXPlayer extends AudioStreamPlayer3D:
	func _init(_stream: AudioStream) -> void:
		stream = _stream
		bus = &"SFX"
		finished.connect(
			func() -> void:
				queue_free.call_deferred()
		)
		play()


class BGMPlayer extends AudioStreamPlayer:
	var repeat: bool = false
	
	var _tween: Tween
	
	func _init(_stream: AudioStream, _repeat: bool = false) -> void:
		stream = _stream
		bus = &"BGM"
		repeat = _repeat
	
	
	func is_fading() -> bool:
		return _tween != null and _tween.is_running()
	

	func fade_in(position: float) -> void:
		play(position)
		_tween = create_tween()
		_tween.tween_property(
			self, "volume_db", 0., 1.
		)


	func fade_out() -> void:
		_tween = create_tween()
		_tween.finished.connect(
			func() -> void:
				queue_free.call_deferred()
		)
		
		_tween.tween_property(self, "volume_db", -72., 1.)


	
