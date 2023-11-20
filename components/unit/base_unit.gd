extends CharacterBody2D


@export var should_move: bool = false
@export var should_stop_on_collide: bool = false


@export var SPEED: int = 500
@export var DIRECTION: Vector2 = Vector2.UP
@export var EYE_COLOR = Color.BLACK
@export var BARRIER_COLOR = Color.GRAY


func start_moving():
	should_move = true


func stop_moving():
	should_move = false


# Get a Vector2() direction from current rotation of the head
# The final calculation will then be rotated with -90 degree to correct the direction so it faces upwards
func get_direction_from_rotation() -> Vector2:
	var direction = Vector2(cos(rotation), sin(rotation)).rotated(-PI/2)
	return direction


func initialize_color():
	$Eye.modulate = EYE_COLOR
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
