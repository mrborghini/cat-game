extends RichTextLabel
class_name Fps

@export var show_fps: bool = true

func _ready() -> void:
	self.text = ""

func _process(_delta: float) -> void:
	if !show_fps:
		return

	self.text = "Fps: %d" % Engine.get_frames_per_second()
