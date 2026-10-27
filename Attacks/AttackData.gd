extends Resource
class_name AttackData

@export var anim_name: String
@export var damage: int
@export var startup_frames: int
@export var active_frames: int
@export var recovery_frames: int
@export var hitstun_frames: int
@export var blockstun_frames: int
@export var knockback: Vector2
@export var hitbox_position: Vector2
@export var hitbox_size: Vector2
@export_enum("HIGH", "LOW", "MID") var attack_height: String = "HIGH"
