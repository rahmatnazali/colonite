extends Node
class_name GenericState


signal transitioned(source_state: GenericState, new_state: StringName)


# Execute some logic when the machine enters the state
# (initialize variables, trigger one-time actions, update current animation)
func enter():
	pass


# Execute some logic when the machine exists the state
# (clean up resources, reset variables, remove nodes)
func exit():
	pass


# Execute some logic at every frame (equivalent to _process)
func update(delta):
	pass


#  Execute some logic at fixed intervals (equivalent to _physics_process)
func physics_update(delta):
	pass
