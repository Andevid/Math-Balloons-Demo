
extends Node

const KEY_MUSIC_ENABLE = "MUSIC_ENABLE"
const KEY_SOUND_ENABLE = "SOUND_ENABLE"
const KEY_SHOW_FPS = "SHOW_FPS"
const MAX_BALLOONS = 30
const MIN_SCORES = -50
const SETTINGS_FILE = "user://mbdemoprefs.bin"


var save_file
var password
var gamedata
var level = 1
var score = 0
var quiz_number = -1
var balloon_counter = 0
var right_counter = 0
var bonus_counter
var fbonus_counter
var game_over
var show_fps = true
var is_sound_enable = true
var is_music_enable = true
var balloon_list = []


func _ready():
	password = "123456"
	_checkSaveGame()
	resetGame()

func _exit_tree():
	music.playMenuMusic(false)
	music.playGameMusic(false)
	
func resetGame():
	level = 1
	score = 0
	game_over = false
	quiz_number = -1
	balloon_counter = 0
	right_counter = 0
	balloon_list.clear()
	
	resetAllBonus()


func resetAllBonus():
	bonus_counter = 0
	fbonus_counter = 0

func addLevel():
	level += 1

func getLevel():
	return level
	
func addScore(val):
	score += val
	
func getScore():
	return score
	
func addRightCounter(val):
	right_counter += val
	
func setQuizNumber(number):
	quiz_number = number
	
func getQuizNumber():
	return quiz_number
	
func setGameOver():
	game_over = true
	
func isGameOver():
	return game_over or balloon_counter >= MAX_BALLOONS or score <= MIN_SCORES

func setSoundEnable(is_sound):
	is_sound_enable = is_sound

func setMusicEnable(is_music):
	is_music_enable = is_music

func setFpsShow(is_show):
	show_fps = is_show

func isFpsShow():
	return show_fps

func addBonusCounter():
	bonus_counter += 1

func addFastBonusCounter():
	fbonus_counter += 1
	
func addBalloonToList(balloon, is_add):
	if is_add:
		balloon_list.append(balloon)
	else:
		balloon_list.erase(balloon)
		
	balloon_counter = balloon_list.size()


#============================================================
func _checkSaveGame():
	save_file = File.new()
	
	if not save_file.file_exists(SETTINGS_FILE):
		saveGame()
	else:
		_loadGame()


func saveGame():
	save_file = File.new()
	_prepareData()
	
	save_file.open_encrypted_with_pass(SETTINGS_FILE, File.WRITE, password)
	save_file.store_var(gamedata)
	save_file.close()
	
	print("save_game()::gamedata: " + gamedata.to_json())

func _prepareData():
	""""
	music enable
	sound enable
	show fps
	"""
	
	gamedata = {
		MUSIC_ENABLE = is_music_enable,
		SOUND_ENABLE = is_sound_enable,
		SHOW_FPS = show_fps
	}
	
	print("gamedata: " + gamedata.to_json())


func _loadGame():
	save_file = File.new()
	save_file.open_encrypted_with_pass(SETTINGS_FILE, File.READ, password)
	gamedata = save_file.get_var()
	save_file.close()

	is_music_enable = gamedata[KEY_MUSIC_ENABLE]
	is_sound_enable = gamedata[KEY_SOUND_ENABLE]
	show_fps = gamedata[KEY_SHOW_FPS]
	