extends Control

@export var hours_logged_cont: VBoxContainer
@export var gui_main: GUIMain
@export var addbutton: Button
@export var delete_script : Script 
@export var title_label : Label

@export var total: Label
@export var hours_left: Label
@export var money_earned: Label
@export var bottom_gui : MarginContainer
var max_hours : int
var wage : float
var term : String

var canceled : bool = false
#var cur_save_file : String
var cur_file_browser = null
var is_quitting : bool = false
var time_entries : Array[TimeEntry] = []
var is_saved : bool = false
var auto_save_enabled : bool = true
var just_started : bool = true # Logs if program is just opened


func _ready() -> void:
	Globals.main_scene = self
	just_started = true
	
	# Open res://settings.ini
	var new_file : ConfigFile = FileManager.get_config_file()
	var err = new_file.load(FileManager.config_file_path)
	if err:
		print("Error opening file %s" % err)
		return
	if new_file.has_section("files"):
		Globals.cur_save_file = new_file.get_value("files", "cur_save_file")
	if Globals.cur_save_file == "":
		bottom_gui.hide_contents()
		print("Ready: cur_save_file not ultimately found")
		return
	
	open_file(Globals.cur_save_file)
	just_started = false


func cancel():
	print("canceled")
	canceled = true
	return


func remove_time(line_to_remove, delete_button : DeleteButton):
	# Remove entry in time_entries array
	if time_entries.has(delete_button.time_entry):
		for index in time_entries.size():
			if time_entries[index] == delete_button.time_entry:
				time_entries.remove_at(index)
				break
	else:
		print("Teh fuck happened to the time_entry???")
	
	# Takes corresponding vbox container w/ lineedits and delete button and removes them
	for c in line_to_remove.get_children():
		c.text = "0"
		c.queue_free()
	line_to_remove.queue_free()
	delete_button.queue_free()
	update_total()


func update_total():
	var new_total : float = 0
	for entry in time_entries:
		new_total += entry.time
	
	total.text = "Total: " + str(new_total)
	hours_left.text = "Hours remaining: " + str(Globals.max_hours - new_total)
	money_earned.text = "Cash earned: $%*.*f" % [7, 2, (new_total * Globals.wage)]
	
	#if auto_save_enabled:
		#save()


func add_data(date : String, time : String) -> void:
	is_saved = false
	# Create new time entry
	var new_time_entry : TimeEntry = TimeEntry.new()
	new_time_entry.set_data(date, time)
	time_entries.append(new_time_entry)
	
	gui_main.add_data_to_gui(new_time_entry)
	update_total()


func _on_quit_button_pressed() -> void:
	# Setup confirmation window
	if not is_saved:
		var popup : ConfirmationDialog = ConfirmationDialog.new()
		add_child(popup)
		popup.popup_centered(Vector2i(2, 2))
		
		popup.dialog_text = "Do you want to save?"
		popup.cancel_button_text = "Cancel"
		popup.ok_button_text = "Save"
		popup.add_button("Quit Without Saving", false, "quit")
		
		popup.confirmed.connect(Callable(self, "save"))
		popup.canceled.connect(Callable(self, "cancel_dialogue"))
		popup.custom_action.connect(_custom_action_pressed)
		
		popup.show()
	else:
		print("_on_quit_button_pressed file already saved")
		quit()
	is_quitting = true


func open_new_file_dialog() -> void:
	var new_file_dialog : NewFileWindow = NewFileWindow.new()
	add_child(new_file_dialog)


func create_new_file(new_term : String, new_max_hours : String, new_wage : String) -> void:
	if Globals.cur_save_file != "" and auto_save_enabled:
		save()
	
	Globals.term = new_term
	Globals.max_hours = int(new_max_hours)
	Globals.wage = float(new_wage)
	
	gui_main.clear_contents()
	var filename : String = new_term
	if not filename.ends_with(".sav"):
		filename += ".sav"
	bottom_gui.show_contents()
	Globals.cur_save_file = FileManager.save_folder_path + filename
	open_file(Globals.cur_save_file)


#func save_as() -> void:
	#open_file_dialog(true)


func open_file_dialog(is_saving : bool) -> void:
	var window : AcceptDialog = AcceptDialog.new()
	window.set_script(load("res://Windows/open_file_window.gd"))
	add_child(window)
	cur_file_browser = window
	window.initiate(Callable(self, "open_file"))


func open_file(filename : String) -> void:
	if not is_saved and not just_started and Globals.auto_save_enabled:
		## If not auto-save, dialog asking to save
		save()
	
	Globals.cur_save_file = filename
	var save_file = FileManager.get_save_file(filename, FileAccess.READ)
	if not save_file:
		return
	
	# Clear previous data
	gui_main.clear_contents()
	time_entries = []
	
	# Create main display from save data
	while(true):
		# Get the data from save file
		var line : String = save_file.get_line()
		if not line:
			break
		var separated_data : PackedStringArray = line.split("|")
		separated_data[0] = separated_data[0].strip_edges()
		separated_data[1] = separated_data[1].strip_edges()
		
		# Assign variables from extracted data
		if separated_data[0] == "term":
			Globals.term = separated_data[1]
			title_label.text = Globals.term
			continue
		elif separated_data[0] == "max_hours":
			Globals.max_hours = int(separated_data[1])
			continue
		elif separated_data[0] == "wage":
			Globals.wage = float(separated_data[1])
			continue
		else:
			add_data(separated_data[0], separated_data[1])
	
	save_file.close()
	
	update_total()
	bottom_gui.show_contents()
	
	if cur_file_browser:
		cur_file_browser.queue_free()


func save() -> void:
	var save_file = FileManager.get_save_file(Globals.cur_save_file, FileAccess.WRITE)
	
	######## Save all data #########
	var filename : String = Globals.cur_save_file.lstrip(FileManager.save_folder_path)
	filename = filename.rstrip(".sav")
	save_file.store_line("term | %s" % str(Globals.term))
	save_file.store_line("max_hours | %s" % str(Globals.max_hours))
	save_file.store_line("wage | %s" % str(Globals.wage))

	for entry in time_entries:
		var data : Array[String] = entry.get_data_as_text()
		save_file.store_line(data[0] + "|" + data[1])
	################################
	
	# Cleanup
	is_saved = true
	if cur_file_browser:
		cur_file_browser.queue_free()
	save_file.close()
	if is_quitting:
		is_quitting = false
		quit()


func _custom_action_pressed(action : String) -> void:
	if action == "quit":
		quit()


func quit() -> void:
	var config_file : ConfigFile = FileManager.get_config_file()
	print("current save: %s" % Globals.cur_save_file)
	config_file.set_value("files", "cur_save_file", Globals.cur_save_file)
	var err = config_file.save(FileManager.config_file_path)
	if err:
		print("Something went wrong with config file")
	
	get_tree().quit()
