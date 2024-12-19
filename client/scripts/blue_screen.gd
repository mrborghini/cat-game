extends RichTextLabel
class_name BlueScreen

@export var letters_delay_ms: float = 1
@export var game_restart_delay_seconds: float = 5

var current_message: String
var original_message: String
var words: Array = []
var word_index: int = 0
var current_time: float = 0
var updated: bool = false
var restart_time: float = 0
var last_second: int = 0

func restart_game_after_delay(delta: float) -> void:
	restart_time += delta
	var remaining_time: int = ceil(game_restart_delay_seconds - restart_time)
	
	if last_second != remaining_time:
		self.text += "\n%d..." % remaining_time

	last_second = remaining_time

	if restart_time > game_restart_delay_seconds:
		restart_time = 0
		PlayerScores.reset()
	

func update_message() -> void:
	self.text = ""
	current_message = original_message.replace(":score:", str(PlayerScores.score))
	current_message = current_message.replace(":highscore:", str(PlayerScores.high_score))
	current_message = current_message.replace(":time:", str(PlayerScores.get_time_string().to_upper()))
	words = current_message.split(" ")

func _ready() -> void:
	original_message = self.text
	current_message = self.text
	self.text = ""

func _process(delta: float) -> void:
	if not PlayerScores.game_over:
		updated = false
		word_index = 0
		return

	if not updated:
		update_message()
		updated = true

	current_time += delta
	if current_time < letters_delay_ms / 1000:
		return
		
	current_time = 0
	
	if len(words) - 1 == word_index:
		restart_game_after_delay(delta)
		return
	
	self.text += words[word_index] + " "
	word_index += 1
