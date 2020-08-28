tool
extends Happy_Story_Node

var node_data : Happy_Assign

var variables = ["test0","test1","test2"]

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
	else:
		if editor.selected_nodes.has(self):
			editor.selected_nodes.erase(self)
	set_node_style()
			
func refresh_node():
	if node_data:
		id = node_data.id
		node_data.type = type
		$HBoxContainer3/id.text = String(node_data.id)
		$HBoxContainer/global_btn.pressed = node_data.is_global
		refresh_variable_opt()	
		$HBoxContainer4/new_value.text = String(node_data.new_value)
		$HBoxContainer2/var_opt.selected = variables.find(node_data.variable)
		node_data.variable = $HBoxContainer2/var_opt.get_item_text($HBoxContainer2/var_opt.selected)

func save_node():
	editor.cur_director.storys[id] = node_data
	editor.cur_director.coordinate[id] = node_coordinate
	editor.save_director()

func refresh_variable_opt():
	$HBoxContainer2/var_opt.clear()
	variables.clear()
	var temp_var_dic
	if node_data.is_global:
		temp_var_dic = editor.cur_teller.global_vars.duplicate()
	else:
		temp_var_dic = editor.cur_teller.local_vars.duplicate()
	for v in temp_var_dic:
		$HBoxContainer2/var_opt.add_item(v)
		variables.append(v)
	print(variables)

func _on_global_btn_toggled(button_pressed):
	if button_pressed == node_data.is_global:
		return
	if node_data:
		node_data.is_global = button_pressed
		save_node()
	if editor:
		editor.refresh_inspector()
		refresh_variable_opt()
		$HBoxContainer2/var_opt.selected = 0

func _on_var_opt_item_selected(index):
	if node_data:
		node_data.variable = $HBoxContainer2/var_opt.get_item_text(index)
		save_node()
	if editor:
		editor.refresh_inspector()

func _on_new_value_text_changed(new_text):
	if node_data:
		node_data.new_value = float(new_text)
		save_node()
	if editor:
		editor.refresh_inspector()
	
func _on_happy_assign_node_mouse_entered():
	if editor:
		editor.mouse_enter_node = self

func _on_happy_assign_node_mouse_exited():
	if editor:
		if editor.mouse_enter_node == self:
			editor.mouse_enter_node = null

func _on_happy_assign_node_offset_changed():
	node_coordinate = offset
	save_node()
