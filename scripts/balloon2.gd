
extends RigidBody2D

var ball_rand

func _ready():
	randomize()
	ball_rand = randi()%4
	get_node("Sprite").set_texture(load("res://texture/balloon_" + str(ball_rand) + ".tex"))
	set_process(true)


func _process(delta):
	if (get_pos().y < -100):
		queue_free()

