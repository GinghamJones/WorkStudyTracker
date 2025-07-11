class_name AddDataWindow
extends ConfirmationDialog

@onready var date_line: LineEdit = $VBoxContainer/DateLine
@onready var hours_line: LineEdit = $VBoxContainer/HoursLine
@onready var error_label: Label = $VBoxContainer/ErrorLabel
@onready var error_timer: Timer = $ErrorTimer


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_ENTER:
			confirmed.emit()


func check_data() -> bool:
	# Check date
	var date : String = date_line.text
	var r : RegEx = RegEx.new()
	r.compile("^(0[1-9]|1[0-2])/(0[1-9]|[12][0-9]|3[01])$")
	var check := r.search(date)
	if check == null:
		return false
	
	var hours : String = hours_line.text
	var r2 : RegEx = RegEx.new()
	r2.compile("^[1-9]$")
	var check2 := r2.search(hours)
	if check2 == null:
		return false
	
	return true

func _on_confirmed() -> void:
	if not TimeEntryManager.add_entry(date_line.text, hours_line.text):
		show()
		error_label.text = "Invalid format: please use mm/dd and number for hours"
		error_label.show()
		error_timer.start()
		return
	queue_free()


func _on_text_submitted(_new_text: String) -> void:
	confirmed.emit()


func _on_error_timer_timeout() -> void:
	error_label.hide()
