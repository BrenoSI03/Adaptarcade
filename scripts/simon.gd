extends Control

var restart : bool = true
var playerCursor:int = 0;
var sequence:Array = [];
var idle:bool = true;
var _idleChangeTimer:float = 5.0;
const _idleChangeTimerStart:float = 5.0;
const _idleChangeTimerReset:float = 3.0;

onready var world_env = $WorldEnvironment
onready var buttonsColor:Array = [$Green, $Yellow, $Red, $Blue];
onready var sfx:Array = [$sfx/Do,$sfx/Re,$sfx/Mi,$sfx/Fa];
onready var ai:Array = [$AIGreen, $AIYellow, $AIRed, $AIBlue];

func _ready():
	position()
	resetGame();
	Settings.get_worldenviroment(world_env)
	

func position():
	for index in (len(buttonsColor)):
		var position = buttonsColor[index].get_position()
		ai[index].set_position(position)

func _process(delta):
	if not idle:
		return;
	
	_idleChangeTimer -= delta;
	if _idleChangeTimer <= 0:
		_idleChangeTimer = _idleChangeTimerReset;
		var element = randi()%4;
		ai[element].visible = false;
		
		yield(get_tree().create_timer(0.5), "timeout")
		
		if not idle: return;
		ai[element].visible = false;

func resetGame():
	restart = true
	randomize();
	for img in ai:
		img.visible = false;
	_stopSounds();
	_disableButtons();
	$Start.disabled = false;
	idle = true;
	_idleChangeTimer = _idleChangeTimerStart;

func startAIState():
	for img in ai:
		img.visible = false;
	_disableButtons();
	
	#Add one element to the sequence
	var newElement = randi()%4;
	sequence.append(newElement);
	print(sequence)
	$Label.text = "%02d" % sequence.size(); 
	
	yield(get_tree().create_timer(0.5), "timeout")
	
	#play the sequence
	for e in sequence:
		ai[e].visible = true;
		sfx[e].play();
		yield( sfx[e], "finished" );
		ai[e].visible = false;
	
	startPlayerState();


func startPlayerState():
	_enableButtons();
	
	playerCursor = 0;


func _disableButtons():
	$Green.disabled = true;
	$Red.disabled = true;
	$Yellow.disabled = true;
	$Blue.disabled = true;


func _enableButtons():
	$Green.disabled = false;
	$Red.disabled = false;
	$Yellow.disabled = false;
	$Blue.disabled = false;

func _stopSounds():
	for e in sfx:
		e.stop();

func _error():
	_stopSounds();
	_disableButtons();
	$sfx/error.play();
	yield( $sfx/error, "finished" );
	resetGame();

func _checkPlayerButton(button:int):
	if playerCursor < sequence.size() and sequence[playerCursor] == button:
		sfx[button].play();
		playerCursor += 1;
		if playerCursor >= sequence.size():
			yield( sfx[button], "finished" );
			startAIState();
	else:
		_error();


func _on_Button_pressed():
	restart = false
	print(restart)
	idle = false;
	$Start.disabled = true;
	sequence.clear();
	startAIState();


func _on_Back_pressed():
	get_tree().change_scene("res://scenes/main_menu.tscn")
