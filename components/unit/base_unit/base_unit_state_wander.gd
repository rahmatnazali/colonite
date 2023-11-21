extends GenericState
class_name BaseUnitWander


@export var character: CharacterBody2D


var target_rotation: int
var wander_time: float


func randomize_variables():
	target_rotation = randi_range(-180, 180)
	wander_time = randf_range(0.3, 2)


func enter():
	randomize_variables()


func update(delta: float):
	if wander_time > 0:
		wander_time -= delta
	else:
		randomize_variables()


func physics_update(delta: float):
	if character != null:
		character.rotation = target_rotation
