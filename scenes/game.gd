extends Node2D

@onready var game_over_screen: CanvasLayer = $GameOverScreen
@onready var victory_screen: CanvasLayer = $VictoryScreen

func _ready() -> void:
	get_tree().paused = false
	GameManager.start_game()
	GameManager.game_ended.connect(on_game_end)
	GameManager.victory.connect(on_victory)

func _on_restart_button_pressed() -> void:
	for node in get_tree().get_nodes_in_group("enemies"):
		node.queue_free()

	get_tree().paused = false
	game_over_screen.visible = false
	get_tree().reload_current_scene()

func on_game_end() -> void:
	game_over_screen.visible = true
	get_tree().paused = true

func on_victory() -> void:
	victory_screen.visible = true
	get_tree().paused = true
