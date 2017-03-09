
extends Node2D

var scoreId

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
	
	
func initScoreAnim(id):
	scoreId = id
	get_node("spscore").set_texture(load("res://texture/score_" + str(id) + ".tex"))
	
	if (id == 2):
		get_node("Anim").play("right_score")
	else:
		get_node("Anim").play("wrong_score")
		

func _on_Anim_finished():
	queue_free()
