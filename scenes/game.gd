extends Node2D

@onready var game_over_screen: CanvasLayer = $GameOverScreen
@onready var victory_screen: CanvasLayer = $VictoryScreen
@onready var victory_label: Label = $VictoryScreen/CenterContainer/VBoxContainer/Label
@onready var game_over_label: Label = $GameOverScreen/CenterContainer/VBoxContainer/Label

func _ready() -> void:
	get_tree().paused = false
	GameManager.start_game()
	GameManager.game_ended.connect(on_game_end)
	GameManager.victory.connect(on_victory)

func _on_restart_button_pressed() -> void:
	for node in get_tree().get_nodes_in_group("enemies"):
		node.queue_free()
		
	# Resets the players stats	
	PlayerManager.reset_stats()

	get_tree().paused = false
	game_over_screen.visible = false
	get_tree().reload_current_scene()

func on_game_end() -> void:
	game_over_label.text = "You Lost\n" + "You survived for " + str(GameManager.game_duration - GameManager.get_time_float()) + " seconds"
	game_over_screen.visible = true
	get_tree().paused = true

func on_victory() -> void:
	victory_label.text = "You Win!!!\n" + "You destroyed " + str(PlayerManager.kill_count)
	victory_screen.visible = true
	get_tree().paused = true
