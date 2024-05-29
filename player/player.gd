class_name Player extends CharacterBody2D

const SPEED := 145
const MAX_HEALTH := 100
@onready var animationPlayer : AnimationPlayer =  $"AnimationPlayer"
@onready var sprite := $"Sprite2D"
@onready var sword_area := $"SwordArea"
@onready var hitbox_area := $"HitBoxArea"
@onready var health_progress_bar := $"ProgressBar"

@export_category("combat_category")
@export var sword_damage := 2
@export var health := 100
@export var death_prefab : PackedScene

@export_category("ritual_category")
@export var ritual_damage := 1
@export var ritual_cooldown := 30.0
@export var ritual_scene : PackedScene

var is_running := false
var was_running := false
var is_attacking := false
var attack_cooldown : = 0.0
var input_vect := Vector2(0, 0)
var hitbox_cooldown := 0.0
var ritual_interval := 30.0

signal meat_colleted(regenration_value : int)

func _ready():
	GameManager.player = self
	health_progress_bar.max_value = MAX_HEALTH

func _process(delta):
	health_progress_bar.value = health
	GameManager.player_position = position
	update_hitbox_detection(delta)
	read_input()
	change_animation()
	update_attack_cooldown(delta)
	update_ritual(delta)
	if Input.is_action_just_pressed("attack"):
		attack()
		

func _physics_process(delta : float) -> void:
	var targetVelocity =  input_vect * SPEED
	if is_attacking:
		targetVelocity *= 0.25
	
	velocity = lerp(velocity, targetVelocity, 0.14)
	move_and_slide()

func attack() -> void:
	if is_attacking:
		return
		
	animationPlayer.play("attack_side_1")
	attack_cooldown = 0.6
	is_attacking = true
	

func change_animation() -> void:
	# Animacao
	if not is_attacking:
		if is_running != was_running:
			if is_running:
				animationPlayer.play("run")
			else:
				animationPlayer.play("idle")
			
	if input_vect.x < 0:
		sprite.flip_h = true
		pass
	elif input_vect.x > 0:
		sprite.flip_h = false
		pass

func update_attack_cooldown(delta : float) -> void:
	if is_attacking:
		if attack_cooldown <= 0:
			is_attacking = false
			is_running = false
			animationPlayer.play("idle")
			return
		attack_cooldown -= delta

func read_input() -> void:
	var deadzone = 0.15
	input_vect = Input.get_vector("move_left", "move_right", "move_up", "move_down", deadzone)
		
	if abs(input_vect.x) < deadzone:
		input_vect.x = 0
		
	if abs(input_vect.y) < deadzone:
		input_vect.y = 0
	
	was_running = is_running
	is_running = not input_vect.is_zero_approx()

func deal_damage_to_enemies() -> void:
	var enemies_overlaping = sword_area.get_overlapping_bodies()
	
	for body in enemies_overlaping:
		if body.is_in_group("enemies"):
			var enemy : Enemy = body
			var direction_to_enemy := (enemy.position - position).normalized()
			var attack_direction : Vector2
			if sprite.flip_h:
				attack_direction = Vector2.LEFT
			else: 
				attack_direction = Vector2.RIGHT
			var dot_prod := direction_to_enemy.dot(attack_direction)
			if dot_prod >= 0.3:
				enemy.take_damage(sword_damage)

func update_hitbox_detection(delta: float) -> void:
	hitbox_cooldown -= delta
	if hitbox_cooldown > 0:
		return
	
	hitbox_cooldown = 1.5
	
	for body in hitbox_area.get_overlapping_bodies():
		if body.is_in_group("enemies"):
			var enemy : Enemy = body
			var damage_amount := 1
			take_damage(damage_amount)

func take_damage(amount : int) -> void:
	if health < 0: 
		return
	health -= amount
	
	modulate = Color.RED
	var tween := create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.35)
	
	if(health < 1):
		die()

func die() -> void:
	if death_prefab:
		var death_obj := death_prefab.instantiate()
		death_obj.position = position
		get_parent().add_child(death_obj)
	queue_free()

func heal(amount : int) -> int:
	health += amount
	
	if(health > MAX_HEALTH):
		health = MAX_HEALTH
	return health

func update_ritual(delta : float) -> void:
	ritual_cooldown -= delta
	if ritual_cooldown > 0:
		return
	ritual_cooldown = ritual_interval
	
	var ritual := ritual_scene.instantiate()
	ritual.damage = ritual_damage
	add_child(ritual)
