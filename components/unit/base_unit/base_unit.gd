extends CharacterBody2D
class_name BaseUnit


@export var should_move: bool = true
@export var should_stop_on_collide: bool = false

@export var team: int = 1
@export var is_alive: bool = true
@export var health: int = 10

@export var direction: Vector2 = Vector2.RIGHT
var current_speed: int
@export var speed_normal: int = 50
@export var speed_chase: int = 500
@export var speed_attacking: int = 0
@export var speed_consuming: int = 5

@export var starting_position: Vector2 = Vector2.ZERO

@export var eye_color = Color.BLACK
@export var body_color = Color.WHITE
@export var barrier_color = Color.GRAY


@export var health_component: Node
@export var attack_component: Node


@export var verbose_mode: bool = false
@export var state_verbose_mode: bool = false
@export var debug_health: bool = false


var is_being_consumed: bool = false


func start_moving():
	should_move = true


func stop_moving():
	should_move = false


func enable_state():
	$GenericStateMachine.enabled = true


func disable_state():
	$GenericStateMachine.enabled = false


func initialize_color():
	$Eye.modulate = eye_color
	$Body.modulate = body_color
	$Barrier.modulate = barrier_color


func initialize_starting_position():
	if starting_position != Vector2.ZERO:
		self.global_position = starting_position


# Given a normalized direction, BaseUnit will look at it and move towards it with assigned speed
# Majority of the usecase should prefer move_towards_position below
func move_towards_direction(move_direction: Vector2):
	if should_move:
		var normalized_move_direction = move_direction.normalized()
		direction = normalized_move_direction
		look_at(global_position + normalized_move_direction)
		set_velocity(direction * current_speed)
		move_and_slide()


# Given a global position target, BaseUnit will look at it and move towards it with assigned speed
func move_towards_position(target_position: Vector2):
	if should_move:
		var normalized_move_direction = (target_position - global_position).normalized()
		direction = normalized_move_direction
		look_at(global_position + normalized_move_direction)
		set_velocity(direction * current_speed)
		move_and_slide()


func _ready():
	initialize_color()
	initialize_starting_position()
	current_speed = speed_normal


func _physics_process(_delta):
	pass


# == Level & Stats Modifier ==


func level_up():
	var new_scale = scale * Vector2(1.5, 1.5)
	
	# check for upper bound scale to avoid out of frame sizing
	# max scale should be around 10-20
	if new_scale.x >= 15:
		new_scale = Vector2(15, 15)
	
	var new_max_health = health_component.max_health + 2
	var new_damage = attack_component.get_damage() + 2
	
	var level_up_tween = create_tween()
	level_up_tween.tween_property(self, 'scale', new_scale, 0.3)
	GlobalAudioPlayer.play_power_up_sound()
	
	health_component.set_max_health(new_max_health)
	health_component.set_current_health(health_component.max_health)
	attack_component.set_damage(new_damage)


# == Health Change ==


func _on_health_component_health_depleted():
	# handle die
	if verbose_mode: print(name, ' is dead')
	is_alive = false
	disable_state()
	stop_moving()
	play_die_animation()


func play_die_animation():
	$Barrier.visible = false
	var dead_scale = scale * 0.9
	var die_tweener = create_tween()
	die_tweener.set_parallel(true)
	die_tweener.tween_property($Body, 'modulate', Color.GRAY, 0.1)
	die_tweener.tween_property($Eye, 'modulate', Color.DARK_GRAY, 0.1)
	die_tweener.tween_property(self, 'scale', dead_scale, 0.1)
	GlobalAudioPlayer.play_dead_sound()


func _on_health_component_taking_damage():
	play_taking_damage_animation()


func play_taking_damage_animation():
	var taking_damage_tween = create_tween()
	taking_damage_tween.tween_property($Body, 'modulate', Color.RED, 0.05)
	taking_damage_tween.tween_property($Body, 'modulate', body_color, 0.05)


# == Consuming & Being Consumed ==

func consuming():
	level_up()


func being_consumed(consume_time: int = 5):
	if is_being_consumed == false:
		is_being_consumed = true
		var being_consumed_tween = create_tween()
		being_consumed_tween.tween_property(self, 'scale', Vector2(0.3, 0.3), consume_time)
		being_consumed_tween.tween_callback(queue_free)
		return true
	else:
		return false


# === Utils ===


# Get a Vector2() direction from current radian rotation of the head
func get_direction_from_rotation() -> Vector2:
	return Vector2(cos(rotation), sin(rotation)).normalized()

