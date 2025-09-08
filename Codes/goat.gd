extends CharacterBody2D

const SPEED = 75.0

var move_direction: int = 0 # -1 = left, 0 = idle, 1 = right

func _ready():
	randomize()
	choose_random_direction()

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	movement()
	
	# Move and check collisions
	var prev_velocity_x = velocity.x
	move_and_slide()
	
	# If we were moving but x-velocity becomes 0 -> we hit a wall
	if move_direction != 0 and is_on_wall():
		move_direction = 0
		await get_tree().create_timer(0.5).timeout
		move_direction *= -1  # turn around

func movement():
	if move_direction == -1:
		$GoatSprite.play("walk")
		$GoatSprite.flip_h = true
		velocity.x = -SPEED
	elif move_direction == 1:
		$GoatSprite.play("walk")
		$GoatSprite.flip_h = false
		velocity.x = SPEED
	else:
		$GoatSprite.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)

func choose_random_direction():
	# Pick a new random direction every 1–3 seconds
	move_direction = randi_range(-1, 1)  
	await get_tree().create_timer(randf_range(1.5, 3.0)).timeout
	choose_random_direction()
