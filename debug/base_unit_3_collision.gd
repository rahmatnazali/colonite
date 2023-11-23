extends Control


func _ready():
	$SmallEnemy1.disable_state()
	$SmallEnemy2.disable_state()
	$SmallEnemy3.disable_state()
	$SmallEnemy4.disable_state()
	
	$MiddleUnit1.disable_state()
	$MiddleUnit2.disable_state()
	$MiddleUnit3.disable_state()
	$MiddleUnit4.disable_state()


func _physics_process(delta):
	$SmallEnemy4.move_towards_direction(Vector2.UP)
	$MiddleUnit1.move_towards_direction(Vector2.DOWN)
	$MiddleUnit4.move_towards_direction(Vector2.UP)
	
