extends CharacterBody2D

const MAX_SPEED: int = 75


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


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
