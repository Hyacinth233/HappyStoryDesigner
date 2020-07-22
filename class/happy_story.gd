tool
class_name Happy_Story

enum TYPE{
	DIALOGUE = 0,
	BRANCH = 1,
}

export(TYPE) var type = TYPE.DIALOGUE
export(int) var id = 0 
export(int) var to_id = -1
export(Array) var last_nodes : Array
export(Dictionary) var last_slots : Dictionary  # node_id : slot
