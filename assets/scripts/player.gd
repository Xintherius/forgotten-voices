extends CharacterBody2D

# Constants
const SPEED = 500.0  # Movement speed
const JUMP_VELOCITY = -500.0  # Jump velocity

# Variables
var enemy_inattack_range = false  # Tracks if an enemy is in attack range
var enemy_attack_cooldown = true  # Cooldown status for enemy attacks
var health = 100  # Player health
var player_alive = true  # Player alive status

# Exports and Onready Variables
@export var attacking = false  # Whether the player is currently attacking
@onready var timer: Timer = $Timer  # Timer node for handling attack cooldown
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D  # Animated sprite for the player
@onready var original_position: Vector2 = animated_sprite.position  # Original position of the sprite

# Handles movement, animations, and attack area flipping
func _physics_process(delta: float) -> void:
	# Apply gravity when not on the floor
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle sprite flipping
	var direction := Input.get_axis("move_left", "move_right")
	if direction > 0:
		animated_sprite.flip_h = false
		$AttackArea.scale.x = 1  # Attack area on the right
	elif direction < 0:
		animated_sprite.flip_h = true
		$AttackArea.scale.x = -1  # Attack area on the left

	# Handle animations and positioning if not attacking
	if not attacking:
		if is_on_floor():
			# Idle or running animations
			if direction == 0:
				animated_sprite.play("idle")
				animated_sprite.scale = Vector2(1, 1)  # Reset scale for idle animation
				animated_sprite.position = original_position  # Reset position for idle
			else:
				animated_sprite.play("run")
				animated_sprite.scale = Vector2(4, 4)  # Adjust scale for running
				animated_sprite.position = original_position + Vector2(0, 20)  # Adjust position for running
		else:
			# Jump animation
			animated_sprite.play("jump")
			animated_sprite.scale = Vector2(4, 4)  # Adjust scale for jumping
			animated_sprite.position = original_position + Vector2(0, 20)  # Adjust position for jumping

	# Handle movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

# Detect when an enemy enters the player's hitbox
func _on_player_hitbox_body_entered(body):
	if body.has_method("monster"):  # Check if the body has a "monster" method
		enemy_inattack_range = true

# Detect when an enemy exits the player's hitbox
func _on_player_hitbox_body_exited(body):
	if body.has_method("monster"):  # Check if the body has a "monster" method
		enemy_inattack_range = false

# Process input for attacks
func _process(delta):
	if Input.is_action_just_pressed("attack"):
		attack()

# Handles the player's attack logic
func attack():
	var overlapping_objects = $AttackArea.get_overlapping_areas()  # Get objects in the attack area
	for area in overlapping_objects:
		var parent = area.get_parent()  # Get the parent of the overlapping area
		print(parent.name)  # Debug: Print the name of the parent node

	attacking = true  # Set attacking to true
	animated_sprite.play("attack")  # Play the attack animation
	animated_sprite.scale = Vector2(5, 5)  # Adjust scale for the attack animation
	animated_sprite.position = original_position + Vector2(0, 22)  # Adjust position for the attack animation
	timer.start()  # Start the attack cooldown timer

# Handles the end of the attack
func _on_timer_timeout() -> void:
	attacking = false  # Reset attacking state
