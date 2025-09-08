extends Node2D

@onready var win := get_window()

# Speed in pixels per second
var speed := 60
# Current direction (-1 = left, 1 = right)
var direction := 1
# Change direction timer
var time_to_switch := 2.0
var timer := 0.0

func _ready():
	# Put goat always at center of the window
	$Goat.position = Vector2(24, 24) * $Goat.scale
	win.size = Vector2i(48, 48) # window fits goat

func _physics_process(delta):
	timer += delta
	if timer >= time_to_switch:
		timer = 0.0
		# Randomly flip direction every 2s
		direction = -1 if randf() < 0.5 else 1

	# Move the window horizontally
	win.position.x += int(direction * speed * delta)

	# Flip goat sprite visually
	if direction < 0:
		$Goat/GoatSprite.flip_h = true
	else:
		$Goat/GoatSprite.flip_h = false
