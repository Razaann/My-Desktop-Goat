extends Node2D

#@onready var goat_sprite = $GoatSprite from goat tscn


# Called when the node enters the scene tree for the first time.
func _ready():
	# Set background to be transparent
	get_tree().get_root().set_transparent_background(true)
	get_window().mouse_passthrough = true
	
	# Passthrough polygon (from goat)
	var goat = $Goat
	var poly2d: Polygon2D = goat.get_node("Polygon2D")
	get_window().mouse_passthrough_polygon = poly2d.polygon

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	# Fix this thing
	#set_passthrough(goat_sprite)

#func set_passthrough(sprite: AnimatedSprite2D):
	#var texture_center: Vector2 = sprite.texture.get_size() / 2
	#var texture_corners: PackedVector2Array = [
		#sprite.global_position + texture_center * Vector2(-1, -1), # Top left corner
		#sprite.global_position + texture_center * Vector2(1, -1), # Top right corner
		#sprite.global_position + texture_center * Vector2(1 , 1), # Bottom right corner
		#sprite.global_position + texture_center * Vector2(-1 ,1) # Bottom left corner
	#]
#
	#DisplayServer.window_set_mouse_passthrough(texture_corners)
