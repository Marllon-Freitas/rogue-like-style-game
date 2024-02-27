extends CharacterBody2D

const MAX_SPEED: int = 50

@onready var health_component: HealthComponent = $HealthComponent


# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.area_entered.connect(on_area_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var direction: Vector2 = get_directionToPlayer()
	velocity = direction * MAX_SPEED
	move_and_slide()


func get_directionToPlayer():
	var player_node: Node2D = get_tree().get_first_node_in_group("player")
	if player_node != null:
		return (player_node.global_position - global_position).normalized()
	else:
		return Vector2.ZERO


func on_area_entered(_area: Area2D):
	health_component.damage(100)
