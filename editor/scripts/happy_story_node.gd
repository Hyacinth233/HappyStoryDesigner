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


