extends CharacterBody2D
class_name Player

signal take_damage(event: String)

@export var input_prefix: String = "p1_"
@export var speed: float = 200.0
@export var jump_force: float = -600.0
@export var gravity: float = 1400.0

@export var light_punch_atk: AttackData
@export var medium_punch_atk: AttackData
@export var light_kick_atk: AttackData

@onready var anim = $AnimatedSprite2D
@onready var state_machine = $StateMachine
@onready var cur_atk: AttackData
@onready var hitbox_col = $Hitbox/CollisionShape2D

@onready var char_name = "ryu"

var is_facing_right: bool = true

@export var enemy : Player

@onready var char_move_list = {}

func set_hitbox_active(is_active: bool) -> void:
	hitbox_col.disabled = not is_active

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

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.owner != self:
		print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAI!")
		take_damage.emit("HURT")
