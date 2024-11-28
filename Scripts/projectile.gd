extends Area2D

@export var rotation_speed: float = 1000
@export var projectile_speed: float = 200
@export var despawn_time: float = 5
var current_time: float = 0

func _ready() -> void:
	self.rotation_degrees = 0

func _process(delta: float) -> void:
	# Handle despawn time
	current_time = current_time + delta
	if current_time > despawn_time:
		queue_free()
	
	# Move the projectile forward
	var new_pos: float = projectile_speed * delta
	var current_position: Vector2 = self.position
	self.position = Vector2(current_position.x, current_position.y - new_pos)
	
	# Rotate the ball
	var current_rotation: float = self.rotation_degrees
	var delta_speed: float = rotation_speed * delta
	self.rotation_degrees = current_rotation + delta_speed
