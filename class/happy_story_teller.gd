tool
extends Node

class_name Happy_Story_Teller

export(Resource) var director
export(bool) var RETURN_TO_ROOT setget on_RETURN_TO_ROOT_btn_pressed
export(bool) var PLAY setget on_PLAY_btn_pressed
export(bool) var NEXT setget on_NEXT_btn_pressed
export(Array) var VALUES = [-1] 
var last_director = Happy_Director.new()
var editor
var index = 0
var indexs : Dictionary
export var root = 0
var last_root = -1

func _ready():
	index = root
	if Engine.editor_hint:
		if root != -1:
			editor.graph_nodes[root].overlay = GraphNode.OVERLAY_BREAKPOINT
	
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
					if last_root != -1:
						editor.graph_nodes[last_root].overlay = GraphNode.OVERLAY_DISABLED
					editor.graph_nodes[root].overlay = GraphNode.OVERLAY_BREAKPOINT
					last_root = root
					
func on_PLAY_btn_pressed(var btn):
	play()

func on_NEXT_btn_pressed(var btn):
	next(VALUES)
	
func on_RETURN_TO_ROOT_btn_pressed(var btn):
	index = root

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
	
func next(var values : Array):
	match director.storys[index].type:
		Happy_Story.TYPE.DIALOGUE:			
			index = director.storys[index].to_id
		Happy_Story.TYPE.BRANCH:
			if !indexs.keys().has(values[0]):
				return "ERROR: Can't Find Branch With Index " + String(values[0]) 
			index = indexs[values[0]]
	return "ERROR: Unknown Type"
	
func play_dialogue() -> Happy_Dialogue:
	var speaker = director.storys[index].speaker
	var text = director.storys[index].text
	print_logs(index, speaker + ":" + text)
	return director.storys[index]
	
func play_branch() -> Happy_Branch:
	var selections = director.storys[index].selections
	print_logs(index, String(selections))
	indexs = director.storys[index].branches
	return director.storys[index]
	
func print_logs(var id, var text):
	print("Happy Story Designer Log:")
	print("Load Dialogue:  ID:" + String(index) + "  " + text)
	pass
