extends Node

@export var SPEED := 315

var sprite : AnimatedSprite2D
var enemy : Enemy

func  _ready():
	enemy = get_parent()
	sprite = enemy.get_node("AnimatedSprite2D")

func _physics_process(delta : float) -> void:
	if GameManager.is_game_over:
		return
	
	var difference := (GameManager.player_position - enemy.position).normalized()
	enemy.velocity = difference * SPEED * delta * 10
	enemy.move_and_slide()
	if enemy.velocity.x < 0:
		sprite.flip_h = true
	elif enemy.velocity.x > 0:
		sprite.flip_h = false
