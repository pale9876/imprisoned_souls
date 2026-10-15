# spawning_pool.gd
extends Node


enum Result {
	OK = 0,
	ERR = 1
}


signal done()


var count: int = -1
var pool: Array[Worker] = []


func request_load(arr: Array[String]) -> Result:
	for path in arr:
		var err := ResourceLoader.load_threaded_request(path, "PackedScene")
		count += 1
		
		var _worker := Worker.new(count, path)
		pool.push_back(_worker)
		
		if err != OK:
			return Result.ERR
	
	return Result.OK


class Worker:
	var _idx: int = -1
	var _path: String
	
	func _init(idx: int, path: String) -> void:
		_idx = idx
		_path = path
		


	
