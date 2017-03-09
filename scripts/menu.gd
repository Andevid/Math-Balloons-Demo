
extends Control


func _ready():
	music.playMenuMusic(true)
	pass

func _on_BtnPlay_pressed():
	music.playClickSound()
	get_tree().change_scene("res://scene/game01.scn")
	
	
func _exit_tree():
	#music.playMenuMusic(false)
	pass


func _on_BtnCredits_pressed():
	music.playClickSound()
	get_tree().change_scene("res://scene/credits.scn")


func _on_BtnOption_pressed():
	music.playClickSound()
	get_tree().change_scene("res://scene/options.scn")
