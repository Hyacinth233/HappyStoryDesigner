tool
extends Happy_Story
class_name Happy_Assign

export(bool) var is_global
export(String) var variable
export(float) var new_value

func clone() -> Happy_Dialogue:
	var new = get_script().new()
	new.to_id = -1
	new.last_nodes = []
	new.last_slots = {}
	new.tag = tag
	new.is_global = is_global
	new.variable = variable
	new.new_value = new_value
	return new
