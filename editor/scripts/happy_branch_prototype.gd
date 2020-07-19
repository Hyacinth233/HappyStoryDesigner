tool
extends Control
class_name Happy_Branch_Prototype
	
var node
var index = 0
var last_index = 0
var selection = ""
var last_selection = ""

onready var btn = $delete_btn
onready var index_text = $index
onready var selection_text = $selection

func _ready():
	index_text.text = String(index)
	
func _process(delta):
	if last_index != index:
		index_text.text = String(index)
		last_index = index
	if last_selection != selection:
		selection_text.text = selection
		last_selection = selection

func _on_delete_btn_pressed():
	if node:
		node.delete_branch(self)

func _on_selection_text_changed(new_text):
	if node:
		node._on_selection_text_changed(index, new_text)
