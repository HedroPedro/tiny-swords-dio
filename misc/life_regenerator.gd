extends Node

@export var regeneration_amount := 20

func _ready():
	$"Area2D".body_entered.connect(on_body_entred)

func on_body_entred(body : Node2D) -> void:
	if body.is_in_group("player"):
		var player : Player = body
		player.heal(regeneration_amount)
		player.meat_colleted.emit(regeneration_amount)
		queue_free()
		return
