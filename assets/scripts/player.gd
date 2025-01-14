extends CharacterBody2D

#Constants
const SPEED = 500.0
const JUMP_VELOCITY = -500.0

#Variables
var enemy_inattack_range = false
var enemy_attack_cooldown = true
var health = 100
var player_alive = true

@export var attacking = false
@onready var timer: Timer = $Timer

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var original_position: Vector2 = animated_sprite.position  # Store the original position

func _physics_process(delta: float) -> void:
	
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")

	if direction > 0:
		animated_sprite.flip_h = false
		$AttackArea.scale.x = abs($AttackArea.scale.x)
	
	elif direction < 0:
		animated_sprite.flip_h = true
		$AttackArea.scale.x = abs($AttackArea.scale.x) * -1

	if !attacking:
		#Resizes the model and positions it
		if is_on_floor():
			# Play animations and adjust position
			if direction == 0:
				animated_sprite.play("idle")
				animated_sprite.scale = Vector2(1, 1)  # Adjust the scale for the idle animation
				animated_sprite.position = original_position  # Reset to original position
			else:
				animated_sprite.play("run")
				animated_sprite.scale = Vector2(4, 4)  # Reset to default scale for the run animation
				animated_sprite.position = original_position + Vector2(0, 20)  # Lower the position for the run animation
		else:
			
			animated_sprite.play("jump")
			animated_sprite.scale = Vector2(4, 4)  # Reset to default scale for the run animation
			animated_sprite.position = original_position + Vector2(0, 20)  # Lower the position for the run animation
			
	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	

func player():
	pass

#Sets the monster to follow the player if the player gets in the area
func _on_player_hitbox_body_entered(body):
	if body.has_method("monster"):
		enemy_inattack_range = true


func _on_player_hitbox_body_exited(body:):
	if body.has_method("monster"):
		enemy_inattack_range = false
		
func _process(delta):
	if Input.is_action_just_pressed("attack"):
		attack()
		
func attack():
	var overlapping_objects = $AttackArea.get_overlapping_areas()
	
	for area in overlapping_objects:
		var parent = area.get_parent()
		print(parent.name)
		
	
	attacking = true
	animated_sprite.play("attack")
	animated_sprite.scale = Vector2(5, 5)  # Adjust the scale for the idle animation
	animated_sprite.position = original_position + Vector2(0,22)  # Reset to original position
	timer.start()
		
		
func _on_timer_timeout() -> void:
	attacking = false
