extends Node


@export var damage: int = 1: set = set_damage, get=get_damage
@export var attack_cooldown: int = 1


var is_attacking: bool = false
var is_able_to_attack: bool = true


func get_damage():
	return damage


func set_damage(new_damage):
	damage = max(0, new_damage)


func _ready():
	$AttackCooldown.wait_time = attack_cooldown
	$AttackCooldown.one_shot = true
	$AttackCooldown.autostart = false
	

func _process(_delta):
	pass


func able_to_attack() -> bool:
	return is_able_to_attack


func attack() -> bool:
	if is_able_to_attack and not is_attacking:
		is_attacking = true
		is_able_to_attack = false
		$AttackCooldown.start()
		return true
	else:
		return false


func _on_attack_cooldown_timeout():
	is_attacking = false
	is_able_to_attack = true

