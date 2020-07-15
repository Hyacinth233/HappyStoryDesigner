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
		
func next() -> String:
	var _name = storys[index].name
	var _text = storys[index].text
	var _output = "id:" + String(index) + "  " + _name + ":" + "_text"
	
	index = storys[index].next_id
	return _output
	
func next_with_index(var _index : int) -> String:
	index = _index
	return next()
