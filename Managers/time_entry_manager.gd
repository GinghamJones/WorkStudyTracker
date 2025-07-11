extends Node

var entries : Array[TimeEntry]

signal entry_added
#signal deleted_data
signal request_update_total


func _ready() -> void:
	SignalManager.register_listener(self)

func _on_system_ready() -> void:
	#entry_added.connect(Globals.main_scene.gui_main.add_data_to_gui)
	entry_added.connect(GuiManager.pass_data_to_gui)
	request_update_total.connect(Globals.main_scene.update_total)
	#deleted_data.connect(Globals.main_scene.update_total)
	

func add_entry(date, hours) -> bool:
	var new_time_entry : TimeEntry = TimeEntry.new()
	if not new_time_entry.check_data(date, hours):
		return false
	
	new_time_entry.set_data(date, hours)
	entries.append(new_time_entry)
	entry_added.emit(new_time_entry)
	request_update_total.emit()
	return true
	
	
	#Globals.main_scene.update_total()


func remove_entry(delete_button : DeleteButton) -> void:
	for e in entries:
		if delete_button.time_entry == e:
			entries.erase(e)
	delete_button.corresponding_line.queue_free()
	delete_button.queue_free()
	#deleted_data.emit()
	request_update_total.emit()

func clear_all_entries() -> void:
	entries.clear()


func get_total_hours() -> float:
	var total = 0
	for e in entries:
		total += e.time
	
	return total


func get_entries() -> Array[TimeEntry]:
	return entries
