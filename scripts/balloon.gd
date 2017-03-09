
extends RigidBody2D

var balloonId
var hasClicked = false
var scoreId
var game


func _ready():
	randomize()
	var ball_id = randi()%13
	get_node("Sprite").set_texture(load("res://texture/balloon_" + str(ball_id) + ".tex"))
	balloonId = randi()% (globals.getLevel() *10)
	get_node("Number").set_text(str(balloonId))
	game = get_node("/root/Game01")

func _input_event(viewport, event, shape_idx):
	if (event.type == InputEvent.MOUSE_BUTTON and event.is_pressed() \
			and not hasClicked):
		
		hasClicked = true
		get_node("Anim").play("burst")
		get_node(".").set_use_custom_integrator(true)
		get_node(".").set_linear_velocity(Vector2(0, -30))
		get_node(".").set_angular_velocity(0)
		get_node("CollisionShape2D").set_trigger(true)
		get_node("Sprite").hide()
		globals.addBalloonToList(self, false)
			
		if (globals.getQuizNumber() == balloonId):
			#right
			scoreId = 2
			globals.addScore(10)
			globals.addRightCounter(1)
			globals.addBonusCounter()
			music.playBalloonSound(true)
			
		else:
			#wrong
			scoreId = 1
			globals.addScore(-10)
			globals.resetAllBonus()
			music.playBalloonSound(false)
			game.spawnBalloons(1)
		
		game.resetQuizTimer()
		game.showScoreAnim(scoreId, get_pos())
		game.updateProgress()

func _on_Anim_finished():
	queue_free()
