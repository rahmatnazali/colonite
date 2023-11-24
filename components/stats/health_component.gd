extends Node


signal max_health_changed(max_health: int)
signal health_changed(health: int)
signal taking_damage
signal health_depleted


@export var max_health: int: set = set_max_health
@export var current_health: int: set = set_current_health


var debug_health: bool = false


func set_max_health(new_max_health):
	assert(new_max_health != null, 'Parent does not have `health` attribute')
	
	new_max_health = max(0, new_max_health)
	emit_signal('max_health_changed', new_max_health)
	max_health = new_max_health


func set_current_health(new_health):
	if new_health == current_health:
		# no changes needs to be made, and no signals needs to be emmited
		return
	
	# bound the current_health to be 0 <= current_health <= max_health
	current_health = min(new_health, max_health)
	current_health = max(current_health, 0)
	
	if debug_health: print('current_health updated to: ', current_health)
	
	if current_health == 0:
		if debug_health: print('emmiting: health_depleted')
		emit_signal('health_depleted')
	else:
		emit_signal('health_changed', current_health)
	
	return current_health


func _ready():
	var parent: BaseUnit = get_parent()
	debug_health = parent.debug_health
	
	set_max_health(parent.health)
	set_current_health(max_health)
	
	if debug_health:
		print('Instantiating HealthComponent for parent ', parent.name, ' in debug mode. Will be dead in couple of seconds.')
		delayed_dead()


func take_damage(damage: int = 1):
	set_current_health(current_health - damage)
	emit_signal('taking_damage')


# === Debug ===


func delayed_dead():
	var delayed_dead_tween = create_tween()
	delayed_dead_tween.tween_property(self, 'current_health', 0, 3)

