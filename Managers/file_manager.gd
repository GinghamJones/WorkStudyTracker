extends Node

var config_file_path : String = "user://settings.ini"
var save_folder_path : String = "user://saves/"

signal file_deleted
signal save_needed
signal update_total_needed

func _ready() -> void:
	SignalManager.register_listener(self)


func _on_system_ready() -> void:
	# Connect all da signals
	var main := get_tree().get_first_node_in_group("Main")
	file_deleted.connect(main._on_file_deleted)
	save_needed.connect(main.save)
	update_total_needed.connect(main.update_total)


func create_new_file(filename : String) -> bool:
	var filename_full_path : String = get_filename_as_full_path(filename)
	var file = FileAccess.open(filename_full_path, FileAccess.WRITE)
	if file:
		return true
	else:
		print("No good creating file")
		return false


func get_save_file(filename : String, access_mode : FileAccess.ModeFlags) -> FileAccess:
	var filename_full_path : String = get_filename_as_full_path(filename)
	var file = FileAccess.open(filename_full_path, access_mode)
	
	## Might need to handle for full production ##
	if not file:
		print("Could not retrieve save file %s...." % filename)
		return
	
	return file


func get_config_file() -> ConfigFile:
	# Create base config file
	if not FileAccess.file_exists(config_file_path):
		var new_file : ConfigFile = ConfigFile.new()
		new_file.set_value("files", "cur_save_file", "")
		new_file.set_value("settings", "auto_save_enabled", "true")
		new_file.save(FileManager.config_file_path)
		return new_file
	
	var config_file : ConfigFile = ConfigFile.new()
	var err = config_file.load(config_file_path)
	if err:
		print("Error finding config file")
		return
	
	return config_file


func rename_file(new_file_name : String) -> void:
	var cur_save_file_path : String = get_filename_as_full_path(Globals.cur_save_file)
	var new_save_file_path : String = get_filename_as_full_path(new_file_name)
	
	DirAccess.rename_absolute(cur_save_file_path, new_save_file_path)
	DirAccess.remove_absolute(cur_save_file_path)
	
	Globals.term = new_file_name
	Globals.cur_save_file = new_save_file_path
	save_needed.emit()
	open_file(new_save_file_path)


func open_file(filename : String) -> void:
	Globals.cur_save_file = filename
	var save_file = get_save_file(filename, FileAccess.READ)
	if not save_file:
		GuiManager.hide_bottom_gui()
		return
	
	# Clear previous data
	GuiManager.clear_gui_main()
	TimeEntryManager.clear_all_entries()
	
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
		elif separated_data[0] == "max_hours":
			Globals.max_hours = int(separated_data[1])
		elif separated_data[0] == "wage":
			Globals.wage = float(separated_data[1])
		else:
			TimeEntryManager.add_entry(separated_data[0], separated_data[1])
	
	save_file.close()
	
	update_total_needed.emit()
	GuiManager.show_bottom_gui()
	GuiManager.show_gui_main()


func delete_file(file_to_delete : String, is_cur_save_file : bool) -> void:
	DirAccess.remove_absolute(file_to_delete)
	Globals.cur_save_file = ""
	if is_cur_save_file:
		GuiManager.clear_gui_main()
		GuiManager.hide_bottom_gui()


func get_filename_as_full_path(filename : String) -> String:
	var new_filename : String = filename
	if not new_filename.begins_with(save_folder_path):
		new_filename = new_filename.insert(0, save_folder_path)
	if not new_filename.ends_with(".sav"):
		new_filename += ".sav"
	
	return new_filename
