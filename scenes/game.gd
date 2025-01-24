extends Node2D

@onready var game_over_screen: CanvasLayer = $GameOverScreen

func _ready() -> void:
	get_tree().paused = false
	GameManager.start_game()
	GameManager.game_ended.connect(on_game_end)

func _on_restart_button_pressed() -> void:
	for node in get_tree().get_nodes_in_group("enemies"):
		node.queue_free()

	get_tree().paused = false
	game_over_screen.visible = false
	get_tree().reload_current_scene()

func on_game_end() -> void:
	
	game_over_screen.visible = true
	get_tree().paused = true
