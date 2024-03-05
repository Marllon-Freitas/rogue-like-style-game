extends CharacterBody2D

const MAX_SPEED = 150
const ACCELERATION_SMOOTHING = 25

@onready var damage_interval_timer = $DamageIntervalTimer

var number_colliding_body: int = 0


func _ready():
	$CollisionArea2D.body_entered.connect(on_body_entered)
	$CollisionArea2D.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout)


func _process(delta):
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	var taret_velocity = direction * MAX_SPEED
	velocity = velocity.lerp(taret_velocity, 1 - exp(-delta * ACCELERATION_SMOOTHING))
	move_and_slide()


func get_movement_vector():
	var x_movement = (
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	)
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement, y_movement).normalized()


func check_deal_damage():
	if number_colliding_body == 0 || !damage_interval_timer.is_stopped():
		return

	$HealthComponent.damage(1)
	damage_interval_timer.start()
	print($HealthComponent.current_health)


func on_damage_interval_timer_timeout():
	check_deal_damage()


func on_body_entered(other_body: Node2D):
	number_colliding_body += 1
	check_deal_damage()


func on_body_exited(other_body: Node2D):
	number_colliding_body -= 1
