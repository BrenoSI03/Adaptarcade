extends Node

export var circle_scene : PackedScene
export var cross_scene : PackedScene

var player : int
var moves : int
var temp_marker
var winner : int
var player_panel_pos : Vector2
var grid_pos : Vector2
var grid_data : Array
var board_size: int
var scale: Vector2
var cell_size : int
var cell_sizeT: Vector2
var event_pos : Vector2
var div1 : int
var div2 : int
var cell : int
var row_sum : int
var col_sum : int
var diagonal1_sum : int
var diagonal2_sum : int

onready var world_env = $WorldEnvironment

func _ready():
	Settings.get_worldenviroment(world_env)
	board_size = $Board.texture.get_width()
	scale = $Board.scale
	board_size = board_size*scale[1]
	cell_size = int(board_size / 3)
	cell_sizeT = Vector2(cell_size, cell_size)
	player_panel_pos = $PlayerPanel.get_position()
	new_game()
	
func _process(delta):
	pass
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if  event.position.x < board_size + 24 and event.position.x > 24 and event.position.y > 320 and event.position.y < 320 + board_size:
				div1 = event.position.x / cell_size
				div2 = (event.position.y - 320) / cell_size
				grid_pos = Vector2(div1, div2)
				if grid_data[grid_pos.y][grid_pos.x] == 0:
					moves += 1
					grid_data[grid_pos.y][grid_pos.x] = player
					create_marker(player, grid_pos * cell_sizeT + Vector2((cell_sizeT[0] / 2) + 24 , (cell_sizeT[1] /2)+320))
					if check_win() != 0:
						get_tree().paused = true
						$GameOverMenu.show()
						if winner == 1:
							$GameOverMenu.get_node("ResultLabel").text = "Jogador 1 venceu!"
						elif winner == -1:
							$GameOverMenu.get_node("ResultLabel").text = "Jogador 2 venceu!"
					elif moves == 9:
						get_tree().paused = true
						$GameOverMenu.show()
						$GameOverMenu.get_node("ResultLabel").text = "Empate!"
					player *= -1
					temp_marker.queue_free()
					create_marker(player, player_panel_pos + Vector2(cell_sizeT[0] / 2 - 14 , cell_sizeT[1] /2 - 16), true)
					print(grid_data)

func new_game():
	player = 1
	moves = 0
	winner = 0
	grid_data = [
		[0, 0, 0],
		[0, 0, 0],
		[0, 0, 0]
		]
	row_sum = 0 
	col_sum - 0
	diagonal1_sum = 0
	diagonal2_sum = 0
	get_tree().call_group("circles","queue_free")
	get_tree().call_group("crosses","queue_free")
	create_marker(player, player_panel_pos + Vector2(cell_sizeT[0] / 2 - 14, cell_sizeT[1] / 2 - 16), true)
	$GameOverMenu.hide()

func create_marker(player, position, temp = false):
	if player == 1:
		var circle = circle_scene.instance()
		circle.position = position
		add_child(circle)
		if temp : temp_marker = circle
	else:
		var cross = cross_scene.instance()
		cross.position = position
		add_child(cross)
		if temp : temp_marker = cross

func check_win():
	for i in len(grid_data):
		row_sum = grid_data[i][0] + grid_data[i][1] + grid_data[i][2]
		col_sum = grid_data[0][i] + grid_data[1][i] + grid_data[2][i]
		diagonal1_sum = grid_data[0][0] + grid_data[1][1] + grid_data[2][2]
		diagonal2_sum = grid_data[0][2] + grid_data[1][1] + grid_data[2][0]
	
		if row_sum == 3 or col_sum == 3 or diagonal1_sum == 3 or diagonal2_sum == 3:
			winner = 1
		elif row_sum == -3 or col_sum == -3 or diagonal1_sum == -3 or diagonal2_sum == -3:
			winner = -1
	return winner

func _on_GameOverMenu_restart_signal():
	get_tree().paused = false
	new_game()


func _on_ToolButton_pressed():
	get_tree().change_scene("res://scenes/main_menu.tscn")
