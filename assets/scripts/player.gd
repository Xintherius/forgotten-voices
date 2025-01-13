extends CharacterBody2D

const SPEED = 500.0
const JUMP_VELOCITY = -500.0

var enemy_inattack_range = false
var enemy_attack_cooldown = true
var health = 100
var player_alive = true

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
	
	elif direction < 0:
		animated_sprite.flip_h = true
		

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


func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_inattack_range = true


func _on_player_hitbox_body_exited(body:):
	if body.has_method("enemy"):
		enemy_inattack_range = false

func enemy_attack():
	pass
