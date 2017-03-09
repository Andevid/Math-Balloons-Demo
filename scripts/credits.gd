
extends Node2D

const BEGIN = 900
const MIDDLE = 300
const END = -1000

var tpos
var text
var size
var counter = 0
var text_counter = 0
var balloon_scn = preload("res://scene/balloon2.scn")

var credit_texts = [
	"MATH BALLOONS\nDESIGN BY DOYANCREATIVE\n@2016\n\nMath Balloons is a simple game that is fun\nbut could also sharpen the brain.",
	"Build with Opensource apps:\nUbuntu Mate\nGodotEngine\nInkscape\nGimp\nAudacity",
	"Video Tutorial Tools:\nVokoscreen - Screencast tool\nKeyMon - Screencast tool\nOpenShot Video Editor\nVLC - video preview",
	"Others Contributors:\nOurMusicBox.com\nFreesound.org\nOpenclipart.org\nGameart2d.com\netc.",
	"Thank you for all contributors"
]

func _ready():
	text = get_node("Tween/TextCredits")
	size = get_viewport_rect().size
	#print(str(size))
	
	set_process(true)
	#set_process_input(true)
	tpos = text.get_pos()

func _process(delta):
	counter +=delta
	
	#spawn balloons
	if (counter > 1):
		counter = 0
		var balloon = balloon_scn.instance()
		var posx = rand_range(10, size.width-50)
		balloon.set_pos(Vector2(posx, size.height +100))
		add_child(balloon)

func _input(event):
	if (event.type == InputEvent.MOUSE_BUTTON and event.is_pressed()):
		_on_BtnHome_pressed()


func textAnimation():
	#reset credits text
	if (text_counter > credit_texts.size() -1):
		text_counter = 0
	
	var tween = get_node("Tween")
	var pos = tween.tell()
	tween.reset_all()
	tween.remove_all()
	
	get_node("Tween/TextCredits").set_text(credit_texts[text_counter])
	text_counter += 1

	tween.interpolate_method(text, "set_pos", Vector2(tpos.x, BEGIN), Vector2(tpos.x, MIDDLE), 2, tween.TRANS_ELASTIC, tween.EASE_OUT)
	tween.interpolate_method(text, "set_pos", Vector2(tpos.x, MIDDLE), Vector2(tpos.x, END), 1, tween.TRANS_BACK, tween.EASE_IN, 3)

	tween.set_repeat(true)
	tween.start()
	tween.seek(pos)
	

func _on_BtnHome_pressed():
	music.playClickSound()
	get_tree().change_scene("res://scene/menu.scn")
