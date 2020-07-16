tool
extends Happy_Story
class_name Happy_Branch

export(Dictionary) var selection = {}
#branch = {index : to_id}
export(Dictionary) var branch = {}

func clone() -> Happy_Branch:
	var new = get_script().new()
	new.selection = selection.duplicate(true)
	new.branch = branch.duplicate(true)
	new.last_node = []
	return new

