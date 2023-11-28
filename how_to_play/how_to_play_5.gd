extends Control


@export var starting_resource: int = 500


@onready var resource_value_label: Label = %ResourceValue
@onready var unit_tree: Node2D = %Worlds


var base_unit_scene: PackedScene = preload('res://components/unit/base_unit/base_unit.tscn')


func initialize_resource():
	GlobalStatsManager.set_resource(starting_resource)
	GlobalStatsManager.resource_changed.connect(update_stats_ui)


func update_stats_ui():
	var current_resource = GlobalStatsManager.get_resource()
	resource_value_label.text = str(current_resource)
	
	# set resource color according to the resource level
	if current_resource == 0:
		resource_value_label.add_theme_color_override("font_color", Color(1, 0, 0))
	elif  current_resource <= 100:
		resource_value_label.add_theme_color_override("font_color", Color.ORANGE)
	else:
		resource_value_label.remove_theme_color_override("font_color")


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
		var spawn_team = 1
		var spawn_position = event.position
		var spawn_color = GlobalUtilities.get_color_from_team(spawn_team)
		
		if event.button_index == 1:
			# spawn 1
			var has_enough_resource = GlobalStatsManager.purchase_base_unit()
			if has_enough_resource:
				spawn_base_unit(spawn_position, spawn_team, spawn_color, 1)
		elif  event.button_index == 2:
			# spawn 5
			var has_enough_resource = GlobalStatsManager.purchase_base_unit(5)
			if has_enough_resource:
				spawn_base_unit(spawn_position, spawn_team, spawn_color, 5)


func _ready():
	initialize_resource()
	update_stats_ui()


func _process(_delta):
	pass

