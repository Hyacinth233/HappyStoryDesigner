tool
extends Node

class_name Happy_Story_Teller

export(Resource) var director
export(bool) var refresh_tags setget on_refresh_tags_pressed
export(bool) var to_tag setget on_to_tag_pressed
export(String) var tag
export(Dictionary) var tags
export(bool) var play setget on_play_pressed
export(bool) var next setget on_next_pressed
export(Array) var params = [-1]


var last_director = Happy_Director.new()
var editor
export(int) var index = 0
var indexs : Dictionary

func _ready():
	pass
	
func _process(delta):
	if Engine.editor_hint:
		if editor:
			if last_director != director:
				editor.set_current_teller(self)
				last_director = director

func on_refresh_tags_pressed(var btn):
	if Engine.editor_hint:
		if editor:
			tags.clear()
			for story in director.storys:
				tags[director.storys[story].tag] = director.storys[story].id
			editor.refresh_inspector()
			
func on_to_tag_pressed(var btn):
	to_tag()
	
func on_play_pressed(var btn):
	play()
	
func on_next_pressed(var btn):
	next(params)
	
func to_tag(var temp_tag = tag):
	index = tags[temp_tag]
	
func play():
	if not director.storys.has(index):
		print_logs(index, "EROOR: Invalid get index!")
		return
	match director.storys[index].type:
		Happy_Story.TYPE.DIALOGUE:			
			return play_dialogue()
		Happy_Story.TYPE.BRANCH:
			return play_branch()
	print_logs(index, "EROOR: Unknown Type")
	return 
	
func play_with_index(var _index : int):
	index = _index
	return play()
	
func next(var temp_params : Array):
	if index == -1:
		print_logs(index, "END!")
	match director.storys[index].type:
		Happy_Story.TYPE.DIALOGUE:			
			index = director.storys[index].to_id
		Happy_Story.TYPE.BRANCH:
			if !indexs.keys().has(temp_params[0]):
				return "ERROR: Can't Find Branch With Index " + String(temp_params[0]) 
			index = indexs[temp_params[0]]
		_:
			index = -1
			return "ERROR: Unknown Type"
	if index == -1:
		print_logs(index, "END!")
	
func play_dialogue() -> Happy_Dialogue:
	var speaker = director.storys[index].speaker
	var text = director.storys[index].text
	print_logs(index, speaker + ":" + text, "Load Dialogue : ")
	return director.storys[index]
	
func play_branch() -> Happy_Branch:
	var selections = director.storys[index].selections
	print_logs(index, String(selections), "Load Branch : ")
	indexs = director.storys[index].branches
	return director.storys[index]
	
func print_logs(var id, var text, var type = ""):
	print("Happy Story Designer Log:")
	print(type + "ID:" + String(index) + "  " + text)
	pass
