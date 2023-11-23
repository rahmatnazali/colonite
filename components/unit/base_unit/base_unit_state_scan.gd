extends GenericState
class_name BaseUnitScan


@export var character: BaseUnit


# todo: should be better to add scan area here rather than scanning the whole scene


func enter(_payload = null):
	assert(character != null, 'ScanState: Character is not provided (null)')
	if character.state_verbose_mode: print(character.name, ': entering scan')


func update(_delta: float):
	var found_alive_enemies: Array = GlobalUtilities.get_other_units(character, true, true)

	if found_alive_enemies.size() != 0:
		var closest_enemy: BaseUnit = GlobalUtilities.find_closest(character, found_alive_enemies)
		if character.state_verbose_mode: 
			print(character.name, ': found closest enemy ', closest_enemy.name, ' ', closest_enemy.global_position)
		
		# Transmit to "Chase" state and pass closest_enemy with it
		transitioned.emit(self, 'chase', closest_enemy)
		
		# IMPORTANT: to avoid fallback
		return
	
	# fallback to wandering
	transitioned.emit(self, 'wander')
