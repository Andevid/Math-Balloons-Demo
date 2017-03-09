
extends Node2D

const WARNING_ACTIVE = 20

var width
var height
var a
var b
var c
var tq
var opr = ""
var is_bonus_active
var is_fbonus_active
var is_inc_level
onready var is_ready = false
var operators = ["+", "-", "x", ":"]
var anim_queues = []
var balloon_scn = preload("res://scene/balloon.scn")
var score_anim_scn = preload("res://scene/score_anim.scn")
var info_anim_scn = preload("res://scene/bonus_anim.scn")


func _ready():
	width = get_viewport_rect().size.width
	height = get_viewport_rect().size.height
	globals.resetGame()
	anim_queues.clear()
	spawnBalloons(5)
	get_node("HUD/LbFps").set_hidden(!globals.isFpsShow())
	set_fixed_process(true)
	music.playGameMusic(true)
	music.playMenuMusic(false)
	get_node("CountDown/AnimPlayer").play("countdown")
	

func _fixed_process(delta):
	get_node("HUD/LbLevel").set_text("LEVEL: " + str(globals.getLevel()))
	get_node("HUD/LbScore").set_text("SCORE: " + str(globals.getScore()))
	tq = get_node("QuizTimer").get_time_left()/3*100
	get_node("QuizProgress").set_value(tq)
	
	if (globals.isFpsShow()):
		get_node("HUD/LbFps").set_text("FPS: " + str(OS.get_frames_per_second()))
	
	if (globals.isGameOver()):
		gameOver()
	
	if (globals.balloon_counter < 5):
		spawnBalloons(5)
	
	#show bonus effect
	if (globals.bonus_counter%5 == 0 and globals.bonus_counter > 4 and not is_bonus_active):
		#show bonus_anim
		addInfoAnim("GREAT!", "+10")
		is_bonus_active = true
		globals.addScore(10)
		print("show bonus counter: " + str(globals.bonus_counter))
	elif (globals.bonus_counter%5 > 0 and is_bonus_active):
		is_bonus_active = false
		print("reset bonus counter: " + str(globals.bonus_counter))
	
	#show fast bonus effect
	
	#increase level
	if (globals.right_counter%10 == 0 and globals.right_counter > 0 and \
			not is_inc_level):
		is_inc_level = true
		globals.addLevel()
	elif (globals.right_counter%10 > 0 and is_inc_level):
		is_inc_level = false
		pass


#+trigger from balloon click
func updateProgress():
	get_node("CounterProgress").set_value(float(globals.balloon_counter)*100/globals.MAX_BALLOONS)
	
	if (globals.balloon_counter >= WARNING_ACTIVE and not get_node("Anim").is_playing()):
		get_node("Anim").play("progressbar_warning")
	elif (globals.balloon_counter < WARNING_ACTIVE and get_node("Anim").is_playing()):
		get_node("Anim").stop()
		get_node("CounterProgress").set_opacity(1)
	

func gameOver():
	get_node("SoundPlayer").play("lose")
	get_tree().set_pause(true)
	get_node("HUD/Popup/gameover_popup/lbscore").set_text("Score: " + str(globals.getScore()))
	get_node("HUD/Popup/gameover_popup").show()

func _on_BtnPause_pressed():
	music.playClickSound()
	get_tree().set_pause(true)
	get_node("HUD/Popup/pause_popup").show()

# +trigger from balloon click
func resetQuizTimer():
	if not is_ready:
		return
	
	get_node("QuizTimer").stop()
	get_node("QuizTimer").start()
	generateQuiz()


func _on_QuizTimer_timeout():
	if not is_ready:
		is_ready = true
		get_node("LbReady").hide()
		get_node("MathLabel").show()
		get_node("QuizProgress").show()
		generateQuiz()
	else:
		showScoreAnim(0, Vector2(width/2 - 100, 50))
		get_node("SoundPlayer").play("time_out")
		globals.addScore(-5)
		globals.resetAllBonus()
		generateQuiz()

func generateQuiz():
	opr = randi()%operators.size()
	var bhalf = globals.balloon_counter/2
	
	if (bhalf <= 0):
		spawnBalloons(2)
		resetQuizTimer()
		return
	
	var bi = randi()%bhalf
	var ball = globals.balloon_list[bi]
	globals.setQuizNumber(ball.balloonId)
	c = ball.balloonId
	
	if (operators[opr].match("+")):
		generateAddittion()
	elif (operators[opr].match("-")):
		generateSubstract()
	elif (operators[opr].match("x")):
		generateMultiply()
	elif (operators[opr].match(":")):
		generateDivide()

func generateAddittion():
	a = randi()%(c+1)
	b = c-a
	
	setMathQuiz(a, b, operators[opr], "?")
	#print(operators[opr])

func generateSubstract():
	b = randi()%((globals.getLevel() * 10 +1) /2)
	a = b + c
	
	setMathQuiz(a, b, operators[opr], "?")
	#print(operators[opr])
	

func generateMultiply():
	if (c <= 0):
		generateQuiz()
		return
	
	var d = -1
	
	while(d != 0):
		a = (randi()%(c+1)) +1
		d = c % a
		#print("generateMultiply: " + str(d))
	
	b = c/a
	setMathQuiz(a, b, operators[opr], "?")

func generateDivide():
	if (c <= 0):
		generateQuiz()
		return
	
	var d = -1
	
	while(d != 0):
		a = (randi()%(globals.getLevel()*10+1)) +1
		d = a % c
		#print("generateDivide: " + str(a))
	
	b = a/c
	setMathQuiz(a, b, operators[opr], "?")
	#print(operators[opr])

func _on_SpawnTimer_timeout():
	spawnBalloons(1)
	
func spawnBalloons(val):
	for i in range(val):
		var posx = rand_range(50, width - 250)
		var balloon = balloon_scn.instance()
		balloon.set_pos(Vector2(posx, height - 30))
		add_child(balloon)
		globals.addBalloonToList(balloon, true)
		updateProgress()
		

func setMathQuiz(v1, v2, op, r):
	get_node("MathLabel/number01").set_text(str(v1))
	get_node("MathLabel/number02").set_text(str(v2))
	get_node("MathLabel/operator").set_text(op)
	get_node("MathLabel/result").set_text(str(r))

func showScoreAnim(score_id, pos):
	var score_anim = score_anim_scn.instance()
	score_anim.initScoreAnim(score_id)
	score_anim.set_pos(pos)
	add_child(score_anim)
	
func addInfoAnim(info1, info2):
	var info_anim = info_anim_scn.instance()
	info_anim.initLabel(info1, info2)
	info_anim.set_pos(Vector2(width/2 - 100, height/2))
	anim_queues.append(info_anim)
	
	showInfoAnim()


func showInfoAnim():
	if (anim_queues.size() <= 0):
		return
	
	add_child(anim_queues[anim_queues.size()-1])
	anim_queues.remove(anim_queues.size()-1)

func _exit_tree():
	music.playGameMusic(false)
	pass
	

