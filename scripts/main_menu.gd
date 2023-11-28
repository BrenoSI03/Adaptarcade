extends Control

onready var worldEnv = $WorldEnvironment

func _ready():
	Settings.get_worldenviroment(worldEnv)
	#
	pass # Replace with function body.

func toggle():
	visible = !visible
	get_tree().paused = visible


func _on_TextureButton_pressed():
	get_tree().change_scene("res://scenes/Settings.tscn")
