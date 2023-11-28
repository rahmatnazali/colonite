extends Node


func get_color_from_team(team_number: int):
	if team_number == 1:
		return Color.DEEP_SKY_BLUE
	elif team_number == 2:
		return Color.ORANGE_RED
	elif team_number == 3:
		return Color.INDIAN_RED
	elif team_number == 4:
		return Color.GREEN_YELLOW
	elif team_number == 5:
		return Color.YELLOW
	else:
		return Color.WHITE


func get_distance_between_node(first: Node2D, second: Node2D) -> float:
	return first.global_position.distance_to(second.global_position)


func find_closest(source_node: Node2D, target_group: Array) -> Object:
	if target_group.size() == 0:
		return null
	
	var final_distance = get_distance_between_node(source_node, target_group[0])
	var final_node = target_group[0]
	
	for index in target_group.size():
		var current_node: Node2D = target_group[index]
		var current_distance = get_distance_between_node(source_node, current_node)
		
		if current_distance < final_distance:
			final_distance = current_distance
			final_node = current_node
	
	return final_node


# Get all other BaseUnit
func get_all_base_unit(source_node: Node2D):
	var source_parent = source_node.get_parent()
	var source_siblings = source_parent.get_children()
	
	var siblings: Array = []
	
	for child in source_siblings:
		if child is BaseUnit and child != source_node:
			siblings.push_back(child)
	
	return siblings


# Get all other BaseUnit that has different `team` variable than the supplied `source_node`
func get_other_units(source_node: Node2D, enemy_only: bool = false, alive_only: bool = false):
	var source_team = source_node.team
	var source_parent = source_node.get_parent()
	var source_siblings = source_parent.get_children()
	
	var siblings: Array = []
	
	for sibling in source_siblings:
		if sibling is BaseUnit and sibling != source_node:
			var is_considered = true

			if enemy_only and sibling.team == source_team: is_considered = false
			if alive_only and sibling.is_alive == false: is_considered = false
			
			if is_considered:
					siblings.push_back(sibling)
	
	return siblings

