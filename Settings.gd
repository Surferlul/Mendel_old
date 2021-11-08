extends Panel
signal escape
export var color_sceme = "Dark"
signal change_color

var Utills = preload("Utills.gd").new()


func _on_Escape_pressed():
	emit_signal("escape")


func _on_Information_pressed():
	$FileCounterReset/Information/PopupDialog.popup()


func _on_LinkButton_pressed():
	#OS.shell_open("https://www.voidtools.com/Everything-1.4.1.935.x86.zip")
	var args = PoolStringArray([])
	if Utills.file_exists_eas(Utills.project_path() + "Data/" + "Everything.exe", "absolute"):
		OS.execute(Utills.project_path() + "Data/" + "Everything.exe", PoolStringArray([]), false)
	else:
		$Error/ErrorLabel.text = ""
		$Error/ErrorLabel.rect_size.x = $Error/Download_Everything.rect_size.x
		$Error/ErrorLabel.rect_size.y = $Error/Download_Everything.rect_size.y
		$Error/ErrorLabel.text = "Error:\nEverything.exe wurde aus\n" + Utills.project_path() + "Data/" + "\nentfernt\nEverything Downloaden?"
		$Error.popup()
		$Error.rect_size.x = ($Error/ErrorLabel.rect_size.x + 40) / 2
		$Error.rect_size.y = ($Error/ErrorLabel.rect_size.y + 80) / 2
		$Error.rect_position.x = 60
		$Error.rect_position.y = 60
		$Error/Download_Everything.rect_position.y = ($Error/ErrorLabel.rect_size.y + 20) / 2

func _on_FileCounterReset_pressed():
	Utills.write_file("0", "FileCount.txt", "private")



func _on_Download_Everything_pressed():
	OS.shell_open("https://www.voidtools.com/Everything-1.4.1.935.x86.zip")
	


func _on_Fullscreen_pressed():
	if $Fullscreen/Fullscreen.pressed:
		OS.window_fullscreen = true
		$Fullscreen/Warning.show()
	else:
		OS.window_fullscreen = false
		$Fullscreen/Warning.hide()

func _on_Warning_pressed():
	$Fullscreen/Warning/PopupDialog.popup()


func _on_Borderless_pressed():
	if $Borderless/Borderless.pressed:
		OS.window_borderless = true
		$Borderless/Warning.show()
	else:
		OS.window_borderless = false
		$Borderless/Warning.hide()
		


func _on_BorderlessWarning_pressed():
	$Borderless/Warning/PopupDialog.popup()


func _on_ColorSceme_pressed():
	if $ColorSceme.text == "Dunkel":
		$ColorSceme.text = "Hell"
	elif $ColorSceme.text == "Hell":
		$ColorSceme.text = "Dunkel"
