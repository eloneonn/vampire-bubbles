extends CharacterBody2D

const speed = 700.0
@onready var health: Health = $Health
@onready var time_label: Label = $Camera2D/HUD/MarginContainer/HBoxContainer/VBoxContainer/TimerLable
@onready var health_lable: Label = $Camera2D/HUD/MarginContainer/HBoxContainer/VBoxContainer/HealthLable
@onready var hitbox: Hitbox = $Hitbox
@onready var xp_label: Label = $Camera2D/HUD/MarginContainer/HBoxContainer/VBoxContainer/XPLable
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var is_moving: bool = false  # New variable to track movement

func _ready():
	health.MAX_HEALTH = PlayerManager.max_health
	xp_label.text = str(PlayerManager.experience)

func _physics_process(delta: float) -> void:
	var input_vector = Input.get_vector("left", "right", "up", "down")
	velocity = input_vector * speed
	is_moving = velocity.length() > 0

	# Rotate hitbox only when moving
	if is_moving:
		hitbox.rotation = velocity.angle()
		
	move_and_slide()

func _on_health_health_depleted() -> void:
	GameManager.end_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_label.text = "Time left " + GameManager.get_time()
	health_lable.text = "HP " + str(health.health)
	xp_label.text = "XP " + str(PlayerManager.experience)
	pass

func _on_health_lost_health() -> void:
	animation_player.play("hit")
