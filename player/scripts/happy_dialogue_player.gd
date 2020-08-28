extends Node

export(NodePath) var teller
export(String) var speaker
export(String) var text
export(float) var speed

var is_playing

onready var speaker_label = $VBoxContainer/dialogue_bar/speaker
onready var text_richtext = $VBoxContainer/dialogue_bar/dialogue
onready var next_btn = $VBoxContainer/button_bar/next_btn
onready var skip_btn = $VBoxContainer/button_bar/skip_btn
onready var replay_btn = $VBoxContainer/button_bar/replay_btn

var play_coroutine

func _ready():
	clear_dialogue()
	
func clear_dialogue():
	speaker_label.text = ""
	text_richtext.text = ""
	text_richtext.visible_characters = 0

func set_dialogue(var _speaker : String, var _dialogue : String):
	speaker = _speaker
	text = _dialogue
	
func play_dialogue():
	clear_dialogue()
	speaker_label.text = speaker
	text_richtext.text = text
	next_btn.visible = false
	skip_btn.visible = true
	replay_btn.visible = false
	play_one_by_one()

func play_one_by_one():
	is_playing = true
	for n in range(text.length()):
		if not is_playing:
			return "Skip"
		text_richtext.visible_characters = n + 1
		yield(get_tree().create_timer(1/speed),"timeout")
	play_over()

func play_over():
	text_richtext.visible_characters = -1
	next_btn.visible = true
	skip_btn.visible = false
	replay_btn.visible = true

func _on_next_btn_pressed():
	play_dialogue()

func _on_skip_btn_pressed():
	is_playing = false
	play_over()

func _on_replay_btn_pressed():
	play_dialogue()
