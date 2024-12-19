extends RichTextLabel
class_name StatsLabel

func _process(_delta: float) -> void:
	var score_string: String = "Score: %d\n" % PlayerScores.score
	self.text = score_string + PlayerScores.get_time_string()
