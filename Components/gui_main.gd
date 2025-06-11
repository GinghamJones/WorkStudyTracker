class_name GUIMain
extends ScrollContainer

@export var hours_logged_cont : VBoxContainer
@export var aux_cont : VBoxContainer
@export var delete_script : Script

func add_data_to_gui(new_time_entry : TimeEntry) -> void:
	# This adds the actual LineEdits to display data on main page

	# Prepare data to be added to GUI
	var new_time_label : LineEdit = LineEdit.new()
	var new_date_label : DateLabel = DateLabel.new()
	var hbox : HBoxContainer = HBoxContainer.new()
	hbox.add_to_group("Save")
	
	# Setup text display fields
	new_date_label.text = new_time_entry.date
	#new_date_label.set_script(load("res://date_label.gd"))
	new_time_label.text = str(new_time_entry.time)
	new_time_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	new_date_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	# Add new data to hours_logged vbox container
	hbox.add_child(new_date_label)
	hbox.add_child(new_time_label)
	hours_logged_cont.add_child(hbox)

	# Add a delete button
	var new_delete_button : DeleteButton = DeleteButton.new()
	new_delete_button.text = "Remove"
	new_delete_button.set_script(delete_script)
	new_delete_button.initiate(hbox, new_time_entry)
	
	aux_cont.add_child(new_delete_button)


func clear_contents() -> void:
	for child in hours_logged_cont.get_children():
		child.queue_free()
	for child in aux_cont.get_children():
		child.queue_free()
