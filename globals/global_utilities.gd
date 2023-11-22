extends Node


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
func get_outsider_base_unit(source_node: Node2D):
	var source_team = source_node.team
	var source_parent = source_node.get_parent()
	var source_siblings = source_parent.get_children()
	
	var siblings: Array = []
	
	for child in source_siblings:
		if child is BaseUnit and child != source_node and child.team != source_team:
			siblings.push_back(child)
	
	return siblings
