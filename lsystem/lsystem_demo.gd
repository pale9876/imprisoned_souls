@tool
extends Endeka
class_name LPlanet


@export var fract_information: FractInformation = FractInformation.new()


var plant: Array[LSystem] = []


func create() -> void:
	if init:
		kill()
	
	var lsystem: LSystem = LSystem.new()
	
	lsystem.cid = RenderingServer.canvas_item_create()
	RenderingServer.canvas_item_set_parent(lsystem.cid, get_canvas())
	RenderingServer.canvas_item_set_transform(lsystem.cid, Transform2D(0., fract_information.init_pos))
	
	lsystem.position = Vector2()
	lsystem.direction = fract_information.direction
	lsystem.length = fract_information.length
	
	# Parse
	var result: PackedInt32Array = PackedInt32Array()
	var parsed_axion: PackedInt32Array = LSystem.parse(fract_information.axiom)
	result = parsed_axion
	
	var parsed_rule: Dictionary[LSystem.Constants, PackedInt32Array] = {}
	for chr: String in fract_information.rules:
		var parsed_chr: LSystem.Constants = LSystem.parse_char(chr)
		var parsed_pattern: PackedInt32Array = LSystem.parse(fract_information.rules[chr])
		parsed_rule[parsed_chr] = parsed_pattern
	
	for i: int in fract_information.step:
		var temp: PackedInt32Array = PackedInt32Array()
		for chr: int in result:
			if chr in parsed_rule:
				temp += parsed_rule[chr]
			else:
				temp += PackedInt32Array([chr])
		result = temp
	
	lsystem.state = result
	
	var parsed_colors: Dictionary[LSystem.Constants, Color] = {}
	for chr: String in fract_information.colors:
		parsed_colors[LSystem.parse_char(chr)] = fract_information.colors[chr]
	lsystem.colors = parsed_colors
	
	# Draw Fractal
	for chr: int in lsystem.state:
		if chr in LSystem.VARIABLES:
			var _position: Vector2 = lsystem.position + (lsystem.direction * lsystem.length)
			lsystem.lines += PackedVector2Array([lsystem.position, _position])
			lsystem.position = _position
		elif chr in LSystem.OPERATOR:
			match chr:
				LSystem.Constants.PLUS:
					lsystem.direction = lsystem.direction.rotated(deg_to_rad(fract_information.turn_angle))
				LSystem.Constants.MINUS:
					lsystem.direction = lsystem.direction.rotated(deg_to_rad(- fract_information.turn_angle))
				LSystem.Constants.PUSH_STACK:
					var _stack: Dictionary = {}
					_stack["position"] = lsystem.position
					_stack["direction"] = lsystem.direction
					lsystem.stack.push_back(_stack)
				LSystem.Constants.POP_STACK:
					var _stack: Dictionary = lsystem.stack.back()
					lsystem.position = _stack["position"]
					lsystem.direction = _stack["direction"]
					lsystem.stack.pop_back()
	
	RenderingServer.canvas_item_add_multiline(
		lsystem.cid, lsystem.lines, [fract_information.line_color]
	)
	
	plant.push_back(lsystem)
	
	init = true


#func clone_plant(lsys: LSystem, to: Vector2) -> void:
	#pass


func kill() -> void:
	if !plant.is_empty():
		for lsys: LSystem in plant:
			RenderingServer.free_rid(lsys.cid)
	plant = []
