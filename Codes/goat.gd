extends CharacterBody2D

const SPEED := 50.0

@onready var sprite: AnimatedSprite2D = $GoatSprite

var move_direction: int = 0 # -1 = left, 0 = idle, 1 = right
var current_anim: String = "idle"

func _ready():
	randomize()
	
	# Randomize goat color (requires ShaderMaterial on GoatSprite)
	var mat := sprite.material as ShaderMaterial
	if mat != null:
		var fur = Color.from_hsv(randf(), 0.4 + randf() * 0.6, 0.9)
		var shadow = fur.darkened(0.35)
		mat.set_shader_parameter("new_fur_color", fur)
		mat.set_shader_parameter("new_shadow_color", shadow)
		mat.set_shader_parameter("tolerance", 0.06)
	
	# Start first random animation loop
	_play_random_animation()

func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# If we were moving but x-velocity becomes 0 -> we hit a wall if move_direction != 0 and is_on_wall(): move_direction = 0 await get_tree().create_timer(0.5).timeout move_direction *= -1 # turn around
	if move_direction != 0 and is_on_wall():
		var prev_dir = move_direction
		move_direction = 0
		await get_tree().create_timer(0.5).timeout
		move_direction = -prev_dir
	
	
	# Handle movement depending on current animation
	match current_anim:
		"walk":
			velocity.x = move_direction * SPEED
		"crouch":
			velocity.x = move_direction * (SPEED * 0.4)
		"hurt":
			velocity.x = 0 # freeze
		"idle":
			velocity.x = move_toward(velocity.x, 0, SPEED) # stop smoothly
	
	move_and_slide()
	
	# Flip sprite visually if moving
	if current_anim in ["walk", "crouch"]:
		sprite.flip_h = move_direction < 0

func _play_random_animation() -> void:
	# Pick random animation
	current_anim = ["idle", "idle", "idle", "idle", "walk", "walk", "walk", "hurt", "crouch"].pick_random()
	sprite.play(current_anim)
	
	# Assign random direction if walk/crouch
	if current_anim in ["walk", "crouch"]:
		move_direction = -1 if randf() < 0.5 else 1
	else:
		move_direction = 0
	
	# Wait before switching again
	var wait_time = randf_range(1.5, 4.0)
	await get_tree().create_timer(wait_time).timeout
	_play_random_animation()
