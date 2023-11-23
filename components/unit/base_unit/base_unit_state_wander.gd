extends GenericState
class_name BaseUnitWander


@export var character: BaseUnit


var target_rotation: int
var wander_time: float


func randomize_variables():
	target_rotation = randi_range(-180, 180)
	wander_time = randf_range(0.3, 2)


func enter():
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
		character.rotation = target_rotation

