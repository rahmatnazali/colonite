extends GenericState
class_name BaseUnitConsume


@export var character: BaseUnit
@export var consume_range: Area2D


var target_unit: BaseUnit
var is_consuming: bool = false


func enter(payload = null):
	assert(character != null, 'ChaseState: Character is not provided (null)')
	assert(payload is BaseUnit, 'ChaseState: Provided state payload is not BaseUnit')

	target_unit = payload
	character.current_speed = character.speed_consuming
	
	if character.state_verbose_mode: 
		print(character.name, ': entering consume state with payload: ', payload)


func physics_update(_delta):
	
	# check if target_unit is still exist (not being queued free)
	if target_unit != null:
		# keep chasing the unit while consuming
		character.move_towards_position(target_unit.global_position)

		if is_consuming == true:
			# just pass if this unit is still on a consuming mode and continue the cycle
			pass
		else:
			# assuming that target_unit still exist and this unit hasn't successfully consume them,
			# keep checking if consume connects with the target_unit
			var is_consume_connects = target_unit.being_consumed()
			
			# if consume connects, then set as is_consuming and continue the consume cycle
			if is_consume_connects:
				is_consuming = true
			# if consume doesn't connect, we can assume that others have take it
			else :
				# so back to wandering
				transitioned.emit(self, 'wander')

	# assume that target_unit is being queued free already
	else:
		# if this unit is consuming them, then level up and set back the is_consuming
		if is_consuming == true:
			is_consuming = false
			character.level_up()
		
		# in the end just back to wandering
		transitioned.emit(self, 'wander')

