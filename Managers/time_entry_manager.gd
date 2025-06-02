extends Node

var entries : Array[TimeEntry]

signal entry_added


func _ready() -> void:
	await(get_tree().physics_frame)
	entry_added.connect(Callable(Globals.main_scene.gui_main, "add_data_to_gui"))


func add_entry(date, hours) -> void:
	var new_time_entry : TimeEntry = TimeEntry.new()
	new_time_entry.set_data(date, hours)
	entries.append(new_time_entry)
	entry_added.emit(new_time_entry)
	Globals.main_scene.update_total()


func get_total_hours() -> float:
	var total = 0
	for e in entries:
		total += e.time
	
	return total


func get_entries() -> Array[TimeEntry]:
	return entries
