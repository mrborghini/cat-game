extends CharacterBody2D

enum MOVE_SET {
	LEFT,
	RIGHT,
	UP,
	DOWN,
	NONE,
}

@export var movement_speed: float = 50
@export var move_direction: MOVE_SET = MOVE_SET.NONE
@export var horizontal_rotation_deg: float = 10
@export var shoot_delay: float = 0.3
@export var projectile_scene: PackedScene
@export var shoot_animation_speed: float = 2

var shoot_blocked: bool = false
var current_time: float = 0
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	if !projectile_scene:
		push_error("No projectile has been set")
		assert(false, "No projectile has been set")
	
func shoot() -> void:
	if shoot_blocked:
		return

	shoot_blocked = true
	animated_sprite.play("attack", shoot_animation_speed)

	var projectile: Area2D = projectile_scene.instantiate()
	projectile.global_transform = global_transform
	get_parent().add_child(projectile)

func handle_shoot_delay(delta: float) -> void:
	if !shoot_blocked:
		return
	
	current_time = current_time + delta

	if current_time > shoot_delay:
		shoot_blocked = false
		current_time = 0

func handle_controls() -> void:
	if Input.is_action_pressed("left"):
		if Input.is_action_pressed("right"):
			return
		self.move_direction = MOVE_SET.LEFT
	elif Input.is_action_pressed("right"):
		if Input.is_action_pressed("left"):
			return
		self.move_direction = MOVE_SET.RIGHT
	elif Input.is_action_just_released("left") or Input.is_action_just_released("right"):
		self.move_direction = MOVE_SET.NONE
	
	if Input.is_action_just_pressed("shoot"):
		shoot()

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

func _process(delta: float) -> void:
	handle_controls()
	handle_movement()
	handle_shoot_delay(delta)
