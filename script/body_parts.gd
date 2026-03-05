extends MultiMeshInstance2D
class_name BodyPart2D


@export_flags(
	"head",
	"right_arm", "right_hand",
	"left_arm", "left_hand",
	"right_leg", "right_thigh",
	"left_leg", "left_thigh",
	"center_body",
	"left_body", "right_body"
) var emit_parts: int = 0
