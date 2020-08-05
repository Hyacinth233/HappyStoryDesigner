tool
extends GraphNode

class_name Happy_Tool_Node

enum TYPE{
	VARIABLE = 0,
}

var editor
var director : Happy_Director
var node_coordinate : Vector2

export(TYPE) var type


