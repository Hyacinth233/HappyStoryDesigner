tool
extends GraphNode

var editor
var director : Happy_Director
var node_data : Happy_Dialogue
var node_coordinate : Vector2
var id

func _ready():
	refresh_node()
		
func refresh_node():
	if node_data:
		id = node_data.id
		$HBoxContainer_0/id.text = String(node_data.id)
		$HBoxContainer_1/name.text = node_data.name
		$HBoxContainer_1/color.color = node_data.color
		$HBoxContainer_2/scale.value = node_data.speed_scale
		$HBoxContainer_2/voice.select(node_data.voice)
		$TextEdit.text = node_data.text

func save_node():
	editor.cur_director.storys[id] = node_data
	editor.cur_director.coordinate[id] = node_coordinate
	editor.save_director()

func _on_name_text_changed(new_text):
	if node_data:
		node_data.name = new_text
		save_node()
	if editor:
		editor.refresh_inspector()

func _on_color_color_changed(color):
	if node_data:
		node_data.color = color
		save_node()
	if editor:
		editor.refresh_inspector()

func _on_scale_value_changed(value):
	if node_data:
		node_data.speed_scale = value
		save_node()
	if editor:
		editor.refresh_inspector()

func _on_voice_item_selected(index):
	if node_data:
		node_data.voice = index
		save_node()
	if editor:
		editor.refresh_inspector()

func _on_TextEdit_text_changed():
	if node_data:
		node_data.text = $TextEdit.text
		save_node()
	if editor:
		editor.refresh_inspector()

func _on_happy_dialogue_node_offset_changed():
	node_coordinate = offset
	save_node()
