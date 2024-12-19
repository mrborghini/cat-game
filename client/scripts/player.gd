extends Entity
class_name Player

@export var heart_sprite: PackedScene
@export var heart_pos: Vector2 = Vector2(-20, 20)
@export var heart_margin: float = 5

var hearts: Array[AnimatedSprite2D] = []
var hearts_setup: bool = false
var heart_index: int = 0
var last_health: int
var starting_health: int
var starting_pos: Vector2

@onready var camera: CameraZoom = $"../PlayerCamera"

func handle_heart_postion() -> void:
	for i in range(hearts.size()):
		calculate_heart_position(hearts[i], i)

func calculate_heart_position(heart: AnimatedSprite2D, index: int) -> void:
	if index != 0:
		heart.position.x = hearts[index - 1].position.x + heart_margin

func setup_hearts() -> void:
	if hearts_setup:
		return

	for i in range(0, self.health):
		var heart: AnimatedSprite2D = heart_sprite.instantiate()
		hearts.push_back(heart)
		heart.position = heart_pos
		calculate_heart_position(heart, i)
		heart.z_index = -1
		get_parent().add_child(heart)
	
	hearts_setup = true
	heart_index = len(hearts) - 1

func _ready() -> void:
	if !projectile_scene:
		push_error("No projectile has been set")
		assert(false, "No projectile has been set")
	self.score_on_death = 0
	self.starting_health = self.health
	self.last_health = self.health
	starting_pos = self.position

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
		
func handle_health() -> void:
	if last_health == self.health and self.health != 0:
		return
		
	if heart_index <= 0:
		PlayerScores.game_over = true
		
	if heart_index != -1:
		last_health = self.health
		hearts[heart_index].play("damage")
		heart_index -= 1

	if PlayerScores.game_over:
		reset()

func _process(delta: float) -> void:
	if PlayerScores.game_over:
		return

	setup_hearts()
	handle_heart_postion()
	handle_controls()
	handle_movement()
	handle_shoot_delay(delta)
	handle_health()


func reset()-> void:
	self.health = starting_health
	heart_index = starting_health - 1
	self.position = starting_pos
	self.move_direction = MOVE_SET.NONE
	last_health = starting_health
	for heart in hearts:
		heart.play("default")
