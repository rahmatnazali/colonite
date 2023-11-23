extends CharacterBody2D
class_name BaseUnit


@export var debug_mode: bool = false


@export var should_move: bool = true
@export var should_stop_on_collide: bool = false

@export var team: int = 1
@export var health: int = 10


@export var SPEED: int = 50
@export var SPEED_CHASE: int = 500
@export var DIRECTION: Vector2 = Vector2.RIGHT
@export var EYE_COLOR = Color.BLACK
@export var BODY_COLOR = Color.WHITE
@export var BARRIER_COLOR = Color.GRAY


func start_moving():
	should_move = true


func stop_moving():
	should_move = false


func enable_state():
	$GenericStateMachine.enabled = true


func disable_state():
	$GenericStateMachine.enabled = false


func die():
	var tweener = create_tween()
	tweener.set_parallel(true)
	tweener.tween_property(self, 'modulate', Color.GRAY, 0.5)
	tweener.tween_property(self, 'scale', Vector2(0.8, 0.8), 0.1)
	disable_state()
	stop_moving()
	$Eye.visible = false


# Get a Vector2() direction from current rotation of the head
func get_direction_from_rotation() -> Vector2:
	var direction = Vector2(cos(rotation), sin(rotation))
	return direction


func initialize_color():
	$Eye.modulate = EYE_COLOR
	$Body.modulate = BODY_COLOR
	$Barrier.modulate = BARRIER_COLOR


func calculate_movement_parameter():
	DIRECTION = get_direction_from_rotation()
	set_velocity(DIRECTION * SPEED)


func handle_movement():
	if should_move:
		calculate_movement_parameter()
		var is_collided = move_and_slide()
		if should_stop_on_collide and is_collided:
			stop_moving()


func _ready():
	initialize_color()
	calculate_movement_parameter()


func _physics_process(_delta):
	handle_movement()


func _on_health_component_max_health_changed(max_health):
	pass


func _on_health_component_health_changed(health):
	pass


func _on_health_component_health_depleted():
	# handle die
	if verbose_mode: print(name, ' is dead')
	disable_state()
	stop_moving()
	play_die_animation()
