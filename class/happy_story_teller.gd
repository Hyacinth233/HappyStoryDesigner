tool
extends Node

class_name Happy_Story_Teller

export(Resource) var director
export(bool) var PLAY setget on_PLAY_btn_pressed
export(bool) var NEXT setget on_NEXT_btn_pressed
export(Array) var VALUES
var last_director = Happy_Director.new()
var editor
var index
export var root = 0
var last_root = -1

func _ready():
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
					last_root = -2
				else:
					editor.node_root_label.text = "Root : " + String(root)
					last_root = root
					
func on_PLAY_btn_pressed(var btn):
	play()

func on_NEXT_btn_pressed(var btn):
	next(VALUES)

func play():
	if not director.storys.has(index):
		print_logs(index, "EROOR:Invalid get index!")
		return
	match director.storys[index].type:
		Happy_Story.TYPE.DIALOGUE:			
			return play_dialogue()
		Happy_Story.TYPE.BRANCH:
			return play_branch()
	print_logs(index, "EROOR:Unknown Type")
	return 
	
func play_with_index(var _index : int):
	index = _index
	return play()
	
func next(var values : Array = [-1]):
	match director.storys[index].type:
		Happy_Story.TYPE.DIALOGUE:			
			index = director.storys[index].to_id
		Happy_Story.TYPE.BRANCH:
			index = index[values[0]]
	return "EROOR: Unknown Type"
	
func play_dialogue() -> Happy_Dialogue:
	var speaker = director.storys[index].speaker
	var text = director.storys[index].text
	print_logs(index, speaker + ":" + text)
	return director.storys[index]
	
func play_branch() -> Happy_Branch:
	var selection = director.storys[index].selection
	print_logs(index, selection)
	index = director.storys[index].branch
	return director.storys[index]
	
func print_logs(var id, var text):
	print("Happy Story Designer Log:")
	print("Load Dialogue:  ID:" + String(index) + "  " + text)
	pass
