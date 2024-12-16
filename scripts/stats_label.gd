extends RichTextLabel

func _process(_delta: float) -> void:
	# Format the score and time strings
	var score_string: String = "Score: %d\n" % PlayerScores.score

	# Update the display
	self.text = score_string + PlayerScores.get_time_string()
