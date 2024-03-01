extends Node

@export var max_range_float: float = 150

@export var sword_ability: PackedScene
var damage: int = 5


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.timeout.connect(on_Timer_timeout)


func on_Timer_timeout():
	var player: Node2D = get_tree().get_first_node_in_group("player")
	if player == null:
		return

	var enemies: Array = get_tree().get_nodes_in_group("enemy")
	enemies = enemies.filter(
		func(enemy: Node2D): return (
			enemy.global_position.distance_squared_to(player.global_position)
			< pow(max_range_float, 2)
		)
	)
	if enemies.size() == 0:
		return

	enemies.sort_custom(
		func(a: Node2D, b: Node2D): return (
			a.global_position.distance_squared_to(player.global_position)
			< b.global_position.distance_squared_to(player.global_position)
		)
	)

	var sword_instance = sword_ability.instantiate() as SwordAbility
	player.get_parent().add_child(sword_instance)
	sword_instance.hit_box_component.damage = damage

	sword_instance.global_position = enemies[0].global_position
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(-PI / 4, PI / 4)) * 10

	var enemy_direction: Vector2 = enemies[0].global_position - sword_instance.global_position
	sword_instance.rotation = enemy_direction.angle()
