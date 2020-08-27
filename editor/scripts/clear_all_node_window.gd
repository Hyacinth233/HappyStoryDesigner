tool
extends Control

var editor
onready var window : ConfirmationDialog= $ConfirmationDialog

func _ready():
	window.show_modal(true)

func _on_ConfirmationDialog_confirmed():
	if not editor:
		return
	editor.clear_nodes_save()
	
	self.queue_free()
