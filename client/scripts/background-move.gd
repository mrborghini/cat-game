extends Sprite2D
class_name BackgroundMove

@export var scroll_speed: float = 1

func _process(delta: float) -> void:
    var next_pos: float = scroll_speed * delta
    var current_pos: Vector2 = self.position
    self.position = Vector2(current_pos.x, current_pos.y + next_pos)