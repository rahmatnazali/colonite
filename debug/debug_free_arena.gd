extends Control


@export var starting_resource: int = 500


@onready var resource_value_label: Label = %ResourceValue
@onready var unit_tree: Node2D = %Units


var base_unit_scene: PackedScene = preload('res://components/unit/base_unit/base_unit.tscn')


func initialize_resource():
	GlobalStatsManager.set_resource(starting_resource)


func update_stats_ui():
	resource_value_label.text = str(GlobalStatsManager.get_resource())


func spawn_base_unit(spawn_position: Vector2, spawn_team: int = 1, spawn_color: Color = Color.WHITE, spawn_size: int = 5):
	for i in range(spawn_size):
		var base_unit_instance = base_unit_scene.instantiate()
		base_unit_instance.starting_position = spawn_position
		base_unit_instance.team = spawn_team
		base_unit_instance.body_color = spawn_color
		
		unit_tree.add_child(base_unit_instance)


# handles mouse click and spawning
func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		var spawn_position = event.position
		var spawn_team = event.button_index
		var spawn_color = GlobalUtilities.get_color_from_team(spawn_team)
		spawn_base_unit(spawn_position, spawn_team, spawn_color)


func _ready():
	# disable resource in free arena
	#initialize_resource()
	#update_stats_ui()
	pass


func _process(_delta):
	pass

