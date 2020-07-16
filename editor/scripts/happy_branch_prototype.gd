tool
extends Control
class_name Happy_Branch_Prototype
	
var node

onready var btn = $delete_btn
onready var index = $index
onready var selection = $selection

func _on_delete_btn_pressed():
	if node:
		node.delete_branch(self)
