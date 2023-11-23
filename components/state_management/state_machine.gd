extends Node
class_name GenericStateMachine


@export var enabled: bool = true
@export var initial_state: GenericState


var current_state: GenericState
var states: Dictionary = {}


func _ready():
	for child in get_children():
		if child is GenericState:
			states[child.name.to_lower()] = child
			child.transitioned.connect(on_child_transitioned)
		else:
			push_warning('StateMachine contains child which is not `State`: ', child)
	
	if initial_state != null:
		initial_state.enter()
		current_state = initial_state
	else:
		push_warning('The initial_state` variable is not assigned,')


func _process(delta):
	if enabled and current_state != null:
		current_state.update(delta)


func _physics_process(delta):
	if enabled and current_state != null:
		current_state.physics_update(delta)


func on_child_transitioned(source_state: GenericState, new_state_name: StringName, payload = null):
	# if current_state is not the intendend source_state, simply return
	if current_state != source_state:
		return

	# get the target_state by name from the `states` dictionary. Warn if no such state found.
	var new_state: GenericState = states.get(new_state_name.to_lower())
	if new_state == null:
		push_warning('Called transition to state "' + new_state_name + '" state that does not exist in the `states` dictionary.')
		return
	
	# if current_state exist, call exit() on that state
	if current_state != null:
		current_state.exit()
	
	# call enter() on the new_state
	if payload != null:
		new_state.enter(payload)
	else:
		new_state.enter()
	
	# set the new_state as the current_state
	current_state = new_state
