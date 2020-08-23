tool
extends GraphNode

class_name Happy_Story_Node

var editor
var director : Happy_Director
var node_coordinate : Vector2
var id : int

export(Happy_Story.TYPE) var type

var base_color : Color
var godot_settings
var last_base_color : Color
var alpha = 0.7
var brightness_cut = 0.5
var dark_color_weight = 0.25
var light_color_weight = 0.55
var tex = preload("../../gizmo/next.svg")

export(Color) var slot_color_l = Color(0.38,0.74,0.3,1)
export(Color) var slot_color_r = Color(0.81,1,0.77,1)

func set_node_style():
	if not godot_settings:
		godot_settings = editor.the_plugin.get_editor_interface().get_editor_settings()
	base_color = godot_settings.get_setting("interface/theme/base_color")
	if last_base_color != base_color:
		var fake_brightness = (base_color.r + base_color.g + base_color.b)/3
		var color_0
		var color_1
		if fake_brightness > brightness_cut:
			color_0 = Color.white * (1 - light_color_weight) + base_color * light_color_weight
		else:
			color_0 = Color.black * (1 - dark_color_weight) + base_color * dark_color_weight
		color_1 = color_0 - Color(0, 0, 0, 1 - alpha)
		get_stylebox("frame").set_bg_color(color_1)
		get_stylebox("selectedframe").set_bg_color(color_0)
		last_base_color = base_color
