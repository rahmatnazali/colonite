extends GenericState
class_name BaseUnitAttack


@export var character: BaseUnit
@export var attack_range: Area2D
@export var consume_range: Area2D


var target_unit: BaseUnit


func enter(payload = null):
	assert(character != null, 'ChaseState: Character is not provided (null)')
	assert(payload is BaseUnit, 'ChaseState: Provided state payload is not BaseUnit')
	assert(attack_range is Area2D, 'ChaseState: Provided attack_range is not Area2D')

	target_unit = payload
	character.current_speed = character.speed_attacking

	if character.state_verbose_mode: 
		print(character.name, ': entering attack state with payload: ', payload)


func physics_update(_delta):
	if target_unit.is_alive and target_unit in attack_range.get_overlapping_bodies():
		if character.attack_component.able_to_attack():
			var is_attack_succeed = character.attack_component.attack()
			if is_attack_succeed:
				target_unit.health_component.take_damage(character.attack_component.get_damage())
				GlobalAudioPlayer.play_attack_sound()
	elif target_unit.is_alive:
		# alive but not in range --> should keep chasing it
		transitioned.emit(self, 'chase', target_unit)
	elif target_unit.is_alive == false and target_unit in consume_range.get_overlapping_bodies():
		# attempt to consume
		transitioned.emit(self, 'consume', target_unit)
	else:
		# back to wandering
		transitioned.emit(self, 'wander')

