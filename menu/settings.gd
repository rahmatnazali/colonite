extends Control

var is_fullscreen: bool = false

func _ready():
	var window_mode: DisplayServer.WindowMode = DisplayServer.window_get_mode()
	
	if window_mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
		is_fullscreen = true
	else:
		is_fullscreen = false
	
	$MainContainer/SettingsContainer/HBoxContainer/FullScreenCheckButton.button_pressed = is_fullscreen

func _on_full_screen_check_button_toggled(supplied_is_fullscreen):
	is_fullscreen = supplied_is_fullscreen

	if is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_credit_link_button_pressed():
	OS.shell_open('https://github.com/rahmatnazali/colonite')

