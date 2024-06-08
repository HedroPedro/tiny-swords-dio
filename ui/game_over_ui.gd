class_name GameOverUi extends CanvasLayer

@onready var time_label := %"TimeCountLabel"
@onready var kill_label := %"KillCountLabel"

@export var restart_delay := 5.0
var restart_cooldown : float

func _ready():
	restart_cooldown = restart_delay
	time_label.text = GameManager.time_elapsed
	kill_label.text = str(GameManager.kill_count) 

func _process(delta):
	restart_cooldown -= delta
	if restart_cooldown <= 0.0:
		restart_game()

func restart_game() -> void:
	GameManager.reset()
	get_tree().reload_current_scene()
