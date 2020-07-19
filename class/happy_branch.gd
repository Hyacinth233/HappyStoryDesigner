tool
extends Happy_Story
class_name Happy_Branch

export(Dictionary) var selections = {}
#branch = {index : to_id}
export(Dictionary) var branches = {}

func clone() -> Happy_Branch:
	var new = get_script().new()
	new.selections = selections.duplicate(true)
	new.branches = branches.duplicate(true)
	new.last_node = []
	return new

