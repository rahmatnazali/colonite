extends GenericState
class_name BaseUnitChase


@export var character: BaseUnit
@export var attack_range: Area2D


var target_unit: BaseUnit


func enter(payload = null):
	assert(character != null, 'ChaseState: Character is not provided (null)')
	assert(payload is BaseUnit, 'ChaseState: Provided state payload is not BaseUnit')
	assert(attack_range is Area2D, 'ChaseState: Provided attack_range is not Area2D')

	target_unit = payload
	character.current_speed = character.speed_chase

	if character.state_verbose_mode: 
		print(character.name, ': entering chase state with payload: ', payload)


func physics_update(_delta):
	if target_unit.is_alive:
		# move towards target_unit
		var direction_to_enemy = (target_unit.global_position - character.global_position).normalized()
		character.move_towards_direction(direction_to_enemy)
		
		# if target_unit is within the attack range, transition to attack state
		if target_unit in attack_range.get_overlapping_bodies():
			transitioned.emit(self, 'attack', target_unit)
		
	else:
		# back to wandering
		transitioned.emit(self, 'wander')
