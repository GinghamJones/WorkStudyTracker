class_name DeleteButton
extends Button

var corresponding_line : HBoxContainer
var time_entry : TimeEntry
signal return_data(line, myself)


func initiate(line, new_time_entry):
	return_data.connect(Callable(TimeEntryManager.remove_entry))
	pressed.connect(Callable(self, "_on_button_pressed"))
	corresponding_line = line
	time_entry = new_time_entry
	set("size_flags_horizontal", SizeFlags.SIZE_SHRINK_END)


func _on_button_pressed():
	return_data.emit(self)
