extends CharacterBody2D

const speed = 300.0
@onready var health: Health = $Health
@onready var time_label: Label = $Camera2D/HUD/MarginContainer/HBoxContainer/VBoxContainer/TimerLable
@onready var health_lable: Label = $Camera2D/HUD/MarginContainer/HBoxContainer/VBoxContainer/HealthLable
@onready var hitbox: Hitbox = $Hitbox

func _ready():
	health.MAX_HEALTH = PlayerManager.max_health

func _physics_process(delta: float) -> void:
	var input_vector = Input.get_vector("left", "right", "up", "down")
	velocity = input_vector * speed
	hitbox.rotation = velocity.angle()
	
	move_and_slide()

func _on_health_health_depleted() -> void:
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_label.text = GameManager.get_time()
	health_lable.text = str(health.health)
	pass
