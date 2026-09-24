# confession_debuff.gd
extends AEIndex


const Confession: Script = preload("uid://ct5rqf0ti5jej")


@export var decrease_def_ratio: float = -.3


var link: Confession
var active: bool = false


func activate() -> void:
	stat.def_ratio = decrease_def_ratio



	
