extends Node2D

const WIDTH = 256
const HEIGHT = 256

@export var white_probability: float = 0.001
@export var primary_color: Color = Color(0.1, 0.1, 0.1)
@export var secondary_color: Color = Color(1, 1, 1)
@export var scroll_speed: float = 1

var sprite_deletion_count: int = 0

func generate_background() -> ImageTexture:
	var image: Image = Image.create(WIDTH, HEIGHT, false, Image.FORMAT_RGB8)
	
	# Generate pixels
	for x in range(WIDTH):
		for y in range(HEIGHT):
			var color: Color = Color(1, 1, 1) if randf() < white_probability else Color(0.1, 0.1, 0.1)
			image.set_pixel(x, y, color)
	
	# Create a texture from the image
	return ImageTexture.create_from_image(image)

func _ready() -> void:
	var texture: ImageTexture = generate_background()
	
	var sprite: Sprite2D = Sprite2D.new()
	sprite.texture = texture
	sprite.position = Vector2(0, 0)
	sprite.z_index = -1
	add_child(sprite)
	
	var second_sprite: Sprite2D = Sprite2D.new()
	second_sprite.texture = texture
	second_sprite.position = Vector2(0, HEIGHT)
	second_sprite.z_index = -1
	add_child(second_sprite)
	
	set_process(true)

func _process(delta: float) -> void:
	for child in get_children():
		if child is Sprite2D:
			child.position.y += scroll_speed * delta

			if child.position.y >= HEIGHT:
				child.queue_free()

				var new_sprite: Sprite2D = Sprite2D.new()
				var texture: ImageTexture = generate_background()
				new_sprite.texture = texture
				new_sprite.position = Vector2(0, -HEIGHT + 5)
				new_sprite.z_index = -1
				add_child(new_sprite)
