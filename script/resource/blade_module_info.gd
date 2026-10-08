# blade_module_info.gd
extends Resource
class_name BladeModuleInfo


enum RangeType {
	CLOSE, # 근거리
	LONG, # 원거리
	REGION, #광역
}

enum WeaponType
{
	NONE,
	KATANA,
	AXE,
	PISTOL,
	CANNON,
}

# Const
#const TICK := BladeMotionFrame.TICK


@export var name: StringName = ""
@export var attack_range: RangeType = RangeType.CLOSE
@export_flags(
	"PREDATOR",
	"EXECUTIONER",
	'CHIMERA',
	'TRICKSTER',
	"PUPPETEER",
	"EXORCIST",
	"TWINS",
) var band: int = 0 # 0 == ANY, 모션 호환 가능한 클래스

@export_group("무기 호환")
@export var activate_by_usable_weapons_only: bool = false
@export var weapon_compatibility: WeaponType = WeaponType.NONE
@export var enter_command: Array[String] # 진입 커맨드

@export_group("씬")
@export var sprite_motion: PackedScene
@export var hitbox: PackedScene
@export var target_state: PackedScene
@export var substate: Array[PackedScene]

#@export var library_name: StringName
#@export var motion_info: Array[BladeMotionFrame] = []


#static func parse_frame(motion: BladeMotionFrame) -> Animation:
	#var anim: Animation = Animation.new()
	#anim.length = motion.frame_length * TICK
	#
	#for trigger: BladeMotionTrigger in motion.trigger:
		#var _track: int = plant_trigger(anim, trigger)
	#
	#return anim
#
#
#static func plant_trigger(anim: Animation, trigger: BladeMotionTrigger) -> int:
	#var _track: int = anim.add_track(Animation.TYPE_METHOD)
	#anim.track_set_path(_track, trigger.target_path)
	#anim.value_track_set_update_mode(_track, Animation.UPDATE_DISCRETE)
	#anim.track_insert_key(_track, TICK * trigger.frame, trigger.get_dict())
	#
	#return _track


#func init_module(unit: Unit) -> void:
	##var motion_lib: MotionLibrary = unit.get_anim()
	#var hsm: StateMachine = unit.get_state_machine()
	#var hitbox_component: HitboxComponent = unit.get_hitbox_component()
	#
	## Init State / SubStates
	#var state := target_state.instantiate() as DefaultUnitFormState
	#if !hsm.has_state(String(state.name)):
		#hsm.add_child(state)
	#
	#for _scene: PackedScene in substate:
		#var _substate := _scene.instantiate() as LimboSubState
		#if !state.has_substate(_substate.name):
			#state.add_child(_substate)
	#
	#hitbox_component.add_hitbox(hitbox.instantiate() as Hitbox)
	
	
	# Init Motion
	#var anim_lib: AnimationLibrary = AnimationLibrary.new()
	
	#for motion: BladeMotionFrame in motion_info:
		#var anim: Animation = parse_frame(motion)
		#anim_lib.add_animation(motion.name, anim)
	
	#motion_lib.add_animation_library(library_name, anim_lib)
