extends CanvasLayer

@onready var timer_label := %TimerLabel
#@onready var gold_label := %GoldLabel
@onready var meat_label := %MeatLabel

var time_elapsed := 0.0
var meat_counter := 0.0

func _ready():
	GameManager.player.meat_colleted.connect(on_meat_colleted)
	meat_label.text = str(meat_counter)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float):
	time_elapsed += delta;
	var time_elapsed_int := floori(time_elapsed)
	var seconds := time_elapsed_int % 60
	var minutes : int = time_elapsed_int / 60
	timer_label.text = "%02d:%02d" % [minutes, seconds]

func on_meat_colleted(regeneration_value : int) -> void:
	meat_counter += 1
	meat_label.text = str(meat_counter)
