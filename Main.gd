extends Control

func _ready():
	$Settings.hide()
	$Mendel.show()

func _on_Alles_settings():
	$Mendel.hide()
	$Settings.show()


func _on_Quit_pressed():
	
	get_tree().quit()


func _on_Settings_escape():
	$Mendel.show()
	$Settings.hide()
