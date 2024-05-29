class_name Enemy extends CharacterBody2D

@export var health := 10
@export var death_prefab : PackedScene
@onready var damage_digit_marker := $DamageDigitMarker

var damage_digit_prefab : PackedScene

func _ready():
	damage_digit_prefab = preload("res://misc/damage_digit.tscn")

func take_damage(amount : int) -> void:
	health -= amount
	
	modulate = Color.RED
	var tween := create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.35)
	
	var damage_digit = damage_digit_prefab.instantiate()
	damage_digit.value = amount

	get_parent().add_child(damage_digit)
	if damage_digit_marker:
		damage_digit.global_position = damage_digit_marker.global_position
	else:
		damage_digit.global_position = global_position
	
	if(health < 1):
		die()

func die() -> void:
	if death_prefab:
		var death_obj := death_prefab.instantiate()
		death_obj.position = position
		get_parent().add_child(death_obj)
	queue_free()
