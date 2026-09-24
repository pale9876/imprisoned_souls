# confession_debuff.gd
extends AEIndex


const Confession: Script = preload("uid://ct5rqf0ti5jej")


@export var decrease_def_ratio: float = -.3


var link: Confession


func activate() -> void:
	stat.def_ratio = decrease_def_ratio


func deactivate() -> void:
	clear()


	
