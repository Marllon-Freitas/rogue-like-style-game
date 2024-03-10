extends Node

@export var max_range_float: float = 150
@export var sword_ability_scene: PackedScene

var base_damage: int = 5
var additional_damage_percent: float = 1
var base_wait_time


# Called when the node enters the scene tree for the first time.
func _ready():
	base_wait_time = $Timer.wait_time
	$Timer.timeout.connect(on_Timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


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

	var sword_instance = sword_ability_scene.instantiate() as SwordAbility
	var foreground = get_tree().get_first_node_in_group("foreground_layer")
	foreground.add_child(sword_instance)
	sword_instance.hit_box_component.damage = base_damage * additional_damage_percent

	sword_instance.global_position = enemies[0].global_position
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(-PI / 4, PI / 4)) * 10

	var enemy_direction: Vector2 = enemies[0].global_position - sword_instance.global_position
	sword_instance.rotation = enemy_direction.angle()


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "sword_rate":
		var percent_reduction = current_upgrades["sword_rate"]["quantity"] * 0.2
		$Timer.wait_time = base_wait_time * (1 - percent_reduction)
		$Timer.start()
	elif upgrade.id == "sword_damage":
		additional_damage_percent = 1 + (current_upgrades["sword_damage"]["quantity"] * 0.15)
