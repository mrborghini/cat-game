extends Node2D
class_name EnemySpawner

@export var enemies: Array[PackedScene]
@export var spawn_chance: float = 0.1
@export var spawn_rate: float = 2
@export var box_pos: Vector2 = Vector2(100, 100)
@export var box_scale: Vector2 = Vector2(100, 100)
@export var color: Color = Color(1, 0, 0, 0.5)
@export var show_box: bool = false
@export var higher_boss_chance_time_seconds: int = 30
@export var boss_chance_after_time_seconds: float = 0.5

func _draw() -> void:
	if show_box:
		draw_rect(Rect2(box_pos, box_scale), color)

var current_time: float = 0

func _process(delta: float) -> void:
	if PlayerScores.game_over:
		current_time = 0
		return

	current_time += delta
	
	if current_time <= spawn_rate:
		return
		
	current_time = 0
	
	var rng: float = randf()
	if rng > spawn_chance:
		return
	
	# Spawn enemies
	for enemy in enemies:
		var enemy_node: Enemy = enemy.instantiate()

		if int(PlayerScores.score_time) % higher_boss_chance_time_seconds == 0:
			enemy_node.become_boss_chance = boss_chance_after_time_seconds

		var enemy_position: Vector2 = Vector2(
			randf_range(box_pos.x, box_pos.x + box_scale.x),
			randf_range(box_pos.y, box_pos.y + box_scale.y)
		)

		enemy_node.global_position = global_position + enemy_position
		get_parent().add_child(enemy_node)
