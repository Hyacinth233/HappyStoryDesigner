tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("Happy_Story_Teller", "Node", preload("class/happy_story_teller.gd"), preload("icon.png"))


func _exit_tree():
	remove_custom_type("Happy_Story_Teller")
