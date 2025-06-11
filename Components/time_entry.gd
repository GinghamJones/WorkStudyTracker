class_name TimeEntry
extends Resource

var date : String :
	get:
		return date
	set(value):
		date = value

var time : int : 
	get:
		return time 
	set(value):
		time = value


func get_data_as_text() -> Array[String]:
	return [date, str(time)]


func set_data(new_date : String, new_time : String):
	## Do something to check for proper formatting. Might just do this in individual setters ##
	date = new_date
	time = int(new_time)


func check_data(new_date : String, new_time : String) -> bool:
	# Check date
	var r : RegEx = RegEx.new()
	r.compile("^(0[1-9]|1[0-2])/(0[1-9]|[12][0-9]|3[01])$")
	var check := r.search(new_date)
	if check == null:
		return false
	
	var r2 : RegEx = RegEx.new()
	r2.compile("^[0-9].[0-9]$")
	var check2 := r2.search(new_time)
	if check2 == null:
		return false
	
	return true
