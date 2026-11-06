extends Node2D

@onready var player1: Player = $Players/Player
@onready var player2: Player = $Players/Player2
@onready var hud: CanvasLayer = $HUD

func _ready() -> void:
	if hud and player1 and player2:
		hud.setup_hud(player1, player2)
		hud.match_ended.connect(_on_match_ended)

func _on_match_ended(_winner: String) -> void:
	if player1:
		player1.freeze_player()
	if player2:
		player2.freeze_player()
