@tool
extends Node


const BGM: AudioStream = preload("uid://bxsd4pdohjlx4")


@export_tool_button("Play", "AudioStream") var _play: Callable = play
@export_tool_button("Stop", "Error") var _stop: Callable = stop


var _current: AudioStreamPlaybackPolyphonic

func play() -> void:
	var playback: AudioStreamPlaybackPolyphonic = BGM.instantiate_playback() as AudioStreamPlaybackPolyphonic
	playback.play_stream(
		BGM, 0., -5., 1., AudioServer.PLAYBACK_TYPE_STREAM, &"bgm"
	)
	_current = playback
	print("Play")


func stop() -> void:
	_current.stop()


func _enter_tree() -> void:
	pass


class SpecimenAnim extends RefCounted:
	pass
