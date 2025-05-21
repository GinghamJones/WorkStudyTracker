class_name DeleteFileWindow
extends AcceptDialog

func _ready():
	show()
	
	# One time check to make sure save directory exists. Create it if not.
	if not DirAccess.dir_exists_absolute(FileManager.save_folder_path):
		DirAccess.make_dir_absolute(FileManager.save_folder_path)

	# Loop through dir to display available save files
	var dir = DirAccess.open(FileManager.save_folder_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			var button : Button = Button.new()
			button.text = file_name
			$ScrollContainer/VBoxContainer.add_child(button)
			button.pressed.connect(delete_file.bind(button.text))
			file_name = dir.get_next()


func delete_file(file_to_delete : String) -> void:
	var file_to_delete_path : String = FileManager.get_filename_as_full_path(file_to_delete)
	var cur_save_file_path : String = FileManager.get_filename_as_full_path(Globals.cur_save_file)
	if file_to_delete_path == cur_save_file_path:
		print("Attempting to delete cur save file. Add code to handle this")
		return
	DirAccess.remove_absolute(file_to_delete_path)
	queue_free()


func _on_canceled() -> void:
	queue_free()
