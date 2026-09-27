@tool
extends Resource
class_name AccessoryInformation


@export_group("Meta")
@export var name: StringName
@export_multiline() var description: String
@export_multiline() var stat_description: String

@export_group("Resource")
@export var icon: Texture2D
@export var texture: Texture2D
@export var scene: PackedScene
@export var additional_stat: AEIndexStatInformation


@export_tool_button("Print Format", "Font")
var print_format: Callable = func() -> void:
	var format: String = format_description()
	print(format)


func format_description() -> String:
	if additional_stat == null: return ""
	
	var properties := additional_stat.get_property_list()
	var cache: Dictionary[String, Variant] = {}
	for prop: Dictionary in properties:
		var prop_name := prop["name"] as String
		var value = additional_stat.get(prop_name)
		if typeof(value) == TYPE_INT:
			if value > 0:
				value = "+" + str(value) + " 증가"
			elif value < 0:
				value = "-" + str(abs(value)) + " 감소"
		elif typeof(value) == TYPE_FLOAT:
			if value > 0.:
				value = "+" + str(value * 100) + "% 증가"
			elif value < 0:
				value = "-" + str(abs(value * 100)) + "% 감소"
		
		
		cache[prop_name] = value
	
	return stat_description.format(cache)
