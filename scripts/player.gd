extends CharacterBody2D

var speed = 700.0
@onready var health: Health = $Health
@onready var time_label: Label = $Camera2D/HUD/MarginContainer/HBoxContainer/VBoxContainer/TimerLable
@onready var health_bar: ProgressBar = $HealthBar
@onready var xp_bar: ProgressBar = $Camera2D/HUD/MarginContainer/HBoxContainer/VBoxContainer/XPBar
@onready var player_animations: AnimatedSprite2D = $PlayerAnimations
@onready var claw: Weapon = $Claw
@onready var claw_animations: AnimatedSprite2D = $Claw/ClawAnimations
@onready var tail_whip_animations: AnimatedSprite2D = $TailWhip/TailWhipAnimations
@onready var tail_whip: Weapon = $TailWhip
@onready var furball: Projectile_Weapon = $Projectile_Weapon
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var camera: PlayerCamera = $Camera2D
@onready var dying_rect: TextureRect = $Camera2D/HUD/DyingRect

var claw_sound = preload("res://assets/sfx/claw.wav")
var tailwhip_sound = preload("res://assets/sfx/tailwhip1.wav")
var furball_sound = preload("res://assets/sfx/cough.wav")

var is_moving: bool = false  # Track movement
var meows = [
preload("res://assets/sfx/meow1.wav"),
preload("res://assets/sfx/meow2.wav"),
preload("res://assets/sfx/meow3.wav")	
]
var death_meow = preload("res://assets/sfx/deathmeow.wav")

func _ready():
	animation_player.play("RESET")
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
	audio_stream_player_2d.stream = death_meow
	audio_stream_player_2d.play()
	GameManager.end_game()

func _process(delta: float) -> void:
	time_label.text = "Time left " + GameManager.get_time()

func _on_health_lost_health(amount: float) -> void:
	animation_player.play("flash")
	
	audio_stream_player_2d.stream = meows.pick_random()
	audio_stream_player_2d.play()
	camera.apply_shake()
	health_bar.value = health.health  # Update health bar when damaged
	
	if health.health < 25:
		dying_rect.modulate.a = 1
	elif health.health < 35:
		dying_rect.modulate.a = 0.75
	elif health.health < 50:
		dying_rect.modulate.a = 0.50
	else: 
		dying_rect.modulate.a = 0

func _on_xp_change(xp: float, max: float) -> void:
	xp_bar.value = xp
	xp_bar.max_value = max

func on_upgrade_receive(upgrade: Enums.Upgrade):
	match upgrade:
		Enums.Upgrade.PLAYER_SPEED:
			speed += speed * 0.25
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
		Enums.Upgrade.CLAW_SIZE:
			var hitbox: Area2D = claw.get_node("ClawHitbox")
			
			if hitbox:
				hitbox.global_scale.x += hitbox.global_scale.x * 0.25
				hitbox.global_scale.y += hitbox.global_scale.y * 0.25
				
			var anims: AnimatedSprite2D = claw.get_node("ClawAnimations")
			
			if anims:
				anims.global_scale.x += anims.global_scale.x * 0.25
				anims.global_scale.y += anims.global_scale.x * 0.25
		Enums.Upgrade.TAILWHIP:
			tail_whip.enabled = true
		Enums.Upgrade.TAILWHIP_DMG:
			tail_whip.damage += tail_whip.damage * 0.25
		Enums.Upgrade.TAILWHIP_SPEED:
			tail_whip.speed += tail_whip.speed * 0.25
		Enums.Upgrade.TAILWHIP_SIZE:
			var hitbox: Area2D = tail_whip.get_node("Hitbox")
			
			if hitbox:
				hitbox.global_scale.x += hitbox.global_scale.x * 0.25
				hitbox.global_scale.y += hitbox.global_scale.y * 0.25
			
			var anims: AnimatedSprite2D = tail_whip.get_node("TailWhipAnimations")
			
			if anims:
				anims.global_scale.x += anims.global_scale.x * 0.25
				anims.global_scale.y += anims.global_scale.x * 0.25
		Enums.Upgrade.FURBALL:
			furball.enabled = true
		Enums.Upgrade.FURBALL_DMG:
			furball.damage += furball.damage * 0.25
		Enums.Upgrade.FURBALL_SPEED:
			furball.speed += furball.speed * 0.25
		Enums.Upgrade.FURBALL_PROJECTILE:
			furball.amount_of_projectiles = furball.amount_of_projectiles + 1

func _on_claw_attack() -> void:
	claw_animations.play("claw")
	
	var random_pitch = randf_range(GameManager.pitch_MIN, GameManager.pitch_MAX)
	audio_stream_player_2d.pitch_scale = random_pitch
	audio_stream_player_2d.stream = claw_sound
	audio_stream_player_2d.play()

func _on_tail_whip_attack() -> void:
	tail_whip_animations.play("hit")
	
	var random_pitch = randf_range(GameManager.pitch_MIN, GameManager.pitch_MAX)
	audio_stream_player_2d.pitch_scale = random_pitch
	audio_stream_player_2d.stream = tailwhip_sound
	audio_stream_player_2d.play()

func _on_health_gained_health() -> void:
	health_bar.value = health.health
