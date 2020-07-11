tool
extends EditorPlugin

var dock

func _enter_tree():
	add_custom_type("Happy_Story_Teller", "Node", preload("class/happy_story_teller.gd"), preload("icon.png"))
	dock = preload("editor/happy_story_editor.tscn").instance()
	dock.the_plugin = self
	add_control_to_bottom_panel(dock, "Happy Story Designer")


func _exit_tree():
	remove_custom_type("Happy_Story_Teller")
	remove_control_from_bottom_panel(dock)
	dock.free()
