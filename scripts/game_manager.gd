extends Node

@onready var timer: Timer = Timer.new()
var game_duration: float = 180
#@onready var cleanup_timer: Timer = Timer.new()

var two_player_game: bool = false

var basic_bubble_xp = 5
var iron_bubble_xp = 25
var ghost_bubble_xp = 15
var split_bubble_xp = 5
var baby_bubble_xp = 15

signal game_ended
signal victory

var pitch_MAX = 1.3
var pitch_MIN = 0.7

func _ready():
	add_child(timer)
#	add_child(cleanup_timer)

func start_game():
	timer.wait_time = game_duration
	timer.one_shot = true
	timer.timeout.connect(self._on_timer_timeout)
	timer.start()
	
#	cleanup_timer.wait_time = 5
#	cleanup_timer.one_shot = false
#	cleanup_timer.timeout.connect(cleanup)
#	cleanup_timer.start()


func get_time():
	if timer and timer.time_left > 0:
		# Calculate the remaining time
		var time_left = int(timer.time_left)
		var minutes = time_left / 60
		var seconds = time_left % 60
		# Update the label text
		return "%02d:%02d" % [minutes, seconds]
	else:
		return "0"

func get_time_float():
	if timer and timer.time_left > 0:
		# Calculate the remaining time
		var time_left = int(timer.time_left)
		# Update the label text
		return time_left
	else:
		return 0.0

func get_progress():
	return abs(timer.time_left - game_duration) / game_duration 

func _on_timer_timeout():
	victory.emit()

func end_game():
	game_ended.emit()

#func cleanup():
#	var enemies = get_tree().get_nodes_in_group("enemies")
#	if enemies.size() > 100:
#		for enemy in enemies:
#			if get_viewport().get_visible_rect().has_point(enemy.position):
#				enemy.queue_free()
	
