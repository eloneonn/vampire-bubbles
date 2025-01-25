extends CharacterBody2D

const speed = 700.0
@onready var health: Health = $Health
@onready var time_label: Label = $Camera2D/HUD/MarginContainer/HBoxContainer/VBoxContainer/TimerLable
@onready var hitbox: Hitbox = $Hitbox
@onready var xp_label: Label = $Camera2D/HUD/MarginContainer/HBoxContainer/VBoxContainer/XPLable
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_bar: ProgressBar = $Camera2D/HUD/MarginContainer/HBoxContainer/VBoxContainer/HealthBar
@onready var xp_bar: ProgressBar = $Camera2D/HUD/MarginContainer/HBoxContainer/VBoxContainer/XPBar

var is_moving: bool = false  # Track movement

func _ready():
	health.MAX_HEALTH = PlayerManager.max_health
	health_bar.max_value = health.MAX_HEALTH  # Set max health for the bar
	health_bar.value = health.health  # Initialize health bar
	xp_label.text = str(PlayerManager.experience)
	PlayerManager.xp_changed.connect(_on_xp_change)

func _physics_process(delta: float) -> void:
	var input_vector = Input.get_vector("left", "right", "up", "down")
	velocity = input_vector * speed
	is_moving = velocity.length() > 0

	# Rotate hitbox only when moving
	if is_moving:
		hitbox.rotation = velocity.angle()
		animated_sprite_2d.rotation = velocity.angle()
		
	move_and_slide()

func _on_health_health_depleted() -> void:
	GameManager.end_game()

func _process(delta: float) -> void:
	time_label.text = "Time left " + GameManager.get_time()
	xp_label.text = "XP " + str(PlayerManager.experience)

func _on_health_lost_health(amount: float) -> void:
	animation_player.play("hit")
	print(health.health)
	health_bar.value = health.health  # Update health bar when damaged


func _on_hitbox_hit() -> void:
	animated_sprite_2d.play("claw")

func _on_xp_change(xp: float) -> void:
	xp_bar.value = xp
