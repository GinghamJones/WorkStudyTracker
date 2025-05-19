class_name DeleteFileWindow
extends AcceptDialog

func initiate():
	title = "Delete File"
	#popup_centered()
	initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_MAIN_WINDOW_SCREEN
	size = Vector2(300, 300)
	show()
	print("window showed")
	
	# One time check to make sure save directory exists. Create it if not.
	if not DirAccess.dir_exists_absolute(FileManager.save_folder_path):
		DirAccess.make_dir_absolute(FileManager.save_folder_path)

	# Loop through dir to display available save files
	var dir = DirAccess.open(FileManager.save_folder_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		var vbox : VBoxContainer = VBoxContainer.new()
		add_child(vbox)
		while file_name != "":
			var button : Button = Button.new()
			button.text = file_name
			vbox.add_child(button)
			button.pressed.connect(delete_file.bind(button.text))
			file_name = dir.get_next()


func delete_file(file_to_delete : String) -> void:
	var dir = DirAccess.open(FileManager.save_folder_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_to_delete == file_name:
				dir.remove(file_to_delete)
				queue_free()
				return
		file_name = dir.get_next()
