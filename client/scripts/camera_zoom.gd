extends Camera2D
class_name CameraZoom

@export var base_resolution: Vector2 = Vector2(640, 480)
var base_zoom: Vector2

func _ready() -> void:
	base_zoom = self.zoom

func _process(_delta: float) -> void:
	var resolution: Vector2 = get_viewport().get_visible_rect().size
	var scale_factor: float = min(resolution.x / base_resolution.x, resolution.y / base_resolution.y)
	self.zoom = Vector2(scale_factor, scale_factor) * base_zoom
