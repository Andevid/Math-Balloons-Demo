
extends PopupMenu


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _on_homeButton_pressed():
	get_tree().set_pause(false)
	get_tree().change_scene("res://scene/menu.scn")
	

func _on_resumeButton_pressed():
	get_node(".").hide()
	get_tree().set_pause(false)
