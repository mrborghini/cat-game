extends Entity
class_name Enemy

@export var movement_delay: float = 0.5
@export var min_speed: float = 10
@export var max_speed: float = 100
@export var left_movement_chance: float = 0.5
@export var spawn_animation_ms: float = 1000
@export var growth_scale: float = 1

var growth_time: float = 0

func _ready() -> void:
	self.scale = Vector2.ZERO
	movement_speed = randf_range(min_speed, max_speed)
	
func spawn_animation(delta: float) -> bool:
	var scale_x: int = ceil(self.scale.x * 10)
	var scale_y: int = ceil(self.scale.y * 10)
	var growth_scale_rounded: int = int(growth_scale * 10)

	if scale_x == growth_scale_rounded and scale_y == growth_scale_rounded:
		return false
		
	growth_time += delta
	
	if growth_time < spawn_animation_ms / 1000:
		return true
	
	self.scale.x += 0.1
	self.scale.y += 0.1
	growth_time = 0
		
	return true

func _process(delta: float) -> void:
	handle_health()
	
	if spawn_animation(delta):
		return

	handle_movement()
	shoot(true)
	handle_shoot_delay(delta)
	current_time += delta

	if current_time < movement_delay:
		return

	if left_movement_chance == 0:
		return

	var left: bool = randf_range(0.1, 1.0) < left_movement_chance

	if left:
		self.move_direction = MOVE_SET.LEFT
	else:
		self.move_direction = MOVE_SET.RIGHT

	current_time = 0
