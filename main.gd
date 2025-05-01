extends Control

@export var hours_logged_cont: VBoxContainer
@export var gui_main: GUIMain
@export var addbutton: Button
@onready var delete_script : Script = preload("res://delete_button.gd")
@export var total: Label
@export var hours_left: Label
@export var money_earned: Label
@export var config_file_path : String

var canceled : bool = false
var cur_save_file : String
var cur_file_browser : FileDialog = null
var is_quitting : bool = false
var time_entries : Array[TimeEntry] = []
var cur_term : String
var is_saved : bool = false
var auto_save_enabled : bool = true


func _ready() -> void:
	# Open res://settings.ini
	if not FileAccess.file_exists(config_file_path):
		print("File does not exist")
		var new_file : ConfigFile = ConfigFile.new()
		new_file.set_value("files", "cur_save_file", "")
		new_file.save(config_file_path)
	else:
		var new_file : ConfigFile = ConfigFile.new()
		var err = new_file.load(config_file_path)
		if err:
			print("Error opening file %s" % err)
			return
		if new_file.has_section("files"):
			cur_save_file = new_file.get_value("files", "cur_save_file")
	if not cur_save_file:
		print("Ready: cur_save_file not ultimately found")
		return
	
	open_file(cur_save_file)


func cancel():
	print("canceled")
	canceled = true
	return


func remove_time(line_to_remove, delete_button : DeleteButton):
	# Takes corresponding vbox container and delete button and removes them
	for c in line_to_remove.get_children():
		c.text = "0"
		c.queue_free()
	line_to_remove.queue_free()
	if time_entries.has(delete_button.time_entry):
		print("We found the entry to delete")
		for index in time_entries.size():
			if time_entries[index] == delete_button.time_entry:
				print(time_entries)
				time_entries.remove_at(index)
				print(time_entries)
	else:
		print(time_entries)
	delete_button.queue_free()
	update_total()
	if auto_save_enabled:
		save()


func update_total():
	var new_total : float = 0
	for entry in time_entries:
		new_total += entry.time
	
	total.text = "Total: " + str(new_total)
	hours_left.text = "Hours remaining: " + str(140 - new_total)
	money_earned.text = "Cash earned: $%*.*f" % [7, 2, (new_total * 14.70)]
	if auto_save_enabled:
		save()


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


func save_as() -> void:
	open_file_dialog(true)


func open_file_dialog(is_saving : bool) -> void:
	var file_browser : FileDialog = FileDialog.new()
	print("file browser created")
	add_child(file_browser)
	file_browser.show()
	file_browser.access = FileDialog.ACCESS_FILESYSTEM
	file_browser.current_dir = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)
	file_browser.add_filter("sav")
	#file_browser.use_native_dialog = true
	if is_saving:
		file_browser.file_mode = FileDialog.FILE_MODE_SAVE_FILE
		file_browser.name = "Save File"
		file_browser.confirmed.connect(save_file_chosen)
		file_browser.file_selected.connect(Callable(self, "save_file_chosen"))
	else:
		file_browser.file_mode = FileDialog.FILE_MODE_OPEN_FILE
		file_browser.name = "Open File"
		file_browser.file_selected.connect(open_file)
	cur_file_browser = file_browser


func save_file_chosen(path : String) -> void:
	## Method to specify file name when opening save as dialog
	var file_name : String = path
	if not file_name.ends_with(".sav"):
		file_name += "sav"
	cur_save_file = file_name
	print(cur_save_file)
	save()


func open_file(filename : String) -> void:
		# Open last used file if available
	var save_file = FileAccess.open(filename, FileAccess.READ)
	if not save_file:
		print("No file found in Ready.")
		return
	
	if not is_saved:
		## Make dialog asking to save
		print("File is not saved when closing to open new file.")
	# Clear previous data
	gui_main.clear_contents()
	time_entries = []
	
	while(true):
		# Get the data from save file
		var line : String = save_file.get_line()
		if not line:
			break
		var separated_data : PackedStringArray = line.split("|")
		separated_data[0] = separated_data[0].strip_edges()
		separated_data[1] = separated_data[1].strip_edges()
		print("Separated data: %s|%s" % [separated_data[0], separated_data[1]])
		add_data(separated_data[0], separated_data[1])
	
	save_file.close()
	update_total()
	
	if cur_file_browser:
		cur_file_browser.queue_free()


func save() -> void:
	if not FileAccess.file_exists(cur_save_file):
		print("Save file not found?")
		save_as()
		
	var save_file = FileAccess.open(cur_save_file, FileAccess.WRITE)
	#print(FileAccess.get_open_error())
	print(cur_save_file)
	if not save_file:
		return
	
	#save_file.store_line("cur_save_file | %s" % cur_save_file)
	
	for entry in time_entries:
		var data : Array[String] = entry.get_data_as_text()
		save_file.store_line(data[0] + "|" + data[1])
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
	var config_file : ConfigFile = ConfigFile.new()
	var err = config_file.load(config_file_path)
	if err:
		print("Error finding config file")
	else:
		config_file.set_value("files", "cur_save_file", cur_save_file)
	
	config_file.save(config_file_path)
	get_tree().quit()
