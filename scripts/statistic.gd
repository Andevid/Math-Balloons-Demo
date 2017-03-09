
extends Node2D


func _ready():
	#load highscores data
	pass

func _on_homeButton_pressed():
	get_tree().change_scene("res://scene/menu.scn")


func _on_leaderButton_pressed():
	print("show leaderboard!")


func _on_achieveButton_pressed():
	print("show achievement!")


func _on_resetButton_pressed():
	get_tree().change_scene("res://scene/game01.scn")
