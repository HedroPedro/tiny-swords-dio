class_name Enemy extends CharacterBody2D


@export_category("Life And Death")
@export var health := 10
@export var death_prefab : PackedScene
@onready var damage_digit_marker := $DamageDigitMarker

var damage_digit_prefab : PackedScene

@export_category("Drops")
@export var drop_chance := 0.1
@export var drop_items : Array[PackedScene]
@export var drop_rarity : Array[float]

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
	
	if randf() <= drop_chance:
		drop_item()
	GameManager.kill_count += 1
	queue_free()

func get_random_drop() -> PackedScene:
	if drop_items.size() == 1:
		return drop_items[0]
	
	var max_chance := 0.0
	var random_val : float
	for rarity in drop_rarity:
		max_chance += rarity
	random_val = randf() * max_chance
	var needle := 0.0
	
	for i in drop_items.size():
		var drop_item = drop_items[i]
		var rarity = drop_rarity[i] if i < drop_rarity.size() else 1
		if random_val <= drop_chance + needle:
			return drop_item
		needle += rarity
	return drop_items[0]

func drop_item() -> void :
	var item := get_random_drop().instantiate()
	item.position = position
	add_sibling(item)
