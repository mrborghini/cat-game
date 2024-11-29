extends Entity
class_name Enemy

@export var movement_delay: float = 0.5
@export var min_speed: float = 10
@export var max_speed: float = 100

func _ready() -> void:
	movement_speed = randf_range(min_speed, max_speed)

func _process(delta: float) -> void:
	handle_health()
	handle_movement()
	shoot(true)
	handle_shoot_delay(delta)
	current_time += delta

	if current_time < movement_delay:
		return

	var left: bool = randi_range(0, 1) == 1

	if left:
		self.move_direction = MOVE_SET.LEFT
	else:
		self.move_direction = MOVE_SET.RIGHT

	current_time = 0
