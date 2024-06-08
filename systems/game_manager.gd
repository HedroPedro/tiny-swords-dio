extends Node

signal game_over

var player : Player
var player_position := Vector2(0, 0)
var time_elapsed := 0.0
var time_elapsed_string : String
var kill_count : = 0
var meat_count := 0
var is_game_over := false

func _process(delta):
	time_elapsed += delta;
	var time_elapsed_int := floori(time_elapsed)
	var seconds := time_elapsed_int % 60
	var minutes : int = time_elapsed_int / 60
	time_elapsed_string = "%02d:%02d" % [minutes, seconds]

func end_game() -> void:
	if is_game_over: return
	is_game_over = true
	game_over.emit()

func reset():
	player = null
	player_position = Vector2(0, 0)
	is_game_over = false
	time_elapsed = 0
	time_elapsed_string = ""
	meat_count = 0
	kill_count = 0
	for connection in game_over.get_connections():
		game_over.disconnect(connection["callable"])
