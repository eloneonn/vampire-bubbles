extends Node

var max_health: float = 100.0
var experience: float = 0.0
var kill_count: int = 0

func add_experience(amount: float) -> void:
	experience += amount

func add_kill(amount: int) -> void:
	kill_count += amount

func reset_stats() -> void:
	max_health = 100
	experience = 0
	kill_count = 0
