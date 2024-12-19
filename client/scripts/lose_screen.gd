extends Control

func _process(_delta: float) -> void:
	self.visible = PlayerScores.game_over
