extends Camera2D
class_name FightCamera

@export var player1: Player
@export var player2: Player

@export var min_zoom: float = 1.8
@export var max_zoom: float = 2.5
@export var zoom_margin: float = 120.0
@export var smooth_speed: float = 10.0

@export var base_y_position: float = 0.0

func _physics_process(delta: float) -> void:
	if not player1 or not player2:
		return
		
	update_camera_position(delta)
	update_camera_zoom(delta)

func update_camera_position(delta: float) -> void:
	var target_x = (player1.global_position.x + player2.global_position.x) * 0.5
	
	var min_player_y = min(player1.global_position.y, player2.global_position.y)
	var target_y = base_y_position + min(0.0, (min_player_y - base_y_position) * 0.3)
	
	global_position.x = lerp(global_position.x, target_x, smooth_speed * delta)
	global_position.y = lerp(global_position.y, target_y, smooth_speed * delta)

func update_camera_zoom(delta: float) -> void:
	var dist = abs(player1.global_position.x - player2.global_position.x) + zoom_margin
	var viewport_width = get_viewport_rect().size.x
	
	var target_zoom_val = viewport_width / dist
	target_zoom_val = clamp(target_zoom_val, min_zoom, max_zoom)
	
	var current_target_zoom = Vector2(target_zoom_val, target_zoom_val)
	zoom = zoom.lerp(current_target_zoom, smooth_speed * delta)
