extends Node2D

@onready var goat = $Goat
@onready var win := get_window()

# goat is 48x48, window is 64x64, so offset centers the sprite 
var offset := Vector2i(24, 922) 

func _physics_process(delta):
	# NEED TO FIX THE DELAY WINDOWS
	win.position = Vector2i(goat.global_position) + offset

func _ready():
	pass
