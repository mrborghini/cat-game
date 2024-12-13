extends Entity
class_name Player

@export var heart_sprite: PackedScene
@export var heart_pos: Vector2 = Vector2(-20, 20)
@export var heart_margin: float = 5

var hearts: Array[AnimatedSprite2D] = []
var hearts_setup: bool = false
var heart_index: int = 0
var last_health: int

func setup_hearts() -> void:
	if hearts_setup:
		return

	for i in range(0, self.health):
		var heart: Node = heart_sprite.instantiate()
		hearts.push_back(heart)
		heart.position = heart_pos
		if i != 0:
			heart.position.x = hearts[i - 1].position.x + heart_margin
		heart.z_index = -1
		get_parent().add_child(heart)
	
	hearts_setup = true
	heart_index = len(hearts) - 1

func _ready() -> void:
	if !projectile_scene:
		push_error("No projectile has been set")
		assert(false, "No projectile has been set")
	self.score_on_death = 0
	self.last_health = self.health

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
	if last_health == self.health:
		return
		
	print("Took damage")
	if heart_index <= 0:
		PlayerScores.game_over = true
		queue_free()

	last_health = self.health
	hearts[heart_index].play("damage")
	heart_index -= 1

func _process(delta: float) -> void:
	setup_hearts()
	handle_controls()
	handle_movement()
	handle_shoot_delay(delta)
	handle_health()
