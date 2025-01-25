extends Node

var timer: Timer
var game_duration: float = 60
var two_player_game: bool = false

signal game_ended
signal victory

func start_game():
	timer = Timer.new()
	timer.wait_time = game_duration
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(self._on_timer_timeout)
	timer.start()

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

func _on_timer_timeout():
	victory.emit()

func end_game():
	game_ended.emit()
