class_name DeleteButton
extends Button

var corresponding_line : HBoxContainer
var time_entry : TimeEntry
signal return_data(line, myself)


func initiate(parent, line, new_time_entry):
	return_data.connect(Callable(parent, "remove_time"))
	pressed.connect(Callable(self, "_on_button_pressed"))
	corresponding_line = line
	time_entry = new_time_entry


func _on_button_pressed():
	return_data.emit(corresponding_line, self)
