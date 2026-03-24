extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -350.0

@onready var anim = $AnimatedSprite2D

enum State {IDLE, ATTACK, CROUCH, JUMP, MOVE, HITSTUN, PARRY, BLOCK}

var cur_state = State.IDLE

var on_floor = false

var on_ceiling = false

var atk_active = false

@export var health = 200


@export var light_punch: AttackData
@export var medium_punch: AttackData
@export var fierce_kick: AttackData

var parry_window_timer = 0
var PARRY_WINDOW = 0.16

var current_attack = 0
var hit_stun_timer = 0

@export var player = "p1"
@export var oponente: CharacterBody2D

var dir = 0
var want_jump = false
var want_crouch = false
var want_parry = false

var want_attack = false
var want_lp = false
var want_mp = false
var want_hk = false
var got_hurt = false
var want_block = false

var HITSTUN_TIME = 0.0
var hitstun_timer = 0

var atk_start_frame = -999

var atk_frame = 0

func _ready() -> void:
	print("Get ready to strike\nNow!")
	enter_state(State.IDLE)
	if player == "p2":
		scale.x = -1

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	read_intent()
	
	match cur_state:
		State.IDLE:
			update_grounded(delta, false)
		State.MOVE:
			update_grounded(delta, true)
		State.CROUCH:
			update_crouch(delta)
		State.JUMP:
			#update_jump(delta)
			pass
		State.PARRY:
			enter_state(State.MOVE)
			#update_parry(delta)
			pass
		State.ATTACK:
			update_attack(delta)
		State.HITSTUN:
			update_hitstun(delta)
		State.BLOCK:
			update_block(delta)
			
	move_and_slide()
	
	print(player + " Heath: ", health)
	
	if is_on_floor() and cur_state == State.JUMP:
		enter_state(State.IDLE)
	
func _on_timer_timeout() -> void:
	cur_state = State.IDLE

func _get_player():
	return player

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.owner != self:
		print(player + " recebeu ataque")
		receive_attack(area.owner)

func receive_attack(attacker):
	var distance = global_position.distance_to(oponente.global_position)
	if attacker.atk_active and distance < 50:
		if want_block:
			Engine.time_scale = 0.2
			print("Ataque bloqueado")
			enter_state(State.BLOCK)
			velocity.x = attacker.current_attack.knockback_strenght / 2
			velocity.x = lerp(velocity.x, 0.0, 0.2)
		else:
			print(player + " Diz: Gah!")
			enter_state(State.HITSTUN)
			got_hurt = true
			var dir_away = sign(self.global_position.x - attacker.global_position.x)
			velocity.x = dir_away * attacker.current_attack.knockback_strenght
			print("velocidade: ", velocity.x)
			velocity.x = lerp(velocity.x, 0.0, 0.2)
			self.HITSTUN_TIME = attacker.current_attack.hit_stun
			Engine.time_scale /= attacker.current_attack.damage
			health -= attacker.current_attack.damage
			

func read_intent():
	dir = Input.get_axis(player + "_left", player + "_right")
	want_jump = Input.is_action_pressed(player + "_up")
	want_crouch = Input.is_action_pressed(player + "_down")
	want_block = Input.is_action_pressed(player + "_left")
	
	want_lp = Input.is_action_just_pressed(player + "_lp")
	want_mp = Input.is_action_just_pressed(player + "_mp")
	want_hk = Input.is_action_just_pressed(player + "_hk")
	
func update_grounded(_delta: float, is_moving: bool):
	if want_jump:
		enter_state(State.JUMP)
		velocity.y = JUMP_VELOCITY
		return
	
	if want_crouch:
		enter_state(State.CROUCH)
		return

	if want_parry:
		enter_state(State.PARRY)
		return

	if want_lp:
		anim.play("lp")
		current_attack = light_punch
		enter_state(State.ATTACK)
		return
	
	if want_mp:
		anim.play("mp")
		current_attack = medium_punch
		enter_state(State.ATTACK)
		return
	
	if want_hk:
		anim.play("hk")
		current_attack = fierce_kick
		enter_state(State.ATTACK)
		return
		
	if want_parry:
		enter_state(State.PARRY)
		return
	
	"""var distance = global_position.distance_to(oponente.global_position)
	print("Read Intent is attack active: ", atk_active)
	if want_block and distance < 70:
		enter_state(State.BLOCK)
		return"""
	
	if got_hurt:
		enter_state(State.HITSTUN)
		return
	
	if dir == 0:
		velocity.x = 0
		if is_moving:
			enter_state(State.IDLE)
	else:
		velocity.x = SPEED * dir
		
		if not is_moving:
			enter_state(State.MOVE)
		
		if dir > 0:
			anim.play("move-front")
		else:
			anim.play("move-back")

func enter_state(s: State):
	if cur_state == s:
		return
	
	cur_state = s
	
	match cur_state:
		State.IDLE:
			anim.play("idle")
		State.CROUCH:
			anim.play("crouch")
			velocity.x = 0
		State.JUMP:
			anim.play("jump")
		State.ATTACK:
			atk_start_frame = Engine.get_physics_frames()
			atk_frame = 0
			velocity.x = 0
		State.PARRY:
			anim.play("parry")
			velocity.x = 0
			parry_window_timer = 0
		State.HITSTUN:
			anim.play("hurt")
			velocity.x = 0
		State.BLOCK:
			anim.play("parry-crouch")
			velocity.x = 0

func update_crouch(_delta: float):
	velocity.x = 0
	
	if Input.is_action_just_released(player + "_down"):
		enter_state(State.IDLE)

func update_attack(_delta: float):
	var startup_end = current_attack.startup_frames
	var active_end = current_attack.startup_frames + current_attack.active_frames
	var total = current_attack.startup_frames + current_attack.active_frames + current_attack.recovery_frames
	atk_frame = Engine.get_physics_frames() - atk_start_frame
	
	if atk_frame < startup_end:
		$LightPunch/CollisionShape2D.disabled = true
		atk_active = false
	elif atk_frame < active_end:
		$LightPunch/CollisionShape2D.disabled = false
		atk_active = true
	elif atk_frame < total:
		$LightPunch/CollisionShape2D.disabled = true
		atk_active = false
	else:
		enter_state(State.IDLE)
		atk_start_frame = -999
		
		Engine.time_scale = 1

func update_hitstun(delta: float):
	if hitstun_timer > HITSTUN_TIME:
		enter_state(State.IDLE)
		got_hurt = false
		hitstun_timer = 0
	
	hitstun_timer+= delta

func update_block(_delta: float):
	if Input.is_action_just_released(player + "_left"):
		enter_state(State.IDLE)
