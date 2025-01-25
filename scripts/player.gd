extends CharacterBody2D

const speed = 700.0
@onready var health: Health = $Health
@onready var time_label: Label = $Camera2D/HUD/MarginContainer/HBoxContainer/VBoxContainer/TimerLable
@onready var health_bar: ProgressBar = $Camera2D/HUD/MarginContainer/HBoxContainer/VBoxContainer/HealthBar
@onready var xp_bar: ProgressBar = $Camera2D/HUD/MarginContainer/HBoxContainer/VBoxContainer/XPBar
@onready var player_animations: AnimatedSprite2D = $PlayerAnimations
@onready var claw: Weapon = $Claw
@onready var claw_animations: AnimatedSprite2D = $Claw/ClawAnimations
@onready var tail_whip_animations: AnimatedSprite2D = $TailWhip/TailWhipAnimations
@onready var tail_whip: Weapon = $TailWhip
@onready var projectile_weapon = $Projectile_Weapon

var is_moving: bool = false  # Track movement

func _ready():
	health.MAX_HEALTH = PlayerManager.max_health
	health_bar.max_value = health.MAX_HEALTH  # Set max health for the bar
	health_bar.value = health.health  # Initialize health bar
	PlayerManager.xp_changed.connect(_on_xp_change)
	PlayerManager.received_upgrade.connect(on_upgrade_receive)

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
		claw.rotation = velocity.angle()
		tail_whip.rotation = velocity.angle()
	else:
		player_animations.play("idle")
	
	move_and_slide()

func _on_health_health_depleted() -> void:
	GameManager.end_game()

func _process(delta: float) -> void:
	time_label.text = "Time left " + GameManager.get_time()

func _on_health_lost_health(amount: float) -> void:
	# animation_player.play("hit")
	health_bar.value = health.health  # Update health bar when damaged

func _on_xp_change(xp: float) -> void:
	xp_bar.value = xp

func on_upgrade_receive(upgrade: Enums.Upgrade):
	match upgrade:
		Enums.Upgrade.HEAL_MINOR:
			health.heal(25)
		Enums.Upgrade.HEAL_MID:
			health.heal(50)
		Enums.Upgrade.HEAL_MAJOR:
			health.heal(75)
		Enums.Upgrade.CLAW_DMG:
			claw.damage += claw.damage * 0.25
		Enums.Upgrade.CLAW_SPEED:
			claw.speed += claw.speed * -0.25
		#Enums.Upgrade.CLAW_SIZE:
		Enums.Upgrade.TAILWHIP:
			tail_whip.enabled = true
		Enums.Upgrade.TAILWHIP_DMG:
			tail_whip.damage += tail_whip.damage * 0.25
		Enums.Upgrade.TAILWHIP_SPEED:
			tail_whip.speed += tail_whip.speed * 0.25
		#Enums.Upgrade.TAILWHIP_SIZE:
		Enums.Upgrade.FURBALL:
			print("param3 is not 3!")
		Enums.Upgrade.FURBALL_DMG:
			print("param3 is not 3!")
		#Enums.Upgrade.FURBALL_SPEED:
		Enums.Upgrade.FURBALL_PROJECTILE:
			print("param3 is not 3!")

func _on_claw_attack() -> void:
	claw_animations.play("claw")

func _on_tail_whip_attack() -> void:
	tail_whip_animations.play("hit")
