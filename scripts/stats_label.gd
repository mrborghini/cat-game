extends RichTextLabel

func _process(delta: float) -> void:
	PlayerScores.score_time += delta
	
	# Format the score and time strings
	var score_string: String = "Score: %d\n" % PlayerScores.score

	# Update the display
	self.text = score_string + PlayerScores.get_time_string()
