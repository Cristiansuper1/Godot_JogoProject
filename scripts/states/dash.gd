extends State

var current_frame: int = 0
@export var dash_frames: int = 14
@export var dash_speed: float = 300.0

func enter():
	current_frame = 0
	player.set_hitbox_active(false)
	player.set_crouch_boxes(false)
	
	if player.is_forward_dash:
		anim.play("move-front")
	else:
		anim.play("move-back")

func exit():
	current_frame = 0

func update(delta: float):
	current_frame += 1
	
	player.velocity.x = player.dash_direction * dash_speed
	
	if not player.is_on_floor():
		player.velocity.y += player.gravity * delta
		
	player.move_and_slide()
	
	if current_frame >= dash_frames:
		get_parent().send_event("DASH_END")
