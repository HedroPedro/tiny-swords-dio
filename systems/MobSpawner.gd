class_name MobSpawner extends Node2D

@export var creatures : Array[PackedScene]
@export var mobs_per_minute : int
@onready var path_follow_2d : PathFollow2D = %"PathFollow2D"
var coolwdown := 0.0

func _process(delta : float):
	coolwdown -= delta
	if coolwdown > 0 or GameManager.is_game_over:
		return
	
	var interval : int = 60 / mobs_per_minute
	coolwdown = interval
	
	var point := get_point()
	var world_state := get_world_2d().direct_space_state
	var parameter := PhysicsPointQueryParameters2D.new()
	parameter.position = point
	var result := world_state.intersect_point(parameter, 1)
	if not result.is_empty():
		return
	var creature_to_be_instantiated : PackedScene = creatures.pick_random()	
	var creature_to_spawn := creature_to_be_instantiated.instantiate()
	creature_to_spawn.global_position = point
	add_sibling(creature_to_spawn)

func get_point() -> Vector2:
	path_follow_2d.progress_ratio = randf()
	return path_follow_2d.global_position
