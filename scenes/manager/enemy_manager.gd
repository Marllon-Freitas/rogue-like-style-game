extends Node

const SPAWN_RADIUS = 360
const TERRAIN_LAYER_MASK = 1
const DIRECTIONS_TO_CHECK = 4

@export var basic_enemy_scene: PackedScene
@export var arena_time_manager: Node

@onready var timer = $Timer

var base_spawn_time = 0


func _ready():
	base_spawn_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)


func get_spawn_position():
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return Vector2.ZERO

	var spawn_position: Vector2 = Vector2.ZERO
	var random_direction: Vector2 = Vector2.RIGHT.rotated(randf_range(0, TAU))
	for i in DIRECTIONS_TO_CHECK:
		spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)

		var intersect_ray_query_parameters = PhysicsRayQueryParameters2D.create(
			player.global_position, spawn_position, TERRAIN_LAYER_MASK
		)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(
			intersect_ray_query_parameters
		)

		if result.is_empty():
			break
		else:
			random_direction = random_direction.rotated(deg_to_rad(90))

	return spawn_position


func on_timer_timeout():
	timer.start()
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return

	var enemy: Node2D = basic_enemy_scene.instantiate()
	var enitird_layer = get_tree().get_first_node_in_group("entities_layer")
	enitird_layer.add_child(enemy)
	enemy.global_position = get_spawn_position()


func on_arena_difficulty_increased(arena_difficulty: int):
	var time_off = (0.1 / 12) * arena_difficulty
	time_off = min(time_off, 0.7)
	timer.wait_time = base_spawn_time - time_off
