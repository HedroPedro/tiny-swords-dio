extends Node2D

var value := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	%"Label".text = str(value)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
