extends Node2D

const WIDTH = 256
const HEIGHT = 256

@export var white_probability: float = 0.001
@export var primary_color: Color = Color(0.1, 0.1, 0.1)
@export var secondary_color: Color = Color(1, 1, 1)
@export var scroll_speed: float = 1
var cscript: Script = load("res://Scripts/background-move.gd")

func generate_background() -> void:
	var image: Image = Image.create(WIDTH, HEIGHT, false, Image.FORMAT_RGB8)
	
	# Generate pixels
	for x in range(WIDTH):
		for y in range(HEIGHT):
			var color: Color = Color(1, 1, 1) if randf() < white_probability else Color(0.1, 0.1, 0.1)
			image.set_pixel(x, y, color)
		
	# Create a texture from the image
	var texture: ImageTexture = ImageTexture.create_from_image(image)
	
	# Display the texture
	var sprite: Sprite2D = Sprite2D.new()
	sprite.texture = texture
	sprite.z_index = -1
	sprite.set_script(cscript)
	sprite.scroll_speed = scroll_speed
	add_child(sprite)

func _ready() -> void:
	generate_background()
