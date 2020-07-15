tool
extends Control
class_name Happy_Story_Editor

var the_plugin
var cur_teller : Happy_Story_Teller
var cur_director : Happy_Director
var editor_offset : Vector2
var director_name : String
var node_size = 0
var node_ids : Array
var editor_selection : EditorSelection
var mouse_enter_node : GraphNode = null
var popup_node : GraphNode

var copied_datas = [Happy_Story]
var selected_nodes = [GraphNode]
var selected_position = Vector2.ZERO

onready var graph_edit = $graph_editor
onready var director_name_label = $graph_editor/director_name
onready var node_size_label = $graph_editor/node_size
onready var node_root_label = $graph_editor/node_root
onready var warning_label_0 = $warning_label_0
onready var warning_label_1 = $warning_label_1
onready var create_menu = $create_menu
onready var node_menu = $node_menu

const happy_dialogue_node = preload("../happy_dialogue_node.tscn")

var has_ready = false

func _ready():
	set_current_teller(null)
	if the_plugin:
		var editor_interface:EditorInterface = the_plugin.get_editor_interface()
		editor_selection = editor_interface.get_selection()
		editor_selection.connect("selection_changed", self, "_on_editor_selection_changed")
		
func scale_editor(var scale : float):
	graph_edit.zoom += scale
	
func clear_nodes():
	node_ids = []
	node_size = 0
	graph_edit.clear_connections()
	for child in graph_edit.get_children():
		if child is GraphNode:
			graph_edit.remove_child(child)
			child.queue_free()
			
func set_current_teller(teller):
	cur_teller = Happy_Story_Teller.new()
	cur_director = Happy_Director.new()
	clear_nodes()
	if teller:
		if teller.director:
			#print("有director")
			graph_edit.visible = true
			warning_label_0.visible = false
			warning_label_1.visible = false
			
			cur_teller = teller
			cur_director = cur_teller.director
			
			director_name = cur_director.resource_path.get_basename()
			teller.editor = self
			load_nodes_from_director(cur_director)
			
		else:
			#print("木有director")
			graph_edit.visible = false
			warning_label_0.visible = false
			warning_label_1.visible = true
			teller.editor = self
		
	else:
		#print("这玩儿就不是Teller")
		cur_teller = null
		cur_director = null
		graph_edit.visible = false
		warning_label_0.visible = true
		warning_label_1.visible = false
	
func refresh_inspector():
	var editor_interface:EditorInterface = the_plugin.get_editor_interface()
	editor_interface.get_inspector().refresh()
	director_name_label.text = director_name
	node_size = node_ids.size()
	node_size_label.text = "Story Node Size : " + String(node_size)	
	
func load_nodes_from_director(director : Happy_Director):
	var graph_node_dictionary : Dictionary
	for key in director.storys:
		var node = happy_dialogue_node.instance()
		node.editor = self
		node.director = cur_director
		node.node_data = cur_director.storys[key]
		node.refresh_node()
		node_ids.append(key)
		node_size = node_ids.size()
		graph_edit.add_child(node)
		node.offset = director.coordinate[key]
		graph_node_dictionary[key] = node
	refresh_inspector()
	
	for key in graph_node_dictionary:
		var next_key = graph_node_dictionary[key].node_data.next_id
		if next_key != -1:
			if graph_node_dictionary[next_key]:
				graph_edit.connect_node(graph_node_dictionary[key].name, 0, graph_node_dictionary[next_key].name, 0)
				#print(String(key) + "~" + String(next_key))
			else:
				next_key = -1

func create_dialogue_node():
	var node = happy_dialogue_node.instance()
	add_story_into_director(node)
	graph_edit.add_child(node)
	node.offset = create_menu.get_global_rect().position - graph_edit.get_global_rect().position + graph_edit.scroll_offset
	refresh_inspector()
	
func add_story_into_director(node):
	node.editor = self
	node.director = cur_director

	var id = create_new_id()
	if not node.node_data:
		node.node_data = Happy_Dialogue.new()
	cur_director.storys[id] = node.node_data
	cur_director.storys[id].id = id
	cur_director.coordinate[id] = node.offset
	node.refresh_node()
	save_director()
	
func create_new_id() -> int:
	var new_id = 0
	node_ids.sort()
	for id in node_ids:
		if new_id == id:
			new_id += 1
	node_ids.append(new_id)
	return new_id
	
func set_root_node(var node : GraphNode):	
	cur_teller.root = node.id
	refresh_inspector()

func copy_nodes(var nodes : Array):
	for node in nodes:
		var story : Happy_Story
		story = node.node_data
		copied_datas.append(story)
		#print("复制池："+String(copied_datas))

func paste_nodes(var datas : Array):
	for data in datas:
		var node = happy_dialogue_node.instance()
		node.editor = self
		node.director = cur_director
		var id = data.id
		if node_ids.has(id):
			id = create_new_id()
		if not node.node_data:
			node.node_data = Happy_Dialogue.new()
		node.node_data = data.clone()
		cur_director.storys[id] = node.node_data
		cur_director.storys[id].id = id
		#cur_director.coordinate[id] = node.offset
		#node.node_data.next_id = -1
		#node.node_data.last_nodes = []
		#print(node.node_data.id)
		node.refresh_node()
		save_director()
		graph_edit.add_child(node)
		var position = selected_position + Vector2(40,10)
		selected_position = position
		node.offset = position #- graph_edit.get_global_rect().position + graph_edit.scroll_offset
		#print(node.offset)
		refresh_inspector()

func delete_node(var node : GraphNode):
	if cur_teller.root == node.id:
		cur_teller.root = -1
		#print("Root Not Found")
	node_ids.erase(node.id)
	node_size = node_ids.size()
	cur_director.storys.erase(node.id)
	cur_director.coordinate.erase(node.id)
	
	var nodes : Dictionary
	for child in graph_edit.get_children():
		if child is GraphNode:
			nodes[child.id] = child
			
	if node.node_data.next_id != -1:	
		var to_node = nodes[node.node_data.next_id]
		graph_edit.disconnect_node(node.name, 0, to_node.name, 0)
		to_node.node_data.last_nodes.erase(node.id)
	for id in node.node_data.last_nodes:
		var from_node = nodes[id]
		graph_edit.disconnect_node(from_node.name, 0, node.name, 0)
		from_node.node_data.next_id = -1
		
	save_director()
	node.queue_free()
	refresh_inspector()
		
func save_director():
	if cur_director:
		var path = cur_director.resource_path
		cur_director.editor_offset = editor_offset
		ResourceSaver.save(path, cur_director)
	
#----- signer -----

func _on_editor_selection_changed():
	var selections:Array = editor_selection.get_selected_nodes()
	if selections.size() > 0:
		for selection in selections:
			if selection is Happy_Story_Teller:
				#print("找到Teller了！")
				set_current_teller(selection)
				break
			else:
				#print("没找到Teller")
				set_current_teller(null)
	else:
		#print("大哥你没选东西啊！")
		set_current_teller(null)
		

func _on_graph_editor_popup_request(position):
	if mouse_enter_node != null:
		popup_node = mouse_enter_node
		node_menu.set_global_position(position)
		node_menu.popup()
	else:
		create_menu.set_global_position(position)
		create_menu.popup()


func _on_create_menu_id_pressed(id):
	match id:
		0:
			create_dialogue_node()

func _on_node_menu_id_pressed(id):
	match id:
		0:
			set_root_node(popup_node)
			
func _on_graph_editor_delete_nodes_request():
	for node in selected_nodes:
		if node is GraphNode:
			delete_node(node)
			#print(selected_nodes)

func _on_graph_editor_scroll_offset_changed(ofs):
	editor_offset = ofs
	save_director()

func _on_graph_editor_connection_request(from, from_slot, to, to_slot):
	var from_node = graph_edit.get_node(from)
	var to_node = graph_edit.get_node(to)
	
	var nodes : Dictionary
	for child in graph_edit.get_children():
		if child is GraphNode:
			nodes[child.id] = child
	if from_node.node_data.next_id != -1:
		var src_to_node = nodes[from_node.node_data.next_id]
		graph_edit.disconnect_node(from, from_slot, src_to_node.name, to_slot)
		
	from_node.node_data.next_id = to_node.id
	to_node.node_data.last_nodes.append(from_node.id)
	#print(to_node.node_data.last_nodes)
	graph_edit.connect_node(from, from_slot, to, to_slot)

func _on_graph_editor_disconnection_request(from, from_slot, to, to_slot):
	var from_node = graph_edit.get_node(from)
	var to_node = graph_edit.get_node(to)
	from_node.node_data.next_id = -1
	to_node.node_data.last_nodes.erase(from_node.id)
	save_director()
	graph_edit.disconnect_node(from, from_slot, to, to_slot)

func _on_graph_editor_copy_nodes_request():
	copied_datas.clear()
	for node in selected_nodes:
		if node is GraphNode:
			copied_datas.append(node.node_data)
			#print(copied_datas)

func _on_graph_editor_paste_nodes_request():
	paste_nodes(copied_datas)

