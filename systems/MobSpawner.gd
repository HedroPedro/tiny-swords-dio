extends Node2D

@export var creatures : Array[PackedScene]
@export var mobs_per_minute := 60
@onready var path_follow_2d : PathFollow2D = %"PathFollow2D"
var coolwdown := 0.0

func _process(delta : float):
	coolwdown -= delta
	if coolwdown > 0:
		return
	
	var interval = 60 / mobs_per_minute
	coolwdown = interval
	
	var creature_to_be_instantiated : PackedScene = creatures.pick_random()	
	var creature_to_spawn := creature_to_be_instantiated.instantiate()
	creature_to_spawn.global_position = get_point()
	get_tree().root.add_child(creature_to_spawn)

func get_point() -> Vector2:
	path_follow_2d.progress_ratio = randf()
	return path_follow_2d.global_position
