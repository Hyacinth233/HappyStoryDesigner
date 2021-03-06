tool
extends Happy_Story_Node

#var editor
#var director : Happy_Director
var node_data : Happy_Dialogue
#var node_coordinate : Vector2
#var id : int

#export(Happy_Story.TYPE) var type

func _ready():
	refresh_node()
	set_slot(0, true, 0, slot_color_l, true, 0, slot_color_r, tex, tex)
	
func _process(delta):
	if not editor:
		return
	if selected:
		if not editor.selected_nodes.has(self):
			editor.selected_nodes.append(self)
			editor.selected_position = offset
		#	print(editor.selected_nodes)
	else:
		if editor.selected_nodes.has(self):
			editor.selected_nodes.erase(self)
	
	set_node_style()
	
func refresh_node():
	if node_data:
		id = node_data.id
		node_data.type = type
		$HBoxContainer_0/id.text = String(node_data.id)
		$HBoxContainer_0/name.text = node_data.speaker
		#$HBoxContainer_1/color.color = node_data.color
		#$HBoxContainer_2/scale.value = node_data.speed_scale
		#$HBoxContainer_2/voice.select(node_data.voice)
		$TextEdit.text = node_data.text

func save_node():
	editor.cur_director.storys[id] = node_data
	editor.cur_director.coordinate[id] = node_coordinate
	editor.save_director()

func _on_name_text_changed(new_text):
	if node_data:
		node_data.speaker = new_text
		save_node()
	if editor:
		editor.refresh_inspector()
		
func _on_TextEdit_text_changed():
	if node_data:
		node_data.text = $TextEdit.text
		save_node()
	if editor:
		editor.refresh_inspector()

#func _on_color_color_changed(color):
#	if node_data:
#		node_data.color = color
#		save_node()
#	if editor:
#		editor.refresh_inspector()

#func _on_scale_value_changed(value):
#	if node_data:
#		node_data.speed_scale = value
#		save_node()
#	if editor:
#		editor.refresh_inspector()

#func _on_voice_item_selected(index):
#	if node_data:
#		node_data.voice = index
#		save_node()
#	if editor:
#		editor.refresh_inspector()

func _on_happy_dialogue_node_offset_changed():
	node_coordinate = offset
	save_node()

func _on_happy_dialogue_node_mouse_entered():
	if editor:
		editor.mouse_enter_node = self

func _on_happy_dialogue_node_mouse_exited():
	if editor:
		if editor.mouse_enter_node == self:
			editor.mouse_enter_node = null
