
extends Control


func _ready():
	get_node("VBoxopt/HBoxs/cbsound").set_pressed(globals.is_sound_enable)
	get_node("VBoxopt/HBoxm/cbmusic").set_pressed(globals.is_music_enable)
	get_node("VBoxopt/HBoxf/cbfps").set_pressed(globals.isFpsShow())


func _on_cbmusic_toggled( pressed ):
	music.playClickSound()
	globals.setMusicEnable(pressed)
	music.playMenuMusic(pressed)


func _on_cbsound_toggled( pressed ):
	music.playClickSound()
	globals.setSoundEnable(pressed)
	

func _on_cbfps_toggled( pressed ):
	music.playClickSound()
	globals.setFpsShow(pressed)

func _on_btnResetGame_toggled( pressed ):
	music.playClickSound()
	#----
	globals.resetGame()


func _on_btnOptionsHome_pressed():
	globals.saveGame()
	get_tree().change_scene("res://scene/menu.scn")
	
	