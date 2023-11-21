extends Control


func _ready():
	$BaseUnit.disable_state()
	$BaseUnit2.disable_state()
	$BaseUnit3.disable_state()
	$BaseUnit4.disable_state()
	
	$Node2D/BaseUnit.disable_state()
	$Node2D/Enemy.disable_state()
	$Node2D/Enemy2.disable_state()
	$Node2D/Enemy3.disable_state()
