extends Control
class_name SplashTitle


const DEFAULT_SAVE_PATH: String = "res://splash_img.png"


signal load_finished()


@export_file_path("*.tscn") var main_scene: String


@onready var load_progress: ProgressBar = $LoadProgress
@onready var fade_in_out: ColorRect = $FadeInOut
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var _loading: bool = false
var progress: Array
var status: ResourceLoader.ThreadLoadStatus


func _ready() -> void:
	animation_player.animation_finished.connect(
		func(anim_name: StringName) -> void:
			if anim_name == &"fade_out":
				var scene := ResourceLoader.load_threaded_get(main_scene) as PackedScene
				get_tree().change_scene_to_packed(scene)
	)
	
	var img := await get_splash_img()
	
	img.save_png(DEFAULT_SAVE_PATH)
	load_main_scene()
	
	load_progress.show()


func _process(_delta: float) -> void:
	status = ResourceLoader.load_threaded_get_status(main_scene, progress)
	var _progress := progress[0] as float
	load_progress.value = _progress
	if status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
		_on_loaded()



func _on_loaded() -> void:
	load_finished.emit()
	animation_player.play("fade_out")
	load_progress.hide()
	_loading = false


func get_splash_img() -> Image:
	await RenderingServer.frame_post_draw

	var img := get_viewport().get_texture().get_image()
	return img


func load_main_scene() -> void:
	var err: Error = ResourceLoader.load_threaded_request(main_scene)
	
	if err != OK:
		printerr("메인 씬을 불러오는데 실패함. ERR => ", err)
		return

	_loading = true
