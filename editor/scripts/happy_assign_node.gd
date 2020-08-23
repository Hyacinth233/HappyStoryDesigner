tool
extends Happy_Story_Node

var node_data : Happy_Assign

var branch_size = 0
var branches : Array

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
		$HBoxContainer3/id.text = String(node_data.id)

func save_node():
	editor.cur_director.storys[id] = node_data
	editor.cur_director.coordinate[id] = node_coordinate
	editor.save_director()

func _on_global_btn_toggled(button_pressed):
	pass # Replace with function body.

func _on_var_opt_item_selected(index):
	pass # Replace with function body.

func _on_tool_variable_node_mouse_entered():
	if editor:
		editor.mouse_enter_node = self

func _on_tool_variable_node_mouse_exited():
	if editor:
		if editor.mouse_enter_node == self:
			editor.mouse_enter_node = null

func _on_tool_variable_node_offset_changed():
	node_coordinate = offset
	save_node()
