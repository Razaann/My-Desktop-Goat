extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var start_position: Vector2
@export var patrol_distance = 200.0 # Try to randomize it
var left_limit: float
var right_limit: float

func _ready():
	start_position = global_position
	left_limit = start_position.x - patrol_distance / 2
	right_limit = start_position.x + patrol_distance / 2	

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		$GoatSprite.play("walk")
		if direction < 0:
			$GoatSprite.flip_h = true
			velocity.x = direction * SPEED
		elif direction > 0:
			$GoatSprite.flip_h = false
			velocity.x = direction * SPEED
	else:
		$GoatSprite.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

#func patrol_movement():
	## Move in patrol direction
	#velocity.x = patrol_direction * patrol_speed
#
	## Turn around if we reach the patrol boundaries
	#if patrol_direction < 0 and global_position.x <= left_limit:
		#patrol_direction = 0
		#await get_tree().create_timer(1.0).timeout
		#patrol_direction = 1
	#elif patrol_direction > 0 and global_position.x >= right_limit:
		#patrol_direction = 0
		#await get_tree().create_timer(1.0).timeout
		#patrol_direction = -1
	#
	## Flip sprite based on movement direction
	#if patrol_direction > 0:
		#animated_sprite.flip_h = false
	#elif patrol_direction < 0:
		#animated_sprite.flip_h = true
