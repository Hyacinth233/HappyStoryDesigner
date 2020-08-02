tool
extends GraphNode
class_name Tool_Variable_Node

var editor

export(bool) var global = false
export(String) var variable

onready var global_btn : CheckButton = $HBoxContainer/global_btn
onready var var_opt : OptionButton = $HBoxContainer2/var_opt

var var_dictionary

func _ready():
	refresh_node()

func refresh_node():
	refresh_var_opt()
		
func refresh_var_opt():
	if not editor:
		return
		
	var_opt.clear()
	if global:
		var_dictionary = editor.cur_teller.global_vars
	else:
		var_dictionary = editor.cur_teller.local_vars
	for key in var_dictionary:
		var_opt.add_item(key)
	variable = var_opt.get_item_text(0)

func save_node():
	pass

func _on_global_btn_toggled(button_pressed):
	global = button_pressed
	refresh_var_opt()
	save_node()
	
func _on_var_opt_item_selected(index):
	variable = var_opt.get_item_text(index)
	save_node()
