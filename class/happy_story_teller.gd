extends Node

export(Resource) var director = Happy_Director.new()
var storys : Dictionary
var index : int

func _ready():
	storys = director.storys
	index = 0
	
func next() -> String:
	var _name = storys[index].name
	var _text = storys[index].text
	var _output = "id:" + String(index) + "  " + _name + ":" + "_text"
	
	index = storys[index].next_id
	return _output
	
func next_with_index(var _index : int) -> String:
	index = _index
	return next()
