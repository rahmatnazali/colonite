extends GenericState
class_name BaseUnitWander


@export var character: BaseUnit


var wander_time: float
var move_direction: Vector2


func randomize_variables():
	move_direction = Vector2(randf_range(-1 ,1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(0.3, 2)


func enter(_payload = null):
	assert(character != null, 'WanderState: Character is not provided (null)')

	if character.state_verbose_mode:
		print(character.name, ': entering wander')

	randomize_variables()


func update(delta: float):
	if wander_time > 0:
		wander_time -= delta
	else:
		# State: jump to scan enemy
		transitioned.emit(self, 'scan')


func physics_update(_delta: float):
	if character != null:
		if wander_time > 0:
			character.move_towards_direction(move_direction)

