@tool
extends Node


const NOTIFICATION_PLAY: int = 48000
const NOTIFICATION_STOP: int = 48001
const NOTIFICATION_PLAYED: int = 48002
const NOTIFICATION_STOPPED: int = 48003


@export var audio_stream: AudioStream
var _current: AudioStreamPlayback = null


@export_custom(PROPERTY_HINT_NONE, "", PROPERTY_USAGE_READ_ONLY | PROPERTY_USAGE_DEFAULT) var is_playing: bool:
	set(playing):
		if is_playing == playing: return
		
		is_playing = playing
		if !playing:
			pass


@export_tool_button("Play", "AudioListener2D") var _play: Callable = play
@export_tool_button("Stop", "AudioListener2D") var _stop: Callable = stop


func _process(_delta: float) -> void:
	if _current:
		is_playing = _current.is_playing()


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_STOP:
			print("music stopped")

		NOTIFICATION_PLAY:
			print("music played")


func play() -> void:
	if audio_stream:
		var playback: AudioStreamPlayback = audio_stream.instantiate_playback()
		
		_current = playback
		
		AudioServer.start_playback_stream(
			playback, &"BackgroundMusic", 0., AudioServer.MIX_TARGET_STEREO, 0., 1.
		)


func stop() -> void:
	if !_current: return
	
	AudioServer.stop_playback_stream( _current )
