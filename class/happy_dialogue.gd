tool
extends Happy_Story
class_name Happy_Dialogue

export(String) var speaker = ""
export(String) var text = ""
export(Color) var color = Color(0,0,0,1)
export(int) var voice = 0
export(int) var speed_scale = 1

func clone() -> Happy_Story:
	var new = get_script().new()
	new.next_id = -1
	new.last_nodes = []
	new.speaker = speaker
	new.text = text
	new.color = color
	new.voice = voice
	new.speed_scale = speed_scale
	return new
