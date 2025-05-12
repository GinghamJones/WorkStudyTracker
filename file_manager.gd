extends Node

var config_file_path : String = "user://settings.ini"
var save_folder_path : String = "user://saves/"


func get_save_file(filename : String, access_mode : FileAccess.ModeFlags) -> FileAccess:
	if not filename.begins_with(save_folder_path):
		filename = filename.insert(0, save_folder_path)
	if not filename.ends_with(".sav"):
		filename += ".sav"
	var file = FileAccess.open(filename, access_mode)
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
