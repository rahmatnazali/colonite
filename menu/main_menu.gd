extends Control


func _ready():
	pass

func _process(_delta):
	pass

func _on_how_to_play_button_pressed():
	get_tree().change_scene_to_file("res://menu/how_to_play.tscn")

func _on_setting_button_pressed():
	get_tree().change_scene_to_file("res://menu/settings.tscn")
