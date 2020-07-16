tool
extends Node

class_name Happy_Story_Teller

export(Resource) var director = Happy_Director.new()
var last_director = Happy_Director.new()
var storys : Dictionary
var editor
var index : int
export var root = 0
var last_root = -1

func _ready():
	storys = director.storys
	index = root
	
func _process(delta):
	if Engine.editor_hint:
		if last_director != director:
			if editor:
				editor.set_current_teller(self)
				last_director = director
		if last_root != root:
			if editor:
				if root == -1:
					editor.node_root_label.text = "Root Not Found!!"
				else:
					editor.node_root_label.text = "Root : " + String(root)
					last_root = root
		
func next(var values : Array = [-1]) -> String:
	match storys[index].type:
		Happy_Story.TYPE.DIALOGUE:			
			return run_dialogue()
		Happy_Story.TYPE.BRANCH:
			return run_branch(values[0])
	return "EROOR: Unknown Type"

func next_with_index(var _index : int) -> String:
	index = _index
	return next()
	
func run_dialogue() -> String:
	var speaker = storys[index].speaker
	var text = storys[index].text
	var output = "id:" + String(index) + "  " + speaker + ":" + text
	index = storys[index].to_id
	return output
	
func run_branch(var value) -> String:
	var selected = storys[index].selection[value]
	storys[index].to_id = storys[index].branch[value]
	var output = "id:" + String(index) + "  " + selected + ":" + String(storys[index].to_id)
	index = storys[index].to_id
	return output
