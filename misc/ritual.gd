extends Node2D

@export var damage := 2
@onready var area_2d := $Area2D

func deal_damage() -> void:
	var bodies = area_2d.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy : Enemy = body
			enemy.take_damage(damage)
