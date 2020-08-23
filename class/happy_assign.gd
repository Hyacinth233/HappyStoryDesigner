tool
extends Happy_Story
class_name Happy_Assign

func clone() -> Happy_Dialogue:
	var new = get_script().new()
	new.to_id = -1
	new.last_nodes = []
	new.last_slots = {}
	new.tag = tag
	#new.color = color
	#new.voice = voice
	#new.speed_scale = speed_scale
	return new
