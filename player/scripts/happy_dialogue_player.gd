extends Node

export(NodePath) var teller_path
onready var teller : Happy_Story_Teller = get_node(teller_path)
var speaker
var text : String
export(float) var speed

var is_playing
var is_end

onready var speaker_label = $VBoxContainer/dialogue_bar/speaker
onready var text_richtext = $VBoxContainer/dialogue_bar/dialogue
onready var next_btn = $VBoxContainer/button_bar/next_btn
onready var skip_btn = $VBoxContainer/button_bar/skip_btn
onready var animation = $AnimationPlayer

var play_coroutine

func _ready():
	clear_dialogue()
	
func clear_dialogue():
	speaker_label.text = ""
	text_richtext.bbcode_text = ""
	text_richtext.visible_characters = 0

func set_dialogue(var _speaker : String, var _dialogue : String):
	speaker = _speaker
	text = _dialogue
	
func play_dialogue():
	clear_dialogue()
	speaker_label.text = speaker + ":"
	text_richtext.bbcode_text = text
	next_btn.visible = false
	skip_btn.visible = true
	play_one_by_one()

func play_one_by_one():
	is_playing = true
	var visible_char_f = 0
	while true:
		if not is_playing:
			return "Skip"
		visible_char_f += speed/Engine.get_frames_per_second()
		text_richtext.visible_characters = floor(visible_char_f)
		if text_richtext.visible_characters + 1 >= text.length():
			play_over()
			return "Over"
		yield(get_tree().create_timer(1/Engine.get_frames_per_second()),"timeout")

func play_over():
	text_richtext.visible_characters = -1
	next_btn.visible = true
	skip_btn.visible = false
	is_end = true if teller.next() == null else false
	if is_end:
		clear_dialogue()
		animation.current_animation = "Out"
		return

func _on_next_btn_pressed():
	var story = teller.play()
	if story == null:
		clear_dialogue()
		animation.current_animation = "Out"
		return
	if story.type == Happy_Story.TYPE.DIALOGUE:
		set_dialogue(story.speaker, story.text)
		play_dialogue()
	else:
		set_dialogue("HSD", "Node Type Not Dialogue")
		play_dialogue()

func _on_skip_btn_pressed():
	is_playing = false
	play_over()

