extends CharacterBody2D
class_name Player

signal take_damage(event: String)

var received_hitstun: int = 0
var received_damage: int = 0
var received_blockstun: int = 0
var is_crouching: bool = false
var is_facing_right: bool = true

@export var input_prefix: String = "p1_"
@export var speed: float = 200.0
@export var jump_force: float = -600.0
@export var gravity: float = 1400.0

@export var light_punch_atk: AttackData
@export var medium_punch_atk: AttackData
@export var light_kick_atk: AttackData
@export var heavy_punch_atk: AttackData

@export var medium_kick_atk: AttackData
@export var heavy_kick_atk: AttackData

@export var enemy: Player

@onready var anim = $AnimatedSprite2D
@onready var state_machine = $StateMachine
@onready var cur_atk: AttackData
@onready var hitbox_col = $Hitbox/CollisionShape2D
@onready var body_col = $CollisionShape2D
@onready var hurtbox_col = $Hurtbox/CollisionShape2D

func _ready() -> void:
	$Hitbox.area_entered.connect(_on_hitbox_area_entered)
	floor_max_angle = 0.0
	floor_snap_length = 0.0

func set_hitbox_active(is_active: bool) -> void:
	hitbox_col.set_deferred("disabled", not is_active)

func setup_hitbox() -> void:
	if cur_atk and hitbox_col.shape is RectangleShape2D:
		var pos_x = cur_atk.hitbox_position.x if is_facing_right else -cur_atk.hitbox_position.x
		hitbox_col.position = Vector2(pos_x, cur_atk.hitbox_position.y)
		hitbox_col.shape.size = cur_atk.hitbox_size

func check_auto_turn() -> void:
	if not enemy:
		return
	
	if enemy.global_position.x < global_position.x and is_facing_right:
		is_facing_right = false
		anim.flip_h = true
	elif enemy.global_position.x > global_position.x and not is_facing_right:
		is_facing_right = true
		anim.flip_h = false

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.owner != self and area.owner is Player and cur_atk:
		var target = area.owner as Player
		target.receive_hit(cur_atk, global_position.x)

func is_holding_back() -> bool:
	var prefix = input_prefix
	var dir = Input.get_axis(prefix + "left", prefix + "right")
	
	if is_facing_right and dir < 0:
		return true
	elif not is_facing_right and dir > 0:
		return true
	
	return false

func can_block_attack(atk: AttackData) -> bool:
	if not is_holding_back():
		return false
	
	if atk.attack_height == "LOW" and not is_crouching:
		return false
	
	if atk.attack_height == "HIGH" and is_crouching:
		return false
	
	return true

func receive_hit(atk: AttackData, attacker_pos_x: float) -> void:
	var push_dir = 1.0 if attacker_pos_x < global_position.x else -1.0
	
	if can_block_attack(atk):
		received_damage = 0
		received_blockstun = atk.blockstun_frames
		velocity.x = push_dir * (atk.knockback.x * 0.6)
		state_machine.send_event("BLOCK")
		return
	
	received_damage = atk.damage
	received_hitstun = atk.hitstun_frames
	velocity.x = push_dir * atk.knockback.x
	velocity.y = atk.knockback.y
	state_machine.send_event("HURT")
	take_damage.emit("HURT")

func set_crouch_boxes(crouching: bool) -> void:
	is_crouching = crouching
	
	if not body_col or not hurtbox_col:
		return
		
	if crouching:
		hurtbox_col.position = Vector2(-1.75, 20.0)
		hurtbox_col.shape.size = Vector2(34.5, 58.0)
		
		body_col.position = Vector2(-2.0, 20.0)
		if body_col.shape is CapsuleShape2D:
			body_col.shape.height = 60.0
		elif body_col.shape is RectangleShape2D:
			body_col.shape.size = Vector2(28.0, 60.0)
	else:
		hurtbox_col.position = Vector2(-1.75, 0.25)
		hurtbox_col.shape.size = Vector2(34.5, 97.5)
		
		body_col.position = Vector2(-2.0, 0.5)
		if body_col.shape is CapsuleShape2D:
			body_col.shape.height = 95.0
		elif body_col.shape is RectangleShape2D:
			body_col.shape.size = Vector2(28.0, 99.0)
			
func check_attack_inputs() -> bool:
	var prefix = input_prefix
	
	if Input.is_action_just_pressed(prefix + "lp") and light_punch_atk:
		cur_atk = light_punch_atk
	elif Input.is_action_just_pressed(prefix + "mp") and medium_punch_atk:
		cur_atk = medium_punch_atk
	elif Input.is_action_just_pressed(prefix + "hp") and heavy_punch_atk:
		cur_atk = heavy_punch_atk
	elif Input.is_action_just_pressed(prefix + "lk") and light_kick_atk:
		cur_atk = light_kick_atk
	elif Input.is_action_just_pressed(prefix + "mk") and medium_kick_atk:
		cur_atk = medium_kick_atk
	elif Input.is_action_just_pressed(prefix + "hk") and heavy_kick_atk:
		cur_atk = heavy_kick_atk
	else:
		return false
		
	state_machine.send_event("ATTACK")
	return true
