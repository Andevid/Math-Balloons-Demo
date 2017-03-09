
extends PopupMenu


func _ready():
	pass
	
func _on_homeButton_pressed():
	get_tree().set_pause(false)
	get_tree().change_scene("res://scene/menu.scn")


func _on_statButton_pressed():
	get_tree().set_pause(false)
	get_tree().change_scene("res://scene/statistic.scn")

func _on_resetButton_pressed():
	get_tree().set_pause(false)
	get_tree().reload_current_scene()