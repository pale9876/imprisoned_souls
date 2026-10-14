extends Node
class_name Gear


enum Type {
	NONE = 0,
	HEAD,
	BODY,
	LEG,
	BELT,
	PANTS,
}


@export var type: Type = Type.NONE
@export var additional_stat: AEIndexStatInformation = AEIndexStatInformation.new()


	
