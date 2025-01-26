extends Node2D

@onready var game_over_screen: CanvasLayer = $GameOverScreen
@onready var victory_screen: CanvasLayer = $VictoryScreen
@onready var main_menu: CanvasLayer = $MainMenu
@onready var check_button: CheckButton = $MainMenu/MarginContainer/CenterContainer/VBoxContainer/CheckButton
@onready var pause_menu: CanvasLayer = $PauseMenu
@onready var upgrade_screen: CanvasLayer = $UpgradeScreen
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var center_container: MarginContainer = $MainMenu/CenterContainer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var game_over_label: Label = $GameOverScreen/CenterContainer/MarginContainer/VBoxContainer/Label
@onready var victory_label: Label = $VictoryScreen/CenterContainer/MarginContainer/VBoxContainer/Label
@onready var center_container_2: CenterContainer = $MainMenu/CenterContainer2

@onready var upgrade_button_1: TextureButton = %UpgradeButton1
@onready var upgrade_button_2: TextureButton = %UpgradeButton2
@onready var upgrade_button_3: TextureButton = %UpgradeButton3
@onready var start_button: TextureButton = $MainMenu/MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/StartButton

var music_track = preload("res://assets/music/2_minute_banger.mp3")
var victory_clap = preload("res://assets/sfx/735573__pluralz__clapping-large-crowd-at-choir-concert-13.wav")
var narrative = preload("res://assets/music/narrative.wav")
var lost_narrative = preload("res://assets/music/lost_narrative.wav")
var heal_upgrade: Enums.Upgrade
var upgrade_1: Enums.Upgrade
var upgrade_2: Enums.Upgrade

func _ready() -> void:
	main_menu.visible = true
	audio_stream_player.stream = narrative
	audio_stream_player.play()
	get_tree().paused = true
	GameManager.game_ended.connect(on_game_end)
	GameManager.victory.connect(on_victory)
	PlayerManager.level_up.connect(on_level_up)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		pause_game()

func _on_restart_button_pressed() -> void:
	PlayerManager.reset_stats()
	reload_game()

func on_game_end() -> void:
	audio_stream_player.stream = lost_narrative
	audio_stream_player.play()
	game_over_label.text = "You Lost\n" + "You survived for " + str(GameManager.game_duration - GameManager.get_time_float()) + " seconds"
	game_over_screen.visible = true
	get_tree().paused = true

func on_victory() -> void:
	victory_label.text = "You Win!!!\n" + "You destroyed " + str(PlayerManager.kill_count) + " bubbles"
	audio_stream_player.stream = victory_clap
	audio_stream_player.play()
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

func start_game():
	get_tree().paused = false
	GameManager.start_game()

func _on_check_button_toggled(toggled_on: bool) -> void:
	GameManager.two_player_game = toggled_on
	check_button.button_pressed = toggled_on

func _on_continue_pressed() -> void:
	pause_menu.visible = false
	get_tree().paused = false

func _on_back_to_menu_pressed() -> void:
	reload_game()

func on_level_up(level: int):
	get_tree().paused = true
	upgrade_screen.visible = true
	upgrade_1 = -1
	upgrade_2 = -1
	
	heal_upgrade = Utils.Heals.pick_random()
	
	var available_upgrades: Array[Enums.Upgrade]
	
	available_upgrades.append_array(Utils.ClawUpgrades)
	available_upgrades.append(Enums.Upgrade.PLAYER_SPEED)
	
	if level > 3 and !PlayerManager.has_upgrade(Enums.Upgrade.TAILWHIP):
		available_upgrades.append(Enums.Upgrade.TAILWHIP)
		upgrade_1 = Enums.Upgrade.TAILWHIP
	
	if level > 5 and !PlayerManager.has_upgrade(Enums.Upgrade.FURBALL):
		available_upgrades.append(Enums.Upgrade.FURBALL)
		if upgrade_1 == -1:
			upgrade_1 = Enums.Upgrade.FURBALL
	
	if PlayerManager.has_upgrade(Enums.Upgrade.TAILWHIP):
		available_upgrades.append_array(Utils.TailWhipUpgrades)
	
	if PlayerManager.has_upgrade(Enums.Upgrade.FURBALL):
		available_upgrades.append_array(Utils.FurballUpgrades)
		
	if upgrade_1 == -1:
		upgrade_1 = available_upgrades.pick_random()
	
	var new_upgrades = available_upgrades.filter(func(x): return x != upgrade_1)
	
	upgrade_2 = new_upgrades.pick_random()
	
	upgrade_button_1.texture_normal = get_card_path(upgrade_1)
	upgrade_button_2.texture_normal = get_card_path(heal_upgrade)
	upgrade_button_3.texture_normal = get_card_path(upgrade_2)

func get_card_path(upgrade: Enums.Upgrade):
	match upgrade:
		Enums.Upgrade.PLAYER_SPEED:
			return preload("res://assets/sprites/cards/speed card.png")
		Enums.Upgrade.HEAL_MINOR:
			return preload("res://assets/sprites/cards/cardheal1.png")
		Enums.Upgrade.HEAL_MID:
			return preload("res://assets/sprites/cards/cardheal2.png")
		Enums.Upgrade.HEAL_MAJOR:
			return preload("res://assets/sprites/cards/cardheal3.png")
		Enums.Upgrade.CLAW_DMG:
			return preload("res://assets/sprites/cards/cardclaw1.png")
		Enums.Upgrade.CLAW_SPEED:
			return preload("res://assets/sprites/cards/cardclaw2.png")
		Enums.Upgrade.CLAW_SIZE:
			return preload("res://assets/sprites/cards/cardclaw3.png")
		Enums.Upgrade.TAILWHIP:
			return preload("res://assets/sprites/cards/cardtailwip1.png")
		Enums.Upgrade.TAILWHIP_DMG:
			return preload("res://assets/sprites/cards/cardtailwip2.png")
		Enums.Upgrade.TAILWHIP_SPEED:
			return preload("res://assets/sprites/cards/cardtailwip3.png")
		Enums.Upgrade.TAILWHIP_SIZE:
			return preload("res://assets/sprites/cards/cardtailwip4.png")
		Enums.Upgrade.FURBALL:
			return preload("res://assets/sprites/cards/cardfurball1.png")
		Enums.Upgrade.FURBALL_DMG:
			return preload("res://assets/sprites/cards/cardfurball2.png")
		Enums.Upgrade.FURBALL_SPEED:
			return preload("res://assets/sprites/cards/cardfurball4.png")
		Enums.Upgrade.FURBALL_PROJECTILE:
			return preload("res://assets/sprites/cards/cardfurball3.png")

func _on_upgrade_button_1_pressed() -> void:
	PlayerManager.add_upgrade(upgrade_1)
	get_tree().paused = false
	upgrade_screen.visible = false

## THIS IS ALWAYS THE HEAL
func _on_upgrade_button_2_pressed() -> void:
	PlayerManager.add_upgrade(heal_upgrade)
	get_tree().paused = false
	upgrade_screen.visible = false

func _on_upgrade_button_3_pressed() -> void:
	PlayerManager.add_upgrade(upgrade_2)
	get_tree().paused = false
	upgrade_screen.visible = false


func _on_start_button_pressed() -> void:
	animation_player.play("start_game_countdown")
	main_menu.visible = false
	audio_stream_player.stream = music_track
	audio_stream_player.play()

#3 settings
func _on_texture_button_pressed() -> void:
	center_container.visible = true

## quit
func _on_texture_button_2_pressed() -> void:
	pass # Replace with function body.

## back from settings
func _on_back_pressed() -> void:
	center_container.visible = false
	pass # Replace with function body.

func _on_credits_button_pressed() -> void:
	center_container_2.visible = !center_container_2.visible
