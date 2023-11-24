extends Control


func _ready():
	# disable start button for now
	$Container/ButtonContainer/StartButtonScene.disabled = true
	
	# disable setting button for now
	$Container/ButtonContainer/SettingsButtonScene.disabled = true
	
	# make BrandingIcon invisible (for now, it only being needed to bump te VContainerBox
	$Container/HeadingContainer/BrandingIcon.modulate = Color('000000', 0)
	
	var icon_tween = create_tween()
	icon_tween.tween_callback(make_icon_blink).set_delay(5)


func make_icon_blink():
	var the_eye: Sprite2D = $Arena/Colies/BaseUnitBig/Eye
	var original_eye_scale = the_eye.scale
	var target_eye_scale = original_eye_scale * Vector2(0.3, 0.3)
	
	var blink_tween = create_tween()
	blink_tween.tween_property($Arena/Colies/BaseUnitBig/Eye, 'scale', target_eye_scale, 0.1)
	blink_tween.tween_property($Arena/Colies/BaseUnitBig/Eye, 'scale', original_eye_scale, 0.1)
	blink_tween.tween_property($Arena/Colies/BaseUnitBig/Eye, 'scale', target_eye_scale, 0.1)
	blink_tween.tween_property($Arena/Colies/BaseUnitBig/Eye, 'scale', original_eye_scale, 0.1)
	blink_tween.tween_callback(make_icon_moveable).set_delay(1)


func make_icon_moveable():
	$Arena/Colies/BaseUnitBig.should_move = true


func _on_how_to_play_button_pressed():
	get_tree().change_scene_to_file("res://menu/how_to_play.tscn")


func _on_setting_button_pressed():
	get_tree().change_scene_to_file("res://menu/settings.tscn")

