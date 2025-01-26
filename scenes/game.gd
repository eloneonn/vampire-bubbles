extends Node2D

@onready var game_over_screen: CanvasLayer = $GameOverScreen
@onready var victory_screen: CanvasLayer = $VictoryScreen
@onready var victory_label: Label = $VictoryScreen/CenterContainer/VBoxContainer/Label
@onready var game_over_label: Label = $GameOverScreen/CenterContainer/VBoxContainer/Label
@onready var main_menu: CanvasLayer = $MainMenu
@onready var check_button: CheckButton = $MainMenu/MarginContainer/CenterContainer/VBoxContainer/CheckButton
@onready var pause_menu: CanvasLayer = $PauseMenu
@onready var upgrade_screen: CanvasLayer = $UpgradeScreen

@onready var upgrade_button_1: TextureButton = %UpgradeButton1
@onready var upgrade_button_2: TextureButton = %UpgradeButton2
@onready var upgrade_button_3: TextureButton = %UpgradeButton3

var heal_upgrade: Enums.Upgrade
var upgrade_1: Enums.Upgrade
var upgrade_2: Enums.Upgrade

func _ready() -> void:
	main_menu.visible = true
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

func on_level_up(level: int):
	get_tree().paused = true
	upgrade_screen.visible = true
	upgrade_1 = -1
	upgrade_2 = -1
	
	heal_upgrade = Utils.Heals.pick_random()
	
	var available_upgrades: Array[Enums.Upgrade]
	
	available_upgrades.append_array(Utils.ClawUpgrades)
	
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
