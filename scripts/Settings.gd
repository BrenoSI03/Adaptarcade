extends Control

onready var options = $Options
onready var video = $Video
onready var audio = $Audio
onready var accessibiity = $Accessibility
onready var colorblindness_sel = $Accessibility/HBoxContainer/Options/Colorblindness_button
onready var colorblindness_add = $Colorblind
onready var world_env: WorldEnvironment = $WorldEnvironment
onready var brightness_label: Label = $Video/HBoxContainer/Labels/brightness_label
onready var contrast_label: Label = $Video/HBoxContainer/Labels/contrast_label
onready var saturation_label: Label = $Video/HBoxContainer/Labels/saturation_label
onready var audio_test = $Audio/test_sound


var colorblindness_dic: Dictionary = {"Nenhum": 0,
							"Protanopia" : 1,
							"Deuteranopia": 2,
							"Tritanopia": 3,
							"Acromatopsia": 4
							}

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		toggle()

func _ready():
	AddColorblindness()

func toggle():
	visible = !visible
	get_tree().paused = visible

func show_and_hide(first, second):
	first.show()
	second.hide()

func _on_BackFromOptions_pressed():
	toggle()
	get_tree().change_scene("res://scenes/main_menu.tscn")

# Video Settings #

func _on_Vdeo_pressed():
	show_and_hide(video,options)

func _on_BrightnessSlider_value_changed(value: float) -> void:
	brightness_label.text = str(value)
	world_env.environment.adjustment_brightness = value

func _on_ContrastSlider_value_changed(value: float) -> void:
	contrast_label.text = str(value)
	world_env.environment.adjustment_contrast = value

func _on_SaturationSlider_value_changed(value: float) -> void:
	saturation_label.text = str(value)
	world_env.environment.adjustment_saturation = value

# Audio Settings #

func _on_Audio_pressed():
	show_and_hide(audio,options)

func volume(bus_index, value):
	AudioServer.set_bus_volume_db(bus_index, linear2db(value))

func mute(bus_index,value):
	if value == -30:
		AudioServer.set_bus_mute(bus_index, true)
	else:
		AudioServer.set_bus_mute(bus_index, false)

func _on_Master_value_changed(value):
	volume(0, value)
	if value*100 < 10:
		$Audio/HBoxContainer/VBoxContainer/Value_Master.text = "0"+str(int(value*100))
	else:
		$Audio/HBoxContainer/VBoxContainer/Value_Master.text = str(int(value*100))
	mute(0, value)

func _on_Music_value_changed(value):
	volume(1, value)
	if value*100 < 10:
		$Audio/HBoxContainer/VBoxContainer/Value_Music.text = "0"+str(int(value*100))
	else:
		$Audio/HBoxContainer/VBoxContainer/Value_Music.text = str(int(value*100))
	mute(1, value)
		
func _on_Sound_Fx_value_changed(value):
	volume(2,value)
	if value*100 < 10:
		$Audio/HBoxContainer/VBoxContainer/Value_SoundFx.text = "0"+str(int(value*100))
	else:
		$Audio/HBoxContainer/VBoxContainer/Value_SoundFx.text = str(int(value*100))
	mute(2,value)

func _on_test_button_pressed():
	audio_test.play()
	yield(get_tree().create_timer(1.8), "timeout")

# Accessibility Settings #

func _on_Acessibilidade_pressed():
	show_and_hide(accessibiity,options)

func AddColorblindness():
	for c in colorblindness_dic:
		colorblindness_sel.add_item(c)

func _on_Colorblindness_button_item_selected(index):
	print(colorblindness_add.set_type(index))
# BackFrom_ Buttons #

func _on_BackFromVideo_pressed():
	show_and_hide(options,video)

func _on_BackFromAudio_pressed():
	show_and_hide(options,audio)
	$Audio/test_sound.stop()

func _on_BackFromAccessibility_pressed():
	show_and_hide(options,accessibiity)

func get_worldenviroment(new_environment:WorldEnvironment):
	var environment1 = $WorldEnvironment.get_environment()
	var brightness = environment1.get_adjustment_brightness()
	var contrast = environment1.get_adjustment_contrast()
	var saturation = environment1.get_adjustment_saturation()
	
	var enviroment2 = new_environment.get_environment()
	enviroment2.set_adjustment_brightness(brightness)
	enviroment2.set_adjustment_contrast(contrast)
	enviroment2.set_adjustment_saturation(saturation)
