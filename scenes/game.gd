extends Node2D

@onready var game_over_screen: CanvasLayer = $GameOverScreen
@onready var victory_screen: CanvasLayer = $VictoryScreen
@onready var victory_label: Label = $VictoryScreen/CenterContainer/VBoxContainer/Label
@onready var game_over_label: Label = $GameOverScreen/CenterContainer/VBoxContainer/Label
@onready var main_menu: CanvasLayer = $MainMenu
@onready var check_button: CheckButton = $MainMenu/MarginContainer/CenterContainer/VBoxContainer/CheckButton
@onready var pause_menu: CanvasLayer = $PauseMenu

func _ready() -> void:
	main_menu.visible = true
	get_tree().paused = true
	GameManager.game_ended.connect(on_game_end)
	GameManager.victory.connect(on_victory)
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		pause_game()

func _on_restart_button_pressed() -> void:
	PlayerManager.reset_stats()
	reload_game()

func on_game_end() -> void:
	game_over_label.text = "You Lost\n" + "You survived for " + str(GameManager.game_duration - GameManager.get_time_float()) + " seconds"
	game_over_screen.visible = true
	get_tree().paused = true

func on_victory() -> void:
	victory_label.text = "You Win!!!\n" + "You destroyed " + str(PlayerManager.kill_count)
	victory_screen.visible = true
	get_tree().paused = true

func pause_game(): 
	pause_menu.visible = true
	get_tree().paused = true
	
func reload_game():
	for node in get_tree().get_nodes_in_group("enemies"):
		node.queue_free()
	
	get_tree().paused = false
	game_over_screen.visible = false
	get_tree().reload_current_scene()

func _on_start_game_pressed() -> void:
	get_tree().paused = false
	main_menu.visible = false
	GameManager.start_game()

func _on_check_button_toggled(toggled_on: bool) -> void:
	GameManager.two_player_game = toggled_on
	check_button.button_pressed = toggled_on

func _on_continue_pressed() -> void:
	pause_menu.visible = false
	get_tree().paused = false

func _on_back_to_menu_pressed() -> void:
	reload_game()
