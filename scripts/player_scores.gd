extends Node
class_name Scores

var score_time: float = 0
var score: int = 0
var game_over: bool = false

func get_time_string() -> String:
    var total_seconds: int = int(score_time)
    var player_score_minutes: int = floor(total_seconds / 60.0)
    var player_score_seconds: int = total_seconds % 60
    return "Time: %02d:%02d" % [player_score_minutes, player_score_seconds]
