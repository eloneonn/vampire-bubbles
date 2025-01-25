extends CharacterBody2D

const speed = 700.0
@onready var health: Health = $Health
@onready var time_label: Label = $Camera2D/HUD/MarginContainer/HBoxContainer/VBoxContainer/TimerLable
@onready var xp_label: Label = $Camera2D/HUD/MarginContainer/HBoxContainer/VBoxContainer/XPLable
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $WeaponAnimations
@onready var health_bar: ProgressBar = $Camera2D/HUD/MarginContainer/HBoxContainer/VBoxContainer/HealthBar
@onready var weapon: Weapon = $Weapon
@onready var player_animations: AnimatedSprite2D = $PlayerAnimations

var is_moving: bool = false  # Track movement

func _ready():
	health.MAX_HEALTH = PlayerManager.max_health
	health_bar.max_value = health.MAX_HEALTH  # Set max health for the bar
	health_bar.value = health.health  # Initialize health bar
	xp_label.text = str(PlayerManager.experience)

func _physics_process(delta: float) -> void:
	var input_vector = Input.get_vector("left", "right", "up", "down")
	velocity = input_vector * speed
	is_moving = velocity.length() > 0
	
	if Input.is_action_pressed("right"):
		player_animations.flip_h = true
	if Input.is_action_pressed("left"):
		player_animations.flip_h = false

	# Rotate hitbox only when moving
	if is_moving:
		player_animations.play("walk")
		weapon.rotation = velocity.angle()
		animated_sprite_2d.rotation = velocity.angle()
	else:
		player_animations.play("idle")
		
	move_and_slide()

func _on_health_health_depleted() -> void:
	GameManager.end_game()

func _process(delta: float) -> void:
	time_label.text = "Time left " + GameManager.get_time()
	xp_label.text = "XP " + str(PlayerManager.experience)

func _on_health_lost_health(amount: float) -> void:
	# animation_player.play("hit")
	print(health.health)
	health_bar.value = health.health  # Update health bar when damaged

func _on_weapon_attack(weapon_type: WeaponType) -> void:
	animated_sprite_2d.play(weapon_type.animation)
