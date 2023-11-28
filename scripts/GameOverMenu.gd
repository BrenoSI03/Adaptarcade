extends CanvasLayer

#var restart = Node.new()
signal restart_signal

func _on_Button_pressed():
	emit_signal("restart_signal")
