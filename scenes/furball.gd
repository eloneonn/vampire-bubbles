class_name Furball extends Node2D

var speed: float = 800 
var direction: Vector2 
var damage: float

@onready var hitbox: Hitbox = $Hitbox

func _ready():
	hitbox.damage = damage

func _process(delta: float) -> void:
	
	
	
	position += direction * speed * delta
	position.angle()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
