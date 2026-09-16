extends AudioStreamPlayer


func _init() -> void:
	bus = &"UI"
	
	finished.connect(
		func () -> void:
			pass
	)


func sound_play(_stream: AudioStream, is_echo: bool = false) -> void:
	if is_echo:
		var player: AudioStreamPlayer = AudioStreamPlayer.new()
		player.bus = self.bus
		player.stream = _stream
		player.finished.connect(
			func() -> void:
				player.queue_free.call_deferred()
		)
		add_child(player)
		player.play()
	else:
		stream = _stream
		play()
