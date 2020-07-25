tool
extends Control

var editor
var node

onready var window = $ConfirmationDialog
onready var tag_edit = $ConfirmationDialog/LineEdit
onready var error_window = $AcceptDialog
onready var error_label = $AcceptDialog/Label2

func _ready():
	window.show_modal(true)

func show_error(var error_text : String):
	error_label.text = error_text
	error_window.set_position(window.rect_position)
	error_window.show_modal(true)

func _on_ConfirmationDialog_confirmed():
	if not editor:
		return
	var tags = editor.cur_teller.tags
	if not tag_edit.text:
		show_error("Tag name can't be Null !")
		return
	if tags.has(tag_edit.text):
		show_error("Tag named " + tag_edit.text + " has already existed !\nPlease try another name.")
		return
	for tag in tags:
		if tags[tag] == node.id:
			tags.erase(tag)
	node.node_data.tag = tag_edit.text
	tags[tag_edit.text] = node.id
	node.save_node()
	editor.refresh_inspector()
	
	self.queue_free()
