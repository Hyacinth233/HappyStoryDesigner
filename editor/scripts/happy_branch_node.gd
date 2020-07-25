tool
extends Happy_Story_Node

#var editor
#var director : Happy_Director
var node_data : Happy_Branch
#var node_coordinate : Vector2
#var id : int
var branch_size = 0
var branches : Array
#export(Happy_Story.TYPE) var type
export(Color) var slot_color_r : Color

const branch_zero = preload("../branch.tscn")

func _ready():
	refresh_node()

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

func refresh_node():
	if node_data:
		id = node_data.id
		node_data.type = type
		$HBoxContainer_0/id.text = String(node_data.id)
		if branch_size < node_data.selections.size():
			for index in range(branch_size, node_data.selections.size()):
				create_branch(node_data.selections[index], node_data.branches[index])
		

func save_node():
	editor.cur_director.storys[id] = node_data
	editor.cur_director.coordinate[id] = node_coordinate
	editor.save_director()
	
func create_branch(var selection : String = "", var branch : int = -1):
	var branch_node = branch_zero.instance()
	branch_node.index = branch_size
	node_data.selections[branch_node.index] = selection
	node_data.branches[branch_node.index] = branch
	branches.append(branch_node)
	branch_size += 1
	add_child(branch_node)
	branch_node.node = self
	branch_node.selection = selection
	set_slot(branch_size + 1, false, 0, slot_color_r, true, 0, slot_color_r)

func delete_branch(var branch_node):
	branches.erase(branch_node)
	var to_id = node_data.branches[branch_node.index]
	if to_id != -1:
		var to_node = editor.graph_nodes[to_id]
		editor.graph_edit.disconnect_node(self.name, branch_node.index, to_node.name, 0)
	if branch_size > 1:
		for index in range(branch_node.index, branch_size - 1):
			var src_index = branches[index].index
			#修改prototype的显示index
			if src_index != index:
				branches[index].index = index
				#复制旧key的selections和branches到新key，并清除旧key的内容
				node_data.selections[index] = node_data.selections[src_index]
				node_data.branches[index] = node_data.branches[src_index]
				node_data.selections.erase(src_index)
				node_data.branches.erase(src_index)
				#更改连接的slot
				to_id = node_data.branches[index]
				if to_id != -1:
					var to_node = editor.graph_nodes[to_id]
					editor.graph_edit.disconnect_node(self.name, src_index, to_node.name, 0)
					editor.graph_edit.connect_node(self.name, index, to_node.name, 0)

	else:
		node_data.selections.erase(branch_node.index)
		node_data.branches.erase(branch_node.index)
	branch_node.queue_free()
	branch_size -= 1
	rect_size = Vector2.ZERO
	save_node()
	
func _on_selection_text_changed(var index, var new_text):
	if node_data:
		node_data.selections[index] = new_text
		save_node()
	if editor:
		editor.refresh_inspector()

func _on_new_branch_btn_pressed():
	create_branch()
	
func _on_happy_branch_node_offset_changed():
	node_coordinate = offset
	save_node()

func _on_happy_branch_node_mouse_entered():
	if editor:
		editor.mouse_enter_node = self

func _on_happy_branch_node_mouse_exited():
	if editor:
		if editor.mouse_enter_node == self:
			editor.mouse_enter_node = null
