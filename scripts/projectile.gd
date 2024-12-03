extends Area2D
class_name Projectile

@export var rotation_speed: float = 1000
@export var projectile_speed: float = 200
@export var despawn_time: float = 5
@export var enemy_projectile: bool = false
@export var damage: int = 1
@onready var explosion_particle: CPUParticles2D = $Explosion

var has_hit: bool = false
var particle_played: bool = false
@onready var sprite: Sprite2D = $Sprite2D

var current_time: float = 0

func _ready() -> void:
	self.rotation_degrees = 0
	connect("body_entered", _on_body_entered)

func _process(delta: float) -> void:
	handle_hit()
	# Handle despawn time
	current_time = current_time + delta
	if current_time > despawn_time:
		queue_free()
	
	# Move the projectile forward
	if has_hit:
		return

	var new_pos: float = projectile_speed * delta
	var current_position: Vector2 = self.position
	
	if enemy_projectile:
		self.position = Vector2(current_position.x, current_position.y + new_pos)
	else:
		self.position = Vector2(current_position.x, current_position.y - new_pos)
	
	# Rotate the ball
	var current_rotation: float = self.rotation_degrees
	var delta_speed: float = rotation_speed * delta
	self.rotation_degrees = current_rotation + delta_speed

func handle_hit() -> void:
	if !has_hit:
		return

	sprite.apply_scale(Vector2())

	if !particle_played:
		explosion_particle.emitting = true
		particle_played = true
	
	if !explosion_particle.emitting:
		queue_free()

func _on_body_entered(body: Node) -> void:
	if body is Entity && !has_hit:
		body.take_damage(damage)
		has_hit = true
