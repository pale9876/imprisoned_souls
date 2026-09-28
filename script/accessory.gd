extends Node
class_name Accessory


@export var info: AccessoryInformation


func init_info(_info: AccessoryInformation) -> void:
	info = _info


# Override
func format_description(dict: Dictionary) -> String:
	return info.stat_description.format(dict)


#func format_description() -> String:
	#if additional_stat == null: return ""
	#
	#var properties := additional_stat.get_property_list()
	#var cache: Dictionary[String, Variant] = {}
	#for prop: Dictionary in properties:
		#var prop_name := prop["name"] as String
		#var value = additional_stat.get(prop_name)
		#if typeof(value) == TYPE_INT:
			#if value > 0:
				#value = "+" + str(value) + " 증가"
			#elif value < 0:
				#value = "-" + str(abs(value)) + " 감소"
		#elif typeof(value) == TYPE_FLOAT:
			#if value > 0.:
				#value = "+" + str(value * 100) + "% 증가"
			#elif value < 0:
				#value = "-" + str(abs(value * 100)) + "% 감소"
		#
		#
		#cache[prop_name] = value
	#
	#return stat_description.format(cache)
