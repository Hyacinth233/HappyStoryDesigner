tool
extends Control

var the_plugin
var cur_teller
var cur_director : Resource
var director_name : String
var node_size = 0
var editor_selection:EditorSelection

onready var graph_edit = $graph_editor
onready var director_name_label = $graph_editor/director_name
onready var node_size_label = $graph_editor/node_size
onready var warning_label_0 = $warning_label_0
onready var warning_label_1 = $warning_label_1
onready var create_menu = $create_menu

var has_ready = false

func _ready():
	set_current_teller(null)
	if the_plugin:
		var editor_interface:EditorInterface = the_plugin.get_editor_interface()
		editor_selection = editor_interface.get_selection()
		editor_selection.connect("selection_changed", self, "_on_editor_selection_changed")
	
	
func clear_nodes():
	graph_edit.clear_connections()
	for child in graph_edit.get_children():
		if child is GraphNode:
			graph_edit.remove_child(child)
			child.queue_free()
			
func set_current_teller(teller):
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

		else:
			#print("木有director")
			graph_edit.visible = false
			warning_label_0.visible = false
			warning_label_1.visible = true
		
		load_nodes_from_director(cur_director)
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
	
func load_nodes_from_director(director):
	pass

func create_dialogue_node():
	print("添加对话节点")

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
		
	director_name_label.text = director_name
	node_size_label.text = "Story Node Size : " + String(node_size)


func _on_graph_editor_popup_request(position):
	create_menu.set_global_position(position)
	create_menu.popup()


func _on_create_menu_id_pressed(id):
	match id:
		0:
			create_dialogue_node()
