extends Resource
class_name UnitMotionInformation


enum Type { # 커맨드 버스 타입
	IDLE, # 통상, 이동
	JUMP, # 공중에서의 통상 모션
	HURT, # 피격 모션 중 회피기동할 때 사용
}


# const (Type)
const IDLE := Type.IDLE
const JUMP := Type.JUMP
const HURT := Type.HURT


@export var name: StringName
@export var type: Type = IDLE
@export var block_cancel: bool = false
@export var dodge_cancel: bool = false


@export_group("Animation")
@export var anim_library: AnimationLibrary
@export var library_name: StringName


@export_group("Player")
@export var action_input: PackedStringArray
@export var ev_name: StringName
