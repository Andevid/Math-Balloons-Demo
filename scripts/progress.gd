
extends Node2D

# member variables here, example:
# var a=2
var curr = 0

func _ready():
	#startProcess(true)
	pass
	
func startProcess(is_start):
	set_process(is_start)
	

func _process(delta):
	#curr = get_node("TextureProgress").get_value()
	curr += delta *80
	get_node("TextureProgress").set_value(curr)
	
	if (int(curr)%10 == 0):
		print(str(curr))
	
	if (curr >= 100):
		curr = 0
		get_node("TextureProgress").set_value(curr)
		get_tree().change_scene(globals.getNextScene())
		set_process(false)
		pass


func _exit_tree():
	curr = 0
	get_node("TextureProgress").set_value(curr)
	
	music.playMenuMusic(false)
	music.playGameMusic(false)