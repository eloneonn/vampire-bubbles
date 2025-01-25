extends CharacterBody2D

@onready var bubble: CharacterBody2D = $"."
@onready var player: CharacterBody2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hitbox: Hitbox = $Hitbox

const SPEED = 100.0

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]

func _physics_process(delta: float) -> void:
	if player:
		var player_position = player.global_position
		
		var direction = (player_position - global_position).normalized()
		velocity = direction * SPEED
		
		move_and_slide()

func _on_health_health_depleted() -> void:
	PlayerManager.add_experience(1)
	PlayerManager.add_kill(1)
	
	sprite_2d.visible = false
	hitbox.enabled = false
	await get_tree().create_timer(0.9).timeout
	
	queue_free()
