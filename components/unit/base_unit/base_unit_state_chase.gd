extends GenericState
class_name BaseUnitChase


@export var character: BaseUnit


var target_unit: BaseUnit


func enter(payload = null):
	assert(character != null, 'ChaseState: Character is not provided (null)')
	assert(payload is BaseUnit, 'ChaseState: Provided state payload is not BaseUnit')

	target_unit = payload
	character.current_speed = character.speed_chase

	if character.state_verbose_mode: 
		print(character.name, ': entering chase state with payload: ', payload)


func physics_update(_delta):
	if target_unit.is_alive:
		# move towards target_unit
		var direction_to_enemy = (target_unit.global_position - character.global_position).normalized()
		character.move_towards_direction(direction_to_enemy)
	else:
		# back to wandering
		transitioned.emit(self, 'wander')
