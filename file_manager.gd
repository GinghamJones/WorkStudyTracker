extends Node

var config_file_path : String = "user://settings.ini"
var save_folder_path : String = "user://saves/"


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
	
	Globals.cur_save_file = new_save_file_path
	Globals.main_scene.update_total()


func get_filename_as_full_path(filename : String) -> String:
	var new_filename : String = filename
	if not new_filename.begins_with(save_folder_path):
		new_filename = new_filename.insert(0, save_folder_path)
	if not new_filename.ends_with(".sav"):
		new_filename += ".sav"
	
	return new_filename
