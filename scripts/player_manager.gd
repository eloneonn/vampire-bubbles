extends Node

var max_health: float = 100.0
var experience: float = 0.0
var kill_count: int = 0
signal xp_changed(value:float)

func add_experience(amount: float) -> void:
	experience += amount
	xp_changed.emit(experience)

func add_kill(amount: int) -> void:
	kill_count += amount

func reset_stats() -> void:
	max_health = 100
	experience = 0
	kill_count = 0
