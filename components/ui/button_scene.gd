# Given a `target_scene`, this component will change scene to it when being clicked
# Supply it as a string formatted path to the target scene, for example: res://menu/main_menu.tscn

extends Button


@export var target_scene: String


func _ready():
	if target_scene == '':
		push_warning('target_scene path sould not be empty')


func _on_pressed():
	if target_scene != '':
		GlobalAudioPlayer.play_mouse_click_sound()
		get_tree().change_scene_to_file(target_scene)
