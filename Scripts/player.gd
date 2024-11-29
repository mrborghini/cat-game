extends Entity
class_name Player

func _ready() -> void:
	if !projectile_scene:
		push_error("No projectile has been set")
		assert(false, "No projectile has been set")

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

func _process(delta: float) -> void:
	handle_controls()
	handle_movement()
	handle_shoot_delay(delta)
	handle_health()
