extends Button


func _on_addbutton_pressed() -> void:
	WindowManager.create_window(WindowManager.Windows.AddData)
