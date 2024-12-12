extends RichTextLabel

class_name BlueScreenMessage

@export var letters_delay_ms: float = 1
var current_message: String
var i: int = 0
var current_time: float = 0

func _ready() -> void:
	current_message = self.text
	self.text = ""

func _process(delta: float) -> void:
	if not get_parent().visible:
		return

	current_time += delta
	if current_time < letters_delay_ms / 1000:
		return
		
	current_time = 0
	
	if len(current_message) - 1 == i:
		return
	
	self.text += current_message[i]
	i += 1
