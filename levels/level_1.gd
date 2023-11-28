extends Control


@export var starting_resource: int = 3000


@onready var resource_value_label: Label = %ResourceValue
@onready var unit_tree: Node2D = %Worlds/Units


var base_unit_scene: PackedScene = preload('res://components/unit/base_unit/base_unit.tscn')
var should_assess_win_condition: bool = false


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


func _ready():
	initialize_resource()
	update_stats_ui()
	initialize_enemy()


func initialize_enemy():
	for i in range(40):
		var base_unit_instance = base_unit_scene.instantiate()
		base_unit_instance.starting_position = %SpawnMarker1.global_position
		base_unit_instance.team = 2
		base_unit_instance.body_color = Color('f77975')
		%Units.add_child(base_unit_instance)

	for i in range(40):
		var base_unit_instance = base_unit_scene.instantiate()
		base_unit_instance.starting_position = %SpawnMarker2.global_position
		base_unit_instance.team = 2
		base_unit_instance.body_color = Color('cc6dff')
		%Units.add_child(base_unit_instance)



func spawn_base_unit(spawn_position: Vector2, spawn_team: int = 1, spawn_color: Color = Color.WHITE, spawn_size: int = 5):
	for i in range(spawn_size):
		var base_unit_instance = base_unit_scene.instantiate()
		base_unit_instance.starting_position = spawn_position
		base_unit_instance.team = spawn_team
		base_unit_instance.body_color = spawn_color
		
		unit_tree.add_child(base_unit_instance)
	
	if should_assess_win_condition == false:
		should_assess_win_condition = true


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


func assess_win_condition():
	var all_childrens = %Worlds/Units.get_children()

	var enemy_count: int = 0
	var ally_count: int = 0
	for c in all_childrens:
		if c.team == 1:
			ally_count += 1
		else:
			enemy_count += 1
	
	if enemy_count == 0:
		get_tree().change_scene_to_file("res://levels/win_scene.tscn")
	elif GlobalStatsManager.get_resource() == 0 and enemy_count != 0 and ally_count == 0:
		get_tree().change_scene_to_file("res://levels/lose_scene.tscn")


func _physics_process(_delta):
	if should_assess_win_condition:
		assess_win_condition()

