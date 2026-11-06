extends CanvasLayer

signal match_ended(winner: String)

@onready var p1_health_bar: ProgressBar = $MarginContainer/HBoxContainer/P1_Container/P1_HealthBar
@onready var p1_damage_bar: ProgressBar = $MarginContainer/HBoxContainer/P1_Container/P1_DamageBar

@onready var p2_health_bar: ProgressBar = $MarginContainer/HBoxContainer/P2_Container/P2_HealthBar
@onready var p2_damage_bar: ProgressBar = $MarginContainer/HBoxContainer/P2_Container/P2_DamageBar

@onready var timer_label: Label = $MarginContainer/HBoxContainer/TimerLabel
@onready var announcement_label: Label = $AnnouncementLabel

var p1_tween: Tween
var p2_tween: Tween

var round_time: float = 99.0
var is_match_active: bool = true
var p1_ref: Player
var p2_ref: Player

func setup_hud(player1: Player, player2: Player) -> void:
	p1_ref = player1
	p2_ref = player2
	
	if player1:
		p1_health_bar.max_value = player1.max_health
		p1_health_bar.value = player1.current_health
		p1_damage_bar.max_value = player1.max_health
		p1_damage_bar.value = player1.current_health
		player1.health_changed.connect(_on_p1_health_changed)
		player1.died.connect(_on_player_died)
		
	if player2:
		p2_health_bar.max_value = player2.max_health
		p2_health_bar.value = player2.current_health
		p2_damage_bar.max_value = player2.max_health
		p2_damage_bar.value = player2.current_health
		player2.health_changed.connect(_on_p2_health_changed)
		player2.died.connect(_on_player_died)
		
	round_time = 99.0
	is_match_active = true
	announcement_label.visible = false

func _process(delta: float) -> void:
	if not is_match_active:
		return
		
	round_time = max(0.0, round_time - delta)
	timer_label.text = str(int(ceil(round_time)))
	
	if round_time <= 0.0:
		handle_time_over()

func _on_p1_health_changed(new_health: int, _max_health: int) -> void:
	p1_health_bar.value = new_health
	
	if p1_tween and p1_tween.is_valid():
		p1_tween.kill()
		
	p1_tween = create_tween()
	p1_tween.tween_interval(0.3)
	p1_tween.tween_property(p1_damage_bar, "value", float(new_health), 0.4).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func _on_p2_health_changed(new_health: int, _max_health: int) -> void:
	p2_health_bar.value = new_health
	
	if p2_tween and p2_tween.is_valid():
		p2_tween.kill()
		
	p2_tween = create_tween()
	p2_tween.tween_interval(0.3)
	p2_tween.tween_property(p2_damage_bar, "value", float(new_health), 0.4).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func _on_player_died() -> void:
	if not is_match_active:
		return
	is_match_active = false
	
	var winner_text = ""
	if p1_ref.current_health <= 0 and p2_ref.current_health <= 0:
		winner_text = "DOUBLE K.O."
	elif p1_ref.current_health <= 0:
		winner_text = "PLAYER 2 WINS"
	else:
		winner_text = "PLAYER 1 WINS"
		
	show_announcement("K.O.!\n" + winner_text)
	match_ended.emit(winner_text)

func handle_time_over() -> void:
	is_match_active = false
	
	var result_text = ""
	if p1_ref.current_health > p2_ref.current_health:
		result_text = "TIME OVER\nPLAYER 1 WINS"
	elif p2_ref.current_health > p1_ref.current_health:
		result_text = "TIME OVER\nPLAYER 2 WINS"
	else:
		result_text = "TIME OVER\nDRAW GAME"
		
	show_announcement(result_text)
	match_ended.emit(result_text)

func show_announcement(text_to_show: String) -> void:
	announcement_label.text = text_to_show
	announcement_label.visible = true
