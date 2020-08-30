tool
extends Node

class_name Happy_Story_Teller

export(String) var story_name = "new_story"
export(Resource) var director
export(Dictionary) var tags

export(bool) var refresh setget on_refresh_pressed
export(bool) var to_tag setget on_to_tag_pressed
export(String) var tag

export(bool) var play setget on_play_pressed
export(bool) var next setget on_next_pressed
export(Array) var params = [-1]


var last_director = Happy_Director.new()
var editor
export(int) var index = 0
var indexs : Dictionary

func _ready():
	refresh_tags()
	if tag:
		to_tag()
	
func _process(delta):
	if Engine.editor_hint:
		if editor:
			if last_director != director:
				editor.set_current_teller(self)
				last_director = director

func on_refresh_pressed(var btn):
	refresh_tags()
			
func on_to_tag_pressed(var btn):
	to_tag()
	
func on_play_pressed(var btn):
	play()
	
func on_next_pressed(var btn):
	next(params)

func refresh_tags():
	if Engine.editor_hint:
		if editor:
			tags.clear()
			for story in director.storys:
				if director.storys[story].tag == "":
					tags.erase(director.storys[story].tag)
				else:
					tags[director.storys[story].tag] = director.storys[story].id
			editor.refresh_inspector()
	
func to_tag(var temp_tag = tag):
	if tags.has(temp_tag):
		index = tags[temp_tag]
	
func play():
	if not director.storys.has(index):
		print_logs(index, "EROOR: Invalid get index!")
		return null
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
	
func next(var temp_params : Array = [0]):
	if index == -1:
		print_logs(index, "END!")
		return null
	if not director.storys.has(index):
		return null
	match director.storys[index].type:
		Happy_Story.TYPE.DIALOGUE:
			index = director.storys[index].to_id
		Happy_Story.TYPE.BRANCH:
			if !indexs.keys().has(temp_params[0]):
				return null
			index = indexs[temp_params[0]]
		_:
			index = -1
			return null
	if index == -1:
		print_logs(index, "END!")
		return null
	return director.storys[index].type
	
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

