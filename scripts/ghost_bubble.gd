extends CharacterBody2D

@onready var bubble: CharacterBody2D = $"."
@onready var player: CharacterBody2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hitbox: Hitbox = $Hitbox
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

@onready var poppingFX = preload("res://scenes/death_particle.tscn")

const pop_sound = preload("res://assets/sfx/bubble3.wav")
const ow_sound = preload("res://assets/sfx/ghostbubble.wav")

const SPEED = 100.0
const WAVE_AMPLITUDE = 300.0  # How far the enemy sways
const WAVE_FREQUENCY = 4.0  # How fast it sways
var time_elapsed = 0.0

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]

func _physics_process(delta: float) -> void:
	if player:
		time_elapsed += delta
		var player_position = player.global_position

		# Base movement direction
		var direction = (player_position - global_position).normalized()

		# Apply sinusoidal wave movement to the perpendicular direction
		var perpendicular = Vector2(-direction.y, direction.x)  # Perpendicular vector
		var wave_offset = perpendicular * sin(time_elapsed * WAVE_FREQUENCY) * WAVE_AMPLITUDE

		velocity = (direction * SPEED) + wave_offset
		move_and_slide()

func _on_health_health_depleted() -> void:
	var random_pitch = randf_range(GameManager.pitch_MIN, GameManager.pitch_MAX)
	audio_stream_player_2d.pitch_scale = random_pitch
	audio_stream_player_2d.stream = pop_sound
	audio_stream_player_2d.play()
	
	PlayerManager.add_experience(GameManager.ghost_bubble_xp)
	PlayerManager.add_kill(1)
	
	sprite_2d.visible = false
	hitbox.enabled = false
	await get_tree().create_timer(0.9).timeout
	
	#popping effect
	var pop = poppingFX.instantiate()
	get_tree().root.add_child(pop)
	pop.global_position = self.global_position
	pop.emitting = true
	
	queue_free()



func _on_health_lost_health(amount: float) -> void:
	var random_pitch = randf_range(GameManager.pitch_MIN, GameManager.pitch_MAX)
	audio_stream_player_2d.pitch_scale = random_pitch
	audio_stream_player_2d.stream = ow_sound
	audio_stream_player_2d.play()
	
	var damage_indicator = preload("res://scenes/DamageIndicator.tscn")
	
	var dmg_inst: DamageIndicator = damage_indicator.instantiate()
	var dmg_pos = global_position
	dmg_pos.y -= 400
	dmg_inst.global_position = global_position
	dmg_inst.damage = amount
	
	add_child(dmg_inst)
