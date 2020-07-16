tool
extends GraphNode

var editor
var director : Happy_Director
var node_data : Happy_Dialogue
var node_coordinate : Vector2
var id : int
var branch_size = 0
var branches = []

export(Color) var slot_color : Color
onready var branch_zero = preload("../branch.tscn")
onready var tree_root = $"."

func create_branch():
	var branch = branch_zero.instance()
	tree_root.add_child(branch)
	branch.index.text = String(branch_size)
	branches.append(branch)
	branch.node = self
	branch_size += 1

func delete_branch(var branch):
	branches.erase(branch)
	branch.queue_free()
	branch_size -= 1
	rect_size = Vector2.ZERO
	
func _on_new_branch_btn_pressed():
	create_branch()
