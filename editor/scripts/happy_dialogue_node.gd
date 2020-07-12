tool
extends GraphNode

var editor
var director : Happy_Director
var node_data : Happy_Dialogue
var id = -1

func _ready():
	refresh_node()
		
func refresh_node():
	if node_data:
		$HBoxContainer_0/id.text = String(node_data.id)
		$HBoxContainer_1/name.text = node_data.name
		$HBoxContainer_1/color.color = node_data.color
		$HBoxContainer_2/scale.value = node_data.speed_scale
		$HBoxContainer_2/voice.select(node_data.voice)
		$TextEdit.text = node_data.text

func _on_name_text_changed(new_text):
	if node_data:
		node_data.name = new_text
	if editor:
		editor.refresh_inspector()

func _on_color_color_changed(color):
	if node_data:
		node_data.color = color
	if editor:
		editor.refresh_inspector()

func _on_scale_value_changed(value):
	if node_data:
		node_data.speed_scale = value
	if editor:
		editor.refresh_inspector()

func _on_voice_item_selected(index):
	if node_data:
		node_data.voice = index
	if editor:
		editor.refresh_inspector()

func _on_TextEdit_text_changed():
	if node_data:
		node_data.text = $TextEdit.text
	if editor:
		editor.refresh_inspector()
