extends CharacterBody2D

const SPEED = 75.0

var move_direction: int = 0 # -1 = left, 0 = idle, 1 = right
@onready var sprite = $GoatSprite

func _ready():
	randomize()
	
	var mat: ShaderMaterial = sprite.material as ShaderMaterial
	if mat == null:
		push_error("GoatSprite needs a ShaderMaterial assigned to its Material property")
		return
	
	# Example: pick a random hue for fur, and make shadow a darker version
	var fur = Color.from_hsv(randf(), 0.4 + randf() * 0.6, 0.9)
	var shadow = fur.darkened(0.35)
	
	mat.set_shader_parameter("new_fur_color", fur)
	mat.set_shader_parameter("new_shadow_color", shadow)
	
	# tweak tolerance if your sprite has anti-aliased edges (0.02..0.12)
	mat.set_shader_parameter("tolerance", 0.06)
	
	#var mat: ShaderMaterial = sprite.material
	#mat.set_shader_parameter("tint_color", random_color())
	
	
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

#func random_color() -> Color:
	## Pick random RGB with full brightness
	#return Color.from_hsv(randf(), 0.8, 1.0) # (hue, saturation, value)
