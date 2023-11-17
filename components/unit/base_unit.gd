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


func initialize_color():
	$Eye.modulate = EYE_COLOR
	$Barrier.modulate = BARRIER_COLOR


func initialize_physic():
	set_velocity(DIRECTION * SPEED)


func handle_movement():
	if should_move:
		var is_collided = move_and_slide()
		if should_stop_on_collide and is_collided:
			stop_moving()


func _ready():
	initialize_color()
	initialize_physic()


func _process(_delta):
	handle_movement()
