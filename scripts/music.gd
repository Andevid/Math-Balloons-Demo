
extends Node2D


func _ready():
	pass

func playMenuMusic(play):
	if (not globals.is_music_enable):
		play = false
	
	if (play):
		if (not get_node("MenuMusicPlayer").is_playing()):
			get_node("MenuMusicPlayer").play()
	else:
		get_node("MenuMusicPlayer").stop()
	
func playGameMusic(play):
	if (not globals.is_music_enable):
		play = false
	
	if (play):
		get_node("GameMusicPlayer").play()
	else:
		get_node("GameMusicPlayer").stop()
	
func playClickSound():
	if (_isSoundEnable()):
		get_node("soundplayer").play("click")
	
func playBonusSound():
	if (_isSoundEnable()):
		get_node("soundplayer").play("bonus")

func playBalloonSound(is_right):
	if (not _isSoundEnable()):
		return
	
	if (is_right):
		get_node("BalloonSound").play("balloon_burst")
	else:
		get_node("BalloonSound").play("wrong")


func _isSoundEnable():
	return globals.is_sound_enable