class_name AddTimeEntryWindow
extends ConfirmationDialog


func _ready() -> void:
	mode = Window.MODE_WINDOWED
	unresizable = true
	min_size = Vector2i(500, 200)
	exclusive = true
	initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_MAIN_WINDOW_SCREEN
	dialog_text = "How much time did you work?"
	popup_centered(Vector2i(2, 2))
	show()
	for c in get_children():
		if c is VBoxContainer:
			for c2 in c.get_children():
				if c2 is LineEdit:

					c.grab_focus()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		confirmed.emit()
