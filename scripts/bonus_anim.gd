
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	music.playBonusSound()
	print("info anim ready!")
	pass

func initLabel(text1, text2):
	get_node("Label").set_text(text1 + "\n" + text2)

func _on_Anim_finished():
	queue_free()
