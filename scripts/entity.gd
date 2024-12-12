extends CharacterBody2D
class_name Entity

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var projectile_scene: PackedScene
@export var move_direction: MOVE_SET = MOVE_SET.NONE
@export var movement_speed: float = 50
@export var horizontal_rotation_deg: float = 10
@export var health: int = 2
@export var shoot_delay_ms: float = 300
@export var shoot_animation_speed: float = 3
@export var projectile_damage: int = 1

var current_time: float = 0
var last_shot_time: float = 0

var shoot_blocked: bool = false

const ENUMS = preload("res://scripts/enums.gd")
const MOVE_SET = ENUMS.MOVE_SET

func take_damage(damage: int) -> void:
	health -= damage

func handle_health() -> void:
	if health <= 0:
		queue_free()

func handle_movement() -> void:
	match move_direction:
		MOVE_SET.LEFT:
			self.velocity.x = -movement_speed
			self.rotation_degrees = -horizontal_rotation_deg
		MOVE_SET.RIGHT:
			self.velocity.x = movement_speed
			self.rotation_degrees = horizontal_rotation_deg
		MOVE_SET.NONE:
			self.rotation_degrees = 0
			self.velocity = Vector2()
			
	move_and_slide()

func shoot(is_enemy: bool = false) -> void:
	if shoot_blocked:
		return

	shoot_blocked = true
	self.animated_sprite.play("attack", shoot_animation_speed)

	var projectile: Projectile = projectile_scene.instantiate()
	projectile.global_transform = self.global_transform
	if is_enemy:
		projectile.position.y += 10
	else:
		projectile.position.y -= 10
	
	projectile.enemy_projectile = is_enemy
	projectile.damage = projectile_damage
	get_parent().add_child(projectile)

func handle_shoot_delay(delta: float) -> void:
	if !shoot_blocked:
		return

	last_shot_time += delta

	if last_shot_time > shoot_delay_ms / 1000:
		shoot_blocked = false
		last_shot_time = 0
