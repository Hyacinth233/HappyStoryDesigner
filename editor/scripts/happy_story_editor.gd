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

var graph_nodes : Dictionary
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
const happy_branch_node = preload("../happy_branch_node.tscn")

var has_ready = false

func _ready():
	set_current_teller(null)
	if the_plugin:
		var editor_interface : EditorInterface = the_plugin.get_editor_interface()
		editor_selection = editor_interface.get_selection()
		editor_selection.connect("selection_changed", self, "_on_editor_selection_changed")
	
func clear_nodes():
	node_ids = []
	node_size = 0
	graph_edit.clear_connections()
	for key in graph_nodes:
		graph_nodes[key].queue_free()
	graph_nodes.clear()
			
func set_current_teller(teller):
	cur_teller = Happy_Story_Teller.new()
	cur_director = Happy_Director.new()
	clear_nodes()
	if teller:
		if teller.director:
			graph_edit.visible = true
			warning_label_0.visible = false
			warning_label_1.visible = false
			
			cur_teller = teller
			cur_director = cur_teller.director
			
			director_name = cur_director.resource_path.get_basename()
			teller.editor = self
			load_nodes_from_director(cur_director)
			
		else:
			graph_edit.visible = false
			warning_label_0.visible = false
			warning_label_1.visible = true
			teller.editor = self
		
	else:
		cur_teller = null
		cur_director = null
		graph_edit.visible = false
		warning_label_0.visible = true
		warning_label_1.visible = false
	
func refresh_inspector():
	var editor_interface : EditorInterface = the_plugin.get_editor_interface()
	editor_interface.get_inspector().refresh()
	director_name_label.text = director_name
	node_size = node_ids.size()
	node_size_label.text = "Story Node Size : " + String(node_size)	
	
func load_nodes_from_director(director : Happy_Director):
	var node
	for key in director.storys:
		match director.storys[key].type:
			Happy_Story.TYPE.DIALOGUE:
				node = happy_dialogue_node.instance()
			Happy_Story.TYPE.BRANCH:
				node = happy_branch_node.instance()
			#在此处添加新的类型
			
		node.editor = self
		node.director = cur_director
		node.node_data = cur_director.storys[key]
		node.refresh_node()
		node_ids.append(key)
		node_size = node_ids.size()
		graph_nodes[key] = node
		node.node_coordinate = director.coordinate[key]
#		print(node.node_coordinate)
		node.offset = director.coordinate[key]
		graph_edit.add_child(node)
		
	refresh_inspector()
	
	for key in graph_nodes:
		match graph_nodes[key].type:
			Happy_Story.TYPE.DIALOGUE:
				var to_id = graph_nodes[key].node_data.to_id
				if to_id != -1:
					if graph_nodes[to_id]:
						graph_edit.connect_node(graph_nodes[key].name, 0, graph_nodes[to_id].name, 0)
						#print(String(key) + "~" + String(to_id))
					else:
						to_id = -1
			Happy_Story.TYPE.BRANCH:
				var branches = graph_nodes[key].node_data.branches
				if branches.size() != 0:
					for index in branches:
						var to_id = branches[index]
						if to_id != -1:
							if graph_nodes[to_id]:
								graph_edit.connect_node(graph_nodes[key].name, index, graph_nodes[to_id].name, 0)
							else:
								to_id = -1

func create_node(var id):
	var node : GraphNode
	match id:
		0:
			node = happy_dialogue_node.instance()
		1:
			node = happy_branch_node.instance()
	add_story_into_director(node)
	graph_edit.add_child(node)
	graph_nodes[node.id] = node
	node.offset = create_menu.get_global_rect().position - graph_edit.get_global_rect().position + graph_edit.scroll_offset
	refresh_inspector()
	
func add_story_into_director(node):
	node.editor = self
	node.director = cur_director

	var id = create_new_id()
	if not node.node_data:
		match node.type:
			Happy_Story.TYPE.DIALOGUE:
				node.node_data = Happy_Dialogue.new()
			Happy_Story.TYPE.BRANCH:
				node.node_data = Happy_Branch.new()
				#node.node_data.selections.clear()
				#node.node_data.branches.clear()
			#在此处添加新的类型
			
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
		print("test")
		cur_director.storys[id] = node.node_data
		cur_director.storys[id].id = id
		#cur_director.coordinate[id] = node.offset
		#node.node_data.to_id = -1
		#node.node_data.last_nodes = []
		#print(node.node_data.id)
		node.refresh_node()
		save_director()
		graph_edit.add_child(node)
		graph_nodes[id] = node
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
	graph_nodes.erase(node.id)
			
	if node.node_data.to_id != -1:	
		var to_node = graph_nodes[node.node_data.to_id]
		graph_edit.disconnect_node(node.name, 0, to_node.name, 0)
		to_node.node_data.last_nodes.erase(node.id)
	for id in node.node_data.last_nodes:
		var from_node = graph_nodes[id]
		graph_edit.disconnect_node(from_node.name, 0, node.name, 0)
		from_node.node_data.to_id = -1
		
	save_director()
	node.queue_free()
	refresh_inspector()
		
func save_director():
	if cur_director:
		var path = cur_director.resource_path
		cur_director.editor_offset = editor_offset
		ResourceSaver.save(path, cur_director)
	
func repeat_auto_disconnect(from_node, from_slot, to_id, to_slot):
	if to_id != -1:
		var src_to_node = graph_nodes[to_id]
		graph_edit.disconnect_node(from_node.name, from_slot, src_to_node.name, to_slot)
		
#----- signer -----

func _on_editor_selection_changed():
	var selections : Array = editor_selection.get_selected_nodes()
	if selections.size() > 0:
		for selection in selections:
			if selection is Happy_Story_Teller:
				set_current_teller(selection)
				break
			else:
				set_current_teller(null)
	else:
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
	create_node(id)

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
	var to_id
	match from_node.type:
		Happy_Story.TYPE.DIALOGUE:
			to_id = from_node.node_data.to_id
			repeat_auto_disconnect(from_node, from_slot, to_id, to_slot)
#			if to_id != -1:
#				var src_to_node = graph_nodes[from_node.node_data.to_id]
#				graph_edit.disconnect_node(from, from_slot, src_to_node.name, to_slot)
			from_node.node_data.to_id = to_node.id
		Happy_Story.TYPE.BRANCH:
			to_id = from_node.node_data.branches[from_slot]
			repeat_auto_disconnect(from_node, from_slot, to_id, to_slot)
#			if to_id != -1:
#				var src_to_node = graph_nodes[from_node.node_data.to_id]
#				graph_edit.disconnect_node(from, from_slot, src_to_node.name, to_slot)
			from_node.node_data.branches[from_slot] = to_node.id
		#在此处添加新的类型
		
	to_node.node_data.last_nodes.append(from_node.id)
	#print(to_node.node_data.last_nodes)
	graph_edit.connect_node(from, from_slot, to, to_slot)

func _on_graph_editor_disconnection_request(from, from_slot, to, to_slot):
	var from_node = graph_edit.get_node(from)
	var to_node = graph_edit.get_node(to)
	match from_node.type:
		Happy_Story.TYPE.DIALOGUE:
			from_node.node_data.to_id = -1
		Happy_Story.TYPE.BRANCH:
			from_node.node_data.branches[from_slot] = -1
		#在此处添加新的类型
		
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

