extends Node


signal resource_changed


var resource: int = 0: set = set_resource, get = get_resource
var base_unit_cost: int = 50


func set_resource(new_resource):
	resource = new_resource
	emit_signal('resource_changed')


func get_resource():
	return resource


func consume_resource(resource_amount: int) -> bool:
	if resource_amount <= resource:
		set_resource(resource - resource_amount)
		return true
	return false


func purchase_base_unit(amount: int = 1) -> bool:
	var has_enough_resource = consume_resource(base_unit_cost * amount)
	return has_enough_resource


func base_unit_consumed():
	set_resource(resource + base_unit_cost * 4)

