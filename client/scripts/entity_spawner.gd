extends Node2D
class_name EntitySpawner

@export var entities: Array[PackedScene]
@export var spawn_chance: float = 0.5
@export var spawn_rate: float = 2
@export var box_pos: Vector2 = Vector2(-125, -90)
@export var box_scale: Vector2 = Vector2(250, 100)
@export var color: Color = Color(1, 0, 0, 0.5)
@export var show_box: bool = false
@export var higher_boss_chance_time_seconds: int = 30
@export var boss_chance_after_time_seconds: float = 0.4
@export var even_higher_boss_chance_time_seconds: int = 120
@export var boss_chance_after_2nd_time_seconds: float = 0.6

func _draw() -> void:
	if show_box:
		draw_rect(Rect2(box_pos, box_scale), color)

var current_time: float = 0

func get_position_in_box() -> Vector2:
	return Vector2(
		randf_range(box_pos.x, box_pos.x + box_scale.x),
		randf_range(box_pos.y, box_pos.y + box_scale.y)
	)

func spawn_enemy(enemy_node: Enemy) -> void:
	if int(PlayerScores.score_time) % higher_boss_chance_time_seconds == 0:
		enemy_node.become_boss_chance = boss_chance_after_time_seconds
	
	if int(PlayerScores.score_time) % even_higher_boss_chance_time_seconds == 0:
		enemy_node.become_boss_chance = boss_chance_after_2nd_time_seconds

	var enemy_position: Vector2 = get_position_in_box()

	enemy_node.global_position = global_position + enemy_position
	get_parent().add_child(enemy_node)

func _process(delta: float) -> void:
	if PlayerScores.game_over:
		current_time = 0
		return

	current_time += delta
	
	if current_time <= spawn_rate:
		return
		
	current_time = 0
	
	# Spawn enemies
	for entity in entities:
		var rng: float = randf()
		if rng > spawn_chance:
			continue
		var entity_node: Node = entity.instantiate()
		if entity_node is Enemy:
			spawn_enemy(entity_node as Enemy)
		else:
			entity_node.global_position = global_position + get_position_in_box()
			get_parent().add_child(entity_node)
