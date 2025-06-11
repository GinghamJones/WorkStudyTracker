class_name TimeEntry
extends Resource

var date : String :
	get:
		return date
	set(value):
		date = value

var time : float : 
	get:
		return time 
	set(value):
		time = value


func get_data_as_text() -> Array[String]:
	return [date, str(time)]


func set_data(new_date : String, new_time : String):
	## Do something to check for proper formatting. Might just do this in individual setters ##
	if not check_data:
		return
	date = new_date
	time = float(new_time)


func check_data(new_date : String, new_time : String) -> bool:
	# Check date for mm/dd
	var r : RegEx = RegEx.new()
	r.compile("^(0[1-9]|1[0-2])/(0[1-9]|[12][0-9]|3[01])$")
	var check := r.search(new_date)
	if check == null:
		return false
	
	# Check time for valid float within reasonable range
	var new_time_as_float : float = new_time as float
	if not new_time.is_valid_float() and new_time_as_float > 12.0:
		return false
	
	return true
