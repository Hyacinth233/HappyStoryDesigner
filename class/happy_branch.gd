tool
extends Happy_Story
class_name Happy_Branch

export(Dictionary) var selections : Dictionary
#branch = {index : to_id}
export(Dictionary) var branches : Dictionary

func clone() -> Happy_Branch:
	var new = get_script().new()
	new.selections = selections.duplicate(true)
	new.branches = branches.duplicate(true)
	new.last_node = []
	new.tag = tag
	return new

